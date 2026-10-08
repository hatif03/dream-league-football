import 'package:serverpod/serverpod.dart';

import '../friend/penalty_duel.dart';
import '../generated/protocol.dart';

/// Scheduled by the server for every penalty kick: when the time to choose runs out it settles the kick
/// (picking at random for whoever did not choose) so a duel moves on even if both browsers have closed.
class DuelFutureCall extends FutureCall<KickDue> {
  Future<void> kickTimeout(Session session, KickDue? data) async {
    if (data == null) return;
    await advanceDuel(session, data.matchId);
  }
}
