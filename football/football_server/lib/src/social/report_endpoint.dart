import 'package:serverpod/serverpod.dart';

import '../auth/current_user.dart';
import '../generated/protocol.dart';
import '../util/rate_limit.dart';

class ReportEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Reports a player. When [matchId] is given the caller must have been in that match
  /// against the player, so reports carry real context.
  Future<void> create(Session session, String targetUserId, UuidValue? matchId, String reason) async {
    final profile = await requireProfile(session);
    rateLimit(profile.userId, 'report.create', max: 5, window: const Duration(hours: 1));
    final text = reason.trim();
    if (text.length < 3 || text.length > 500) {
      throw GameException(message: 'Say what happened in 3 to 500 characters.');
    }
    if (targetUserId == profile.userId) throw GameException(message: 'You cannot report yourself.');
    final target = await UserProfile.db.findFirstRow(session, where: (t) => t.userId.equals(targetUserId));
    if (target == null) throw GameException(message: 'That player no longer exists.');
    if (matchId != null) {
      final m = await FriendMatch.db.findById(session, matchId);
      final inMatch = m != null &&
          ((m.hostUserId == profile.userId && m.guestUserId == targetUserId) ||
              (m.guestUserId == profile.userId && m.hostUserId == targetUserId));
      if (!inMatch) throw GameException(message: 'You were not in that match with this player.');
    }
    await PlayerReport.db.insertRow(
      session,
      PlayerReport(reporterId: profile.userId, targetId: targetUserId, matchId: matchId, reason: text),
    );
  }
}
