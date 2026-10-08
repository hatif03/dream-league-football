import 'package:serverpod/serverpod.dart';

import '../auth/current_user.dart';
import '../generated/protocol.dart';
import '../util/rate_limit.dart';
import 'penalty_duel.dart';

/// The penalty duel: the server is the referee. Each kick, the shooter picks where to shoot and the
/// keeper where to dive, both in secret; when both have chosen the server draws the result with its own
/// randomness. Nothing runs in a browser that a player could tamper with, and neither side has a
/// latency advantage.
class PenaltyEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// The duel as the caller sees it. Also settles a kick whose time has run out.
  Future<DuelView> state(Session session, UuidValue matchId) async {
    final userId = requireUserId(session);
    var m = await _mine(session, matchId, userId);
    if (m.status == 'live') {
      await advanceDuel(session, matchId);
      m = await _mine(session, matchId, userId);
    }
    return duelView(session, m, userId);
  }

  /// The caller's choice for kick [seq]: a zone from 0 to 5 (shoot there, or dive there).
  /// Choosing again for the same kick changes nothing.
  Future<DuelView> submit(Session session, UuidValue matchId, int seq, int zone) async {
    final userId = requireUserId(session);
    rateLimit(userId, 'duel.submit', max: 60);
    await submitKick(session, matchId, userId, seq, zone);
    return duelView(session, await _mine(session, matchId, userId), userId);
  }

  Future<FriendMatch> _mine(Session session, UuidValue matchId, String userId) async {
    final m = await FriendMatch.db.findById(session, matchId);
    if (m == null || m.mode != 'penalties' || (m.hostUserId != userId && m.guestUserId != userId)) {
      throw GameException(message: 'Duel not found.');
    }
    return m;
  }
}
