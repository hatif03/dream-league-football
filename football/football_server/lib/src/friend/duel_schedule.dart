import 'package:serverpod/serverpod.dart';

import '../generated/future_calls.dart';
import '../generated/protocol.dart';

/// Asks the server to settle kick [seq] of a duel when its time is up, even if both players have gone
/// quiet. Implemented with Serverpod's future calls (see `future_calls/duel_future_call.dart`); the call is
/// stored in the database, so it survives restarts and runs on whichever server instance is up.
Future<void> scheduleKickTimeout(Session session, UuidValue matchId, int seq, DateTime at) async {
  await session.serverpod.futureCalls
      .callAtTime(at.add(const Duration(seconds: 2)), identifier: 'duel-$matchId-$seq')
      .duel
      .kickTimeout(KickDue(matchId: matchId, seq: seq));
}
