import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'elo.dart';

/// Awards rating points for a match that has just finished, inside the caller's transaction (the
/// match row is already locked there). Fills in `hostRatingDelta` and `guestRatingDelta` on [m].
///
/// A draw counts half; a duel is worth a little less than a full match; and after five finished
/// matches between the same two players in a day nothing more is awarded.
Future<void> applyRatings(Session session, FriendMatch m, Transaction tx) async {
  final hostId = m.hostUserId, guestId = m.guestUserId;
  if (hostId == null || guestId == null) return;
  final host = await UserProfile.db.findFirstRow(
    session,
    where: (p) => p.userId.equals(hostId),
    transaction: tx,
    lockMode: LockMode.forUpdate,
  );
  final guest = await UserProfile.db.findFirstRow(
    session,
    where: (p) => p.userId.equals(guestId),
    transaction: tx,
    lockMode: LockMode.forUpdate,
  );
  if (host == null || guest == null) return;

  final since = DateTime.now().toUtc().subtract(const Duration(hours: 24));
  final recent = await FriendMatch.db.count(
    session,
    where: (x) =>
        x.status.equals('finished') &
        (x.endedAt > since) &
        x.id.notEquals(m.id!) &
        ((x.hostUserId.equals(hostId) & x.guestUserId.equals(guestId)) |
            (x.hostUserId.equals(guestId) & x.guestUserId.equals(hostId))),
    transaction: tx,
  );
  if (recent >= maxRatedPerPairPerDay) {
    m
      ..hostRatingDelta = 0
      ..guestRatingDelta = 0;
    return;
  }

  final hostScore = m.winnerUserId == null ? 0.5 : (m.winnerUserId == hostId ? 1.0 : 0.0);
  final d = eloDeltas(
    hostRating: host.rating,
    guestRating: guest.rating,
    hostScore: hostScore,
    k: m.mode == 'penalties' ? 16 : 24,
  );
  final hostNew = (host.rating + d.host).clamp(minRating, 4000);
  final guestNew = (guest.rating + d.guest).clamp(minRating, 4000);
  await UserProfile.db.updateRow(session, host.copyWith(rating: hostNew), transaction: tx);
  await UserProfile.db.updateRow(session, guest.copyWith(rating: guestNew), transaction: tx);
  m
    ..hostRatingDelta = hostNew - host.rating
    ..guestRatingDelta = guestNew - guest.rating;
}
