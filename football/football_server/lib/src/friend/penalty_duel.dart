import 'dart:math';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../live/live_hub.dart';
import '../rankings/rankings_endpoint.dart' show invalidateLeaderboard;
import '../ratings/rating_service.dart';
import 'duel_schedule.dart';
import 'penalty_rules.dart';

final _rng = Random.secure();

/// Opens the first kick of a new duel. Called in the transaction that creates the match.
Future<void> startDuel(Session session, Transaction tx, FriendMatch m) async {
  await _newKick(session, tx, m, 0);
}

Future<PenaltyKick> _newKick(Session session, Transaction tx, FriendMatch m, int seq) async {
  final deadline = DateTime.now().toUtc().add(kickWindow);
  final kick = await PenaltyKick.db.insertRow(
    session,
    PenaltyKick(
      matchId: m.id!,
      seq: seq,
      shooterUserId: (seq.isEven ? m.hostUserId : m.guestUserId)!,
      deadline: deadline,
    ),
    transaction: tx,
  );
  // A little after the deadline, the server settles the kick itself if nobody has.
  await scheduleKickTimeout(session, m.id!, seq, deadline.add(const Duration(seconds: 1)));
  return kick;
}

Future<List<PenaltyKick>> _kicks(Session session, UuidValue matchId, {Transaction? tx}) {
  return PenaltyKick.db.find(session, where: (k) => k.matchId.equals(matchId), orderBy: (k) => k.seq, transaction: tx);
}

/// Resolves the current kick if both players have chosen or its time is up; opens the next kick or
/// finishes the duel. [m] must be locked by the caller's transaction. Returns whether anything changed.
Future<bool> resolveIfReady(Session session, Transaction tx, FriendMatch m) async {
  if (m.mode != 'penalties' || m.status != 'live') return false;
  final kicks = await _kicks(session, m.id!, tx: tx);
  if (kicks.isEmpty) return false;
  final current = kicks.last;
  if (current.resolvedAt != null) return false;
  final now = DateTime.now().toUtc();
  final ready = current.shooterZone != null && current.keeperZone != null;
  if (!ready && now.isBefore(current.deadline)) return false;

  // Whoever has not chosen in time is picked for at random.
  current.shooterZone ??= _rng.nextInt(zoneCount);
  current.keeperZone ??= _rng.nextInt(zoneCount);
  current.outcome = resolveKick(shooterZone: current.shooterZone!, keeperZone: current.keeperZone!, rng: _rng);
  current.resolvedAt = now;
  await PenaltyKick.db.updateRow(session, current, transaction: tx);

  var hostGoals = 0, guestGoals = 0;
  final lite = <({bool host, bool scored})>[];
  for (final k in kicks) {
    final host = k.shooterUserId == m.hostUserId;
    final scored = k.outcome == 'goal';
    lite.add((host: host, scored: scored));
    if (scored) host ? hostGoals++ : guestGoals++;
  }

  var winner = shootoutWinner(lite);
  if (winner == null && kicks.length >= maxKicks) winner = _rng.nextBool() ? 'host' : 'guest';
  if (winner == null) {
    await _newKick(session, tx, m, current.seq + 1);
  } else {
    m
      ..status = 'finished'
      ..endReason = 'penalties'
      ..hostGoals = hostGoals
      ..guestGoals = guestGoals
      ..winnerUserId = winner == 'host' ? m.hostUserId : m.guestUserId
      ..endedAt = now;
    await applyRatings(session, m, tx);
    await FriendMatch.db.updateRow(session, m, transaction: tx);
    invalidateLeaderboard();
  }
  return true;
}

/// Settles the current kick if it is due (both chose, or time ran out). Safe to call at any time.
Future<void> advanceDuel(Session session, UuidValue matchId) async {
  final changed = await session.db.transaction((tx) async {
    final m = await FriendMatch.db.findById(session, matchId, transaction: tx, lockMode: LockMode.forUpdate);
    if (m == null) return null;
    final did = await resolveIfReady(session, tx, m);
    return did ? m : null;
  });
  if (changed != null) liveHub.notify([changed.hostUserId, changed.guestUserId], 'duel', matchId.toString());
}

/// A player's choice for kick [seq]: where to shoot if they are the shooter, where to dive if they keep goal.
Future<void> submitKick(Session session, UuidValue matchId, String userId, int seq, int zone) async {
  if (zone < 0 || zone >= zoneCount) throw GameException(message: 'Pick one of the six zones.');
  final m = await session.db.transaction((tx) async {
    final match = await FriendMatch.db.findById(session, matchId, transaction: tx, lockMode: LockMode.forUpdate);
    if (match == null || match.mode != 'penalties' || (match.hostUserId != userId && match.guestUserId != userId)) {
      throw GameException(message: 'Duel not found.');
    }
    if (match.status != 'live') throw GameException(message: 'The duel is over.');
    final kicks = await _kicks(session, matchId, tx: tx);
    final current = kicks.last;
    if (current.seq == seq && current.resolvedAt == null) {
      final shooter = current.shooterUserId == userId;
      // The first choice stands, so a retried request cannot change a kick.
      if (shooter) {
        current.shooterZone ??= zone;
      } else {
        current.keeperZone ??= zone;
      }
      await PenaltyKick.db.updateRow(session, current, transaction: tx);
    }
    await resolveIfReady(session, tx, match);
    return match;
  });
  liveHub.notify([m.hostUserId, m.guestUserId], 'duel', matchId.toString());
}

/// The duel as [userId] may see it: a kick that is not resolved shows nothing about what the other player chose.
Future<DuelView> duelView(Session session, FriendMatch m, String userId) async {
  final kicks = await _kicks(session, m.id!);
  final youAreHost = m.hostUserId == userId;
  var hostGoals = 0, guestGoals = 0;
  final views = <KickView>[];
  for (final k in kicks) {
    final host = k.shooterUserId == m.hostUserId;
    if (k.resolvedAt != null) {
      if (k.outcome == 'goal') host ? hostGoals++ : guestGoals++;
      views.add(KickView(seq: k.seq, shooterIsHost: host, shooterZone: k.shooterZone, keeperZone: k.keeperZone, outcome: k.outcome));
    } else {
      views.add(KickView(seq: k.seq, shooterIsHost: host));
    }
  }
  final live = m.status == 'live' && kicks.isNotEmpty && kicks.last.resolvedAt == null;
  final current = live ? kicks.last : null;
  final youShoot = current != null && current.shooterUserId == userId;
  final submitted = current != null && (youShoot ? current.shooterZone != null : current.keeperZone != null);
  final msLeft = current == null ? 0 : max(0, current.deadline.difference(DateTime.now().toUtc()).inMilliseconds);
  return DuelView(
    matchId: m.id!,
    status: m.status,
    youAreHost: youAreHost,
    hostName: await _name(session, m.hostUserId),
    guestName: await _name(session, m.guestUserId),
    hostGoals: m.status == 'finished' ? (m.hostGoals ?? hostGoals) : hostGoals,
    guestGoals: m.status == 'finished' ? (m.guestGoals ?? guestGoals) : guestGoals,
    kicks: views,
    seq: current?.seq ?? -1,
    youShoot: youShoot,
    youSubmitted: submitted,
    msLeft: msLeft,
    youWon: m.status == 'finished' ? m.winnerUserId == userId : null,
    ratingDelta: youAreHost ? m.hostRatingDelta : m.guestRatingDelta,
  );
}

Future<String> _name(Session session, String? userId) async {
  if (userId == null) return 'Removed player';
  final p = await UserProfile.db.findFirstRow(session, where: (t) => t.userId.equals(userId));
  return p?.displayName ?? 'Removed player';
}
