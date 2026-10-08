import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../live/live_hub.dart';

/// What the nightly job tidies up. Each count is logged so it shows in the server log.
class MaintenanceReport {
  int lobbiesClosed = 0, matchesVoided = 0, queueRemoved = 0, invitesRemoved = 0, messagesRemoved = 0, sharesRemoved = 0;
  @override
  String toString() =>
      'closed $lobbiesClosed idle rooms, voided $matchesVoided stuck matches, dropped $queueRemoved queue entries, '
      '$invitesRemoved old invites, $messagesRemoved old chat lines, $sharesRemoved old shared results';
}

/// Cleans up what players leave behind: rooms nobody joined, matches whose players vanished, queue entries,
/// old invites, chat and shared-result links. Run every night by a Serverpod future call, and safe to run any time.
Future<MaintenanceReport> runMaintenance(Session session) async {
  final r = MaintenanceReport();
  final now = DateTime.now().toUtc();

  // Rooms nobody joined or finished with.
  final idleRooms = await Lobby.db.find(
    session,
    where: (l) => l.status.equals('open') & (l.updatedAt < now.subtract(const Duration(hours: 3))),
  );
  for (final l in idleRooms) {
    l.status = 'closed';
    await Lobby.db.updateRow(session, l);
    r.lobbiesClosed++;
  }

  // Matches still "live" long after both players are gone (and duels with a kick overdue for a long time).
  final stuck = await FriendMatch.db.find(
    session,
    where: (m) => m.status.equals('live') & (m.startedAt < now.subtract(const Duration(hours: 6))),
  );
  for (final m in stuck) {
    m
      ..status = 'void'
      ..endReason = 'timeout'
      ..endedAt = now;
    await FriendMatch.db.updateRow(session, m);
    liveHub.notify([m.hostUserId, m.guestUserId], 'match', m.id.toString());
    r.matchesVoided++;
  }
  final overdue = await FriendMatch.db.find(
    session,
    where: (m) => m.status.equals('live') & m.mode.equals('penalties') & (m.startedAt < now.subtract(const Duration(minutes: 30))),
  );
  for (final m in overdue) {
    final lastKick = await PenaltyKick.db.findFirstRow(
      session,
      where: (k) => k.matchId.equals(m.id!),
      orderBy: (k) => k.seq.desc(),
    );
    if (lastKick != null && lastKick.resolvedAt == null && lastKick.deadline.isBefore(now.subtract(const Duration(minutes: 15)))) {
      m
        ..status = 'void'
        ..endReason = 'timeout'
        ..endedAt = now;
      await FriendMatch.db.updateRow(session, m);
      r.matchesVoided++;
    }
  }

  r.queueRemoved = (await QueueEntry.db.deleteWhere(session, where: (q) => q.lastPollAt < now.subtract(const Duration(minutes: 10)))).length;
  r.invitesRemoved = (await LobbyInvite.db.deleteWhere(session, where: (i) => i.createdAt < now.subtract(const Duration(days: 1)))).length;
  r.messagesRemoved = (await LobbyMessage.db.deleteWhere(session, where: (m) => m.createdAt < now.subtract(const Duration(days: 2)))).length;
  r.sharesRemoved = 0; // shared results are kept; only the stored pictures could be expired later

  session.log('Nightly maintenance: $r', level: LogLevel.info);
  return r;
}
