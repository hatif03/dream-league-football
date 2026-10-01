import 'package:serverpod/serverpod.dart';

import '../auth/current_user.dart';
import '../generated/protocol.dart';
import '../social/social_util.dart';

/// Public: lets the sign-in screen and the lobby know about maintenance.
class LiveOpsEndpoint extends Endpoint {
  Future<LiveStatus> get(Session session) => liveStatus(session);
}

/// Operator tools. Callable only by the user ids listed (comma separated) in the
/// `adminUserIds` password: `scloud password set adminUserIds <id>[,<id>]`.
class AdminEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  String _admin(Session session) {
    final me = requireUserId(session);
    final ids = (session.passwords['adminUserIds'] ?? '').split(',').map((s) => s.trim());
    if (!ids.contains(me)) throw GameException(message: 'Not allowed.');
    return me;
  }

  Future<void> _audit(Session session, String actor, String action, String? target, String? detail) {
    return AuditLog.db.insertRow(
      session,
      AuditLog(actorId: actor, action: action, target: target, detail: detail),
    );
  }

  /// Turns maintenance on or off. New rooms are refused while it is on; sign-in and
  /// matches already running carry on.
  Future<LiveStatus> setMaintenance(Session session, bool on, String? message) async {
    final me = _admin(session);
    final row = await LiveOps.db.findFirstRow(session);
    if (row == null) {
      await LiveOps.db.insertRow(
        session,
        LiveOps(maintenance: on, message: message, updatedAt: DateTime.now().toUtc()),
      );
    } else {
      row
        ..maintenance = on
        ..message = message
        ..updatedAt = DateTime.now().toUtc();
      await LiveOps.db.updateRow(session, row);
    }
    await _audit(session, me, 'maintenance', on ? 'on' : 'off', message);
    return liveStatus(session);
  }

  /// Suspends a player by display name for [hours], or lifts the suspension with 0.
  Future<void> suspend(Session session, String name, int hours) async {
    final me = _admin(session);
    final p = await UserProfile.db.findFirstRow(
      session,
      where: (t) => t.displayNameLower.equals(name.trim().toLowerCase()),
    );
    if (p == null) throw GameException(message: 'No such player.');
    p.bannedUntil = hours <= 0 ? null : DateTime.now().toUtc().add(Duration(hours: hours));
    await UserProfile.db.updateRow(session, p);
    await _audit(session, me, hours <= 0 ? 'unsuspend' : 'suspend', p.userId, '$hours h');
  }

  /// Marks a friend match void so it counts for nobody.
  Future<void> voidMatch(Session session, UuidValue matchId, String reason) async {
    final me = _admin(session);
    await session.db.transaction((tx) async {
      final m = await FriendMatch.db.findById(session, matchId, transaction: tx, lockMode: LockMode.forUpdate);
      if (m == null) throw GameException(message: 'No such match.');
      m
        ..status = 'void'
        ..endReason = 'admin'
        ..winnerUserId = null
        ..hostGoals = null
        ..guestGoals = null
        ..endedAt = DateTime.now().toUtc()
        ..offer = null
        ..answer = null;
      await FriendMatch.db.updateRow(session, m, transaction: tx);
    });
    await _audit(session, me, 'void-match', matchId.toString(), reason);
  }

  Future<AdminStats> stats(Session session) async {
    _admin(session);
    return AdminStats(
      openLobbies: await Lobby.db.count(session, where: (l) => l.status.equals('open')),
      liveMatches: await FriendMatch.db.count(session, where: (m) => m.status.equals('live')),
      profiles: await UserProfile.db.count(session),
      openReports: await PlayerReport.db.count(session, where: (r) => r.resolvedAt.equals(null)),
    );
  }
}
