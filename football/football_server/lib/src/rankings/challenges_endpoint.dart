import 'package:serverpod/serverpod.dart';

import '../auth/current_user.dart';
import '../generated/protocol.dart';
import 'challenge_rules.dart';

/// The daily challenge: one goal a day, the same for everybody, derived from the date. Progress and the
/// streak are computed from the finished online matches already stored, so nothing extra is written.
class ChallengesEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<ChallengeView> today(Session session) async {
    final me = requireUserId(session);
    final now = DateTime.now().toUtc();
    final since = DateTime.utc(now.year, now.month, now.day).subtract(const Duration(days: 61));

    final rows = await FriendMatch.db.find(
      session,
      where: (m) =>
          (m.hostUserId.equals(me) | m.guestUserId.equals(me)) & m.status.equals('finished') & (m.endedAt > since),
      limit: 3000,
    );
    final byDay = <String, List<ChallengeMatch>>{};
    for (final m in rows) {
      final host = m.hostUserId == me;
      final goals = (host ? m.hostGoals : m.guestGoals) ?? 0;
      byDay.putIfAbsent(dayKey(m.endedAt ?? now), () => []).add((mode: m.mode, won: m.winnerUserId == me, goals: goals));
    }

    final def = challengeFor(now);
    final progress = challengeProgress(def, byDay[dayKey(now)] ?? const []);
    return ChallengeView(
      day: dayKey(now),
      kind: def.kind,
      title: def.title,
      description: def.description,
      target: def.target,
      progress: progress.clamp(0, def.target),
      done: progress >= def.target,
      streak: challengeStreak(now, byDay),
    );
  }
}
