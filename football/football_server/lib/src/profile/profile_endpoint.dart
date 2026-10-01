import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart' show AuthServices;

import '../auth/current_user.dart';
import '../data/world_cup_data.dart';
import '../generated/protocol.dart';

final _nameChars = RegExp(r'^[A-Za-z0-9_\-]{3,16}$');
const _reserved = {'admin', 'moderator', 'system', 'removed', 'cpu', 'fifa'};

class ProfileEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// The caller's profile, or null before they have picked a display name.
  Future<UserProfile?> me(Session session) {
    return UserProfile.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(requireUserId(session)),
    );
  }

  Future<bool> isNameAvailable(Session session, String displayName) async {
    if (!_nameChars.hasMatch(displayName) || _reserved.contains(displayName.toLowerCase())) {
      return false;
    }
    final taken = await UserProfile.db.findFirstRow(
      session,
      where: (t) => t.displayNameLower.equals(displayName.toLowerCase()),
    );
    return taken == null;
  }

  Future<UserProfile> createProfile(
    Session session,
    String displayName,
    bool acceptTerms,
  ) async {
    final userId = requireUserId(session);
    if (!acceptTerms) throw GameException(message: 'Accept the terms to continue.');
    if (await me(session) != null) throw GameException(message: 'Profile already exists.');
    if (!await isNameAvailable(session, displayName)) {
      throw GameException(message: 'That name is invalid or already taken (3-16 letters, digits, _ or -).');
    }
    try {
      return await UserProfile.db.insertRow(
        session,
        UserProfile(
          userId: userId,
          displayName: displayName,
          displayNameLower: displayName.toLowerCase(),
          termsAcceptedAt: DateTime.now().toUtc(),
        ),
      );
    } on DatabaseException {
      // Lost a race on the unique name index.
      throw GameException(message: 'That name is already taken.');
    }
  }

  Future<UserProfile> updateProfile(
    Session session,
    String? region,
    String? favouriteNation,
  ) async {
    final profile = await requireProfile(session);
    if (favouriteNation != null && !wcNations.containsKey(favouriteNation)) {
      throw GameException(message: 'Unknown nation.');
    }
    if (region != null && region.length > 40) throw GameException(message: 'Region too long.');
    return UserProfile.db.updateRow(
      session,
      profile.copyWith(region: region, favouriteNation: favouriteNation),
    );
  }

  /// Friend-match record: wins, draws, losses, abandoned matches, and per-opponent results.
  /// A draw is a draw. An abandoned or void match counts for nobody.
  Future<RecordView> record(Session session) async {
    final me = requireUserId(session);
    final rows = await FriendMatch.db.find(
      session,
      where: (m) =>
          (m.hostUserId.equals(me) | m.guestUserId.equals(me)) &
          (m.status.equals('finished') | m.status.equals('abandoned')),
      orderBy: (m) => m.startedAt.desc(),
      limit: 1000,
    );
    var wins = 0, draws = 0, losses = 0, abandoned = 0;
    final byOpponent = <String?, List<int>>{}; // [w, d, l]
    for (final m in rows) {
      if (m.status == 'abandoned') {
        abandoned++;
        continue;
      }
      final opp = m.hostUserId == me ? m.guestUserId : m.hostUserId;
      final t = byOpponent.putIfAbsent(opp, () => [0, 0, 0]);
      if (m.winnerUserId == null) {
        draws++;
        t[1]++;
      } else if (m.winnerUserId == me) {
        wins++;
        t[0]++;
      } else {
        losses++;
        t[2]++;
      }
    }
    final h2h = <HeadToHead>[];
    for (final e in byOpponent.entries) {
      final name = e.key == null ? 'Removed player' : (await UserProfile.db.findFirstRow(session, where: (t) => t.userId.equals(e.key!)))?.displayName ?? 'Removed player';
      h2h.add(HeadToHead(opponentName: name, opponentUserId: e.key, wins: e.value[0], draws: e.value[1], losses: e.value[2]));
    }
    h2h.sort((a, b) => (b.wins + b.draws + b.losses).compareTo(a.wins + a.draws + a.losses));
    return RecordView(wins: wins, draws: draws, losses: losses, abandoned: abandoned, headToHead: h2h);
  }

  /// Deletes the account and its personal data. Finished friend matches stay for the
  /// other player, who sees "Removed player".
  Future<void> deleteAccount(Session session) async {
    final me = requireUserId(session);
    await session.db.transaction((tx) async {
      final runs = await Tournament.db.find(session, where: (t) => t.userId.equals(me), transaction: tx);
      for (final t in runs) {
        await TournamentFixture.db.deleteWhere(session, where: (f) => f.tournamentId.equals(t.id!), transaction: tx);
      }
      await Tournament.db.deleteWhere(session, where: (t) => t.userId.equals(me), transaction: tx);
      await Friendship.db.deleteWhere(session, where: (f) => f.requesterId.equals(me) | f.addresseeId.equals(me), transaction: tx);
      await UserBlock.db.deleteWhere(session, where: (b) => b.userId.equals(me) | b.blockedUserId.equals(me), transaction: tx);
      await LobbyInvite.db.deleteWhere(session, where: (i) => i.fromUserId.equals(me) | i.toUserId.equals(me), transaction: tx);
      await LobbyMessage.db.deleteWhere(session, where: (m) => m.userId.equals(me), transaction: tx);
      final open = await Lobby.db.find(session, where: (l) => l.hostUserId.equals(me) & l.status.equals('open'), transaction: tx);
      for (final l in open) {
        l.status = 'closed';
        await Lobby.db.updateRow(session, l, transaction: tx);
      }
      await UserProfile.db.deleteWhere(session, where: (t) => t.userId.equals(me), transaction: tx);
      await AuthServices.instance.authUsers.delete(session, authUserId: UuidValue.fromString(me), transaction: tx);
    });
  }
}
