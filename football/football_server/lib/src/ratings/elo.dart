import 'dart:math';

/// Rating points won or lost, in the usual Elo way: beating a stronger player is worth more.
/// [hostScore] is 1 for a host win, 0.5 for a draw and 0 for a guest win. The change is zero-sum.
({int host, int guest}) eloDeltas({
  required int hostRating,
  required int guestRating,
  required double hostScore,
  int k = 24,
}) {
  final expectedHost = 1 / (1 + pow(10, (guestRating - hostRating) / 400));
  final host = (k * (hostScore - expectedHost)).round();
  return (host: host, guest: -host);
}

/// A player's rating never drops below this.
const minRating = 100;

/// After this many finished matches between the same two players in a day, further ones are worth
/// nothing, so two friends cannot trade wins to climb the ladder.
const maxRatedPerPairPerDay = 5;
