import 'package:serverpod/serverpod.dart';

import '../auth/current_user.dart';
import '../generated/protocol.dart';
import '../live/live_hub.dart';
import '../util/rate_limit.dart';
import 'social_util.dart';

const _lobbyIdle = Duration(hours: 3);

class FriendsEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Friends, pending requests, blocks and room invites for the caller.
  Future<FriendsView> list(Session session) async {
    final me = requireUserId(session);
    await _checkIn(session, me);
    final rows = await Friendship.db.find(
      session,
      where: (f) => f.requesterId.equals(me) | f.addresseeId.equals(me),
    );
    final friends = <PersonView>[], incoming = <PersonView>[], outgoing = <PersonView>[];
    for (final f in rows) {
      final other = f.requesterId == me ? f.addresseeId : f.requesterId;
      final person = await personOf(session, other);
      if (f.status == 'accepted') {
        friends.add(person);
      } else if (f.addresseeId == me) {
        incoming.add(person);
      } else {
        outgoing.add(person);
      }
    }
    final blocks = await UserBlock.db.find(session, where: (b) => b.userId.equals(me));
    final blocked = [for (final b in blocks) await personOf(session, b.blockedUserId)];

    final invites = <InviteView>[];
    final mine = await LobbyInvite.db.find(session, where: (i) => i.toUserId.equals(me));
    for (final i in mine) {
      final lobby = await Lobby.db.findById(session, i.lobbyId);
      final live = lobby != null &&
          lobby.status == 'open' &&
          DateTime.now().toUtc().difference(lobby.updatedAt) < _lobbyIdle &&
          lobby.guestUserId == null;
      if (!live) {
        await LobbyInvite.db.deleteRow(session, i);
        continue;
      }
      invites.add(
        InviteView(
          lobbyId: i.lobbyId,
          code: lobby.code,
          fromName: await displayNameOf(session, i.fromUserId),
          fromAvatar: await avatarOf(session, i.fromUserId),
          createdAt: i.createdAt,
        ),
      );
    }
    friends.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return FriendsView(
      friends: friends,
      incoming: incoming,
      outgoing: outgoing,
      blocked: blocked,
      invites: invites,
    );
  }

  /// Sends a friend request by exact display name (case does not matter).
  Future<FriendsView> request(Session session, String name) async {
    final profile = await requireProfile(session);
    rateLimit(profile.userId, 'friend.request', max: 10, window: const Duration(minutes: 10));
    final target = await UserProfile.db.findFirstRow(
      session,
      where: (t) => t.displayNameLower.equals(name.trim().toLowerCase()),
    );
    if (target == null) throw GameException(message: 'No player has that exact name.');
    if (target.userId == profile.userId) throw GameException(message: 'That is you.');
    if (await isBlockedEitherWay(session, profile.userId, target.userId)) {
      throw GameException(message: 'No player has that exact name.');
    }
    final existing = await _between(session, profile.userId, target.userId);
    if (existing != null) {
      if (existing.status == 'pending' && existing.addresseeId == profile.userId) {
        existing.status = 'accepted';
        await Friendship.db.updateRow(session, existing);
      }
      liveHub.notify([target.userId, profile.userId], 'friends');
      return list(session);
    }
    await Friendship.db.insertRow(
      session,
      Friendship(requesterId: profile.userId, addresseeId: target.userId, status: 'pending'),
    );
    liveHub.notify([target.userId], 'friends');
    return list(session);
  }

  Future<FriendsView> accept(Session session, String userId) async {
    final me = requireUserId(session);
    final f = await Friendship.db.findFirstRow(
      session,
      where: (t) => t.requesterId.equals(userId) & t.addresseeId.equals(me) & t.status.equals('pending'),
    );
    if (f == null) throw GameException(message: 'There is no request from that player.');
    f.status = 'accepted';
    await Friendship.db.updateRow(session, f);
    liveHub.notify([userId], 'friends');
    return list(session);
  }

  /// Declines a request, cancels one you sent, or removes a friend.
  Future<FriendsView> remove(Session session, String userId) async {
    final me = requireUserId(session);
    final f = await _between(session, me, userId);
    if (f != null) await Friendship.db.deleteRow(session, f);
    liveHub.notify([userId], 'friends');
    return list(session);
  }

  /// Blocks a player: the friendship ends and neither can invite or join the other.
  Future<FriendsView> block(Session session, String userId) async {
    final profile = await requireProfile(session);
    if (userId == profile.userId) throw GameException(message: 'You cannot block yourself.');
    rateLimit(profile.userId, 'friend.block', max: 20, window: const Duration(minutes: 10));
    final f = await _between(session, profile.userId, userId);
    if (f != null) await Friendship.db.deleteRow(session, f);
    final already = await UserBlock.db.findFirstRow(
      session,
      where: (b) => b.userId.equals(profile.userId) & b.blockedUserId.equals(userId),
    );
    if (already == null) {
      await UserBlock.db.insertRow(session, UserBlock(userId: profile.userId, blockedUserId: userId));
    }
    // Any open invite either way is withdrawn.
    await LobbyInvite.db.deleteWhere(
      session,
      where: (i) =>
          (i.fromUserId.equals(profile.userId) & i.toUserId.equals(userId)) |
          (i.fromUserId.equals(userId) & i.toUserId.equals(profile.userId)),
    );
    return list(session);
  }

  Future<FriendsView> unblock(Session session, String userId) async {
    final me = requireUserId(session);
    await UserBlock.db.deleteWhere(
      session,
      where: (b) => b.userId.equals(me) & b.blockedUserId.equals(userId),
    );
    return list(session);
  }

  /// The host invites a friend into their open room.
  Future<void> invite(Session session, String userId, UuidValue lobbyId) async {
    final profile = await requireProfile(session);
    rateLimit(profile.userId, 'friend.invite', max: 20, window: const Duration(minutes: 10));
    final lobby = await Lobby.db.findById(session, lobbyId);
    if (lobby == null || lobby.hostUserId != profile.userId || lobby.status != 'open') {
      throw GameException(message: 'Only the host of an open room can invite.');
    }
    final f = await _between(session, profile.userId, userId);
    if (f == null || f.status != 'accepted') throw GameException(message: 'You can only invite friends.');
    if (await isBlockedEitherWay(session, profile.userId, userId)) {
      throw GameException(message: 'You cannot invite that player.');
    }
    final dup = await LobbyInvite.db.findFirstRow(
      session,
      where: (i) => i.lobbyId.equals(lobbyId) & i.toUserId.equals(userId),
    );
    if (dup == null) {
      await LobbyInvite.db.insertRow(
        session,
        LobbyInvite(lobbyId: lobbyId, fromUserId: profile.userId, toUserId: userId),
      );
    }
    liveHub.notify([userId], 'friends');
  }

  Future<FriendsView> dismissInvite(Session session, UuidValue lobbyId) async {
    final me = requireUserId(session);
    await LobbyInvite.db.deleteWhere(
      session,
      where: (i) => i.lobbyId.equals(lobbyId) & i.toUserId.equals(me),
    );
    return list(session);
  }

  /// Polling this is how the app says "I am here"; writes are throttled to one per 25 s.
  Future<void> _checkIn(Session session, String me) async {
    final p = await UserProfile.db.findFirstRow(session, where: (t) => t.userId.equals(me));
    if (p == null) return;
    final seen = p.lastSeenAt;
    if (seen != null && DateTime.now().toUtc().difference(seen) < const Duration(seconds: 25)) return;
    p.lastSeenAt = DateTime.now().toUtc();
    await UserProfile.db.updateRow(session, p);
  }

  Future<Friendship?> _between(Session session, String a, String b) {
    return Friendship.db.findFirstRow(
      session,
      where: (f) =>
          (f.requesterId.equals(a) & f.addresseeId.equals(b)) |
          (f.requesterId.equals(b) & f.addresseeId.equals(a)),
    );
  }
}
