import 'dart:math';

import 'package:serverpod/serverpod.dart';

import '../auth/current_user.dart';
import '../data/world_cup_data.dart';
import '../friend/lobby_endpoint.dart';
import '../generated/protocol.dart';
import '../live/live_hub.dart';
import '../social/social_util.dart';
import '../util/rate_limit.dart';

final _rng = Random.secure();

/// A player who stops asking for this long is no longer waiting.
const _stale = Duration(seconds: 20);

/// How far apart two ratings may be at first, and how much wider the window gets each second both wait.
const _baseWindow = 100;
const _widenPerSecond = 15;

/// Find an opponent without needing a friend: players press "Find a match", the server pairs two who are
/// waiting for the same game with a similar rating (a wider net the longer they wait), seats them in a
/// room with nations chosen for them, and starts the match.
class MatchmakingEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Joins the queue for [mode] (`match` or `penalties`) and returns where things stand.
  Future<QueueStatus> join(Session session, String mode, String clientVersion) async {
    final profile = await requireProfile(session);
    rateLimit(profile.userId, 'queue.join', max: 10);
    await assertNotInMaintenance(session);
    if (!roomModes.contains(mode)) throw GameException(message: 'Unknown game mode.');
    final now = DateTime.now().toUtc();
    await session.db.transaction((tx) async {
      await QueueEntry.db.deleteWhere(session, where: (q) => q.userId.equals(profile.userId), transaction: tx);
      await QueueEntry.db.insertRow(
        session,
        QueueEntry(
          userId: profile.userId,
          mode: mode,
          clientVersion: clientVersion,
          rating: profile.rating,
          joinedAt: now,
          lastPollAt: now,
        ),
        transaction: tx,
      );
    });
    await _tryPair(session, profile.userId);
    return _status(session, profile.userId);
  }

  /// Where the caller's search stands. Asking also keeps the search alive and tries to pair again.
  Future<QueueStatus> status(Session session) async {
    final userId = requireUserId(session);
    final mine = await QueueEntry.db.findFirstRow(session, where: (q) => q.userId.equals(userId));
    if (mine != null && mine.lobbyId == null) {
      mine.lastPollAt = DateTime.now().toUtc();
      await QueueEntry.db.updateRow(session, mine);
      await _tryPair(session, userId);
    }
    return _status(session, userId);
  }

  /// Stops searching. A match that was already found stays.
  Future<void> cancel(Session session) async {
    final userId = requireUserId(session);
    await QueueEntry.db.deleteWhere(session, where: (q) => q.userId.equals(userId) & q.lobbyId.equals(null));
  }

  Future<QueueStatus> _status(Session session, String userId) async {
    final mine = await QueueEntry.db.findFirstRow(session, where: (q) => q.userId.equals(userId));
    if (mine == null) return QueueStatus(searching: false, waitedSecs: 0, mode: 'match', queued: 0);
    if (mine.lobbyId != null) {
      // Found: hand over the room and drop this player's queue entry.
      final lobby = await Lobby.db.findById(session, mine.lobbyId!);
      await QueueEntry.db.deleteWhere(session, where: (q) => q.id.equals(mine.id!)); // idempotent: a push and a poll can ask at once
      if (lobby != null) {
        return QueueStatus(searching: false, waitedSecs: 0, mode: mine.mode, queued: 0, lobby: await buildLobbyView(session, lobby, userId));
      }
      return QueueStatus(searching: false, waitedSecs: 0, mode: mine.mode, queued: 0);
    }
    final cutoff = DateTime.now().toUtc().subtract(_stale);
    final others = await QueueEntry.db.count(
      session,
      where: (q) => q.mode.equals(mine.mode) & q.lobbyId.equals(null) & q.userId.notEquals(userId) & (q.lastPollAt > cutoff),
    );
    return QueueStatus(
      searching: true,
      waitedSecs: DateTime.now().toUtc().difference(mine.joinedAt).inSeconds,
      mode: mine.mode,
      queued: others,
    );
  }

  /// Looks for an opponent for [userId] and, if one is waiting, creates their room and match.
  /// Two players asking at the same instant can lose a database race; the loser just tries again on the next ask.
  Future<void> _tryPair(Session session, String userId) async {
    try {
      Lobby? made;
      String? other;
      await session.db.transaction((tx) async {
        final me = await QueueEntry.db.findFirstRow(
          session,
          where: (q) => q.userId.equals(userId),
          transaction: tx,
          lockMode: LockMode.forUpdate,
        );
        if (me == null || me.lobbyId != null) return;
        final now = DateTime.now().toUtc();
        final fresh = now.subtract(_stale);
        final candidates = await QueueEntry.db.find(
          session,
          where: (q) =>
              q.mode.equals(me.mode) &
              q.clientVersion.equals(me.clientVersion) &
              q.userId.notEquals(userId) &
              q.lobbyId.equals(null) &
              (q.lastPollAt > fresh),
          orderBy: (q) => q.joinedAt,
          limit: 20,
          transaction: tx,
        );
        QueueEntry? pick;
        for (final c in candidates) {
          final waited = max(now.difference(me.joinedAt).inSeconds, now.difference(c.joinedAt).inSeconds);
          if ((c.rating - me.rating).abs() > _baseWindow + _widenPerSecond * waited) continue;
          if (await isBlockedEitherWay(session, userId, c.userId)) continue;
          pick = c;
          break;
        }
        if (pick == null) return;
        final theirs = await QueueEntry.db.findFirstRow(
          session,
          where: (q) => q.id.equals(pick!.id!),
          transaction: tx,
          lockMode: LockMode.forUpdate,
        );
        if (theirs == null || theirs.lobbyId != null) return;

        // The player who has waited longer hosts.
        final hostEntry = theirs.joinedAt.isBefore(me.joinedAt) ? theirs : me;
        final guestEntry = identical(hostEntry, me) ? theirs : me;
        final nations = await _nations(session, hostEntry.userId, guestEntry.userId, tx);
        final lobby = await Lobby.db.insertRow(
          session,
          Lobby(
            code: await freeRoomCode(session, tx: tx),
            hostUserId: hostEntry.userId,
            guestUserId: guestEntry.userId,
            hostNation: nations.$1,
            guestNation: nations.$2,
            hostReady: true,
            guestReady: true,
            mode: me.mode,
            status: 'open',
            clientVersion: me.clientVersion,
            updatedAt: now,
          ),
          transaction: tx,
        );
        await startMatchFor(session, tx, lobby);
        made = await Lobby.db.updateRow(session, lobby, transaction: tx);
        me.lobbyId = made!.id;
        theirs.lobbyId = made!.id;
        await QueueEntry.db.updateRow(session, me, transaction: tx);
        await QueueEntry.db.updateRow(session, theirs, transaction: tx);
        other = theirs.userId;
      });
      if (made != null) liveHub.notify([userId, other], 'queue');
    } catch (e, st) {
      session.log('Matchmaking pairing retried later: $e', level: LogLevel.debug, stackTrace: st);
    }
  }

  /// Each player gets their favourite nation if they have one, otherwise a random one; never the same twice.
  Future<(String, String)> _nations(Session session, String host, String guest, Transaction tx) async {
    final hp = await UserProfile.db.findFirstRow(session, where: (p) => p.userId.equals(host), transaction: tx);
    final gp = await UserProfile.db.findFirstRow(session, where: (p) => p.userId.equals(guest), transaction: tx);
    final all = wcNations.keys.toList();
    String pick(String? fav, String? avoid) {
      if (fav != null && fav != avoid && wcNations.containsKey(fav)) return fav;
      final pool = all.where((n) => n != avoid).toList();
      return pool[_rng.nextInt(pool.length)];
    }

    final h = pick(hp?.favouriteNation, null);
    final g = pick(gp?.favouriteNation, h);
    return (h, g);
  }
}
