import 'dart:math';

/// The goal is split into six zones, as the player sees it: 0 top left, 1 top centre, 2 top right,
/// 3 bottom left, 4 bottom centre, 5 bottom right.
const zoneCount = 6;

/// Kicks each side takes before sudden death.
const kicksPerSide = 5;

/// A duel never lasts longer than this many kicks in total.
const maxKicks = 40;

/// Time each player has to choose a zone for a kick.
const kickWindow = Duration(seconds: 25);

int _col(int z) => z % 3;
int _row(int z) => z ~/ 3;

/// How likely a shot at each zone is to go wide or over on its own: tucking it into the top corner
/// is the greedy choice, the middle of the goal the safe one.
const _missChance = [0.18, 0.06, 0.18, 0.07, 0.03, 0.07];
const _postChance = 0.04;

/// Decides one kick. [shooterZone] is where the shooter aims, [keeperZone] where the keeper dives.
/// Returns `goal`, `saved`, `miss` or `post`. All the randomness is the server's, so neither
/// player can influence or predict it.
String resolveKick({required int shooterZone, required int keeperZone, required Random rng}) {
  final r = rng.nextDouble();
  if (r < _missChance[shooterZone]) return 'miss';
  if (r < _missChance[shooterZone] + _postChance) return 'post';
  if (keeperZone == shooterZone) return 'saved';
  // Right side, wrong height: a fingertip save sometimes.
  if (_col(keeperZone) == _col(shooterZone)) return rng.nextDouble() < 0.35 ? 'saved' : 'goal';
  // Next column over at the same height: a long arm sometimes reaches it.
  if (_row(keeperZone) == _row(shooterZone) && (_col(keeperZone) - _col(shooterZone)).abs() == 1) {
    return rng.nextDouble() < 0.10 ? 'saved' : 'goal';
  }
  return 'goal';
}

/// Who has won a shootout given the kicks so far, or null if it is still open. Standard rules:
/// five kicks each (the host shoots first); it ends early once one side cannot be caught; after
/// that it is sudden death, decided after each pair of kicks.
String? shootoutWinner(List<({bool host, bool scored})> kicks) {
  var hostTaken = 0, guestTaken = 0, hostGoals = 0, guestGoals = 0;
  for (final k in kicks) {
    if (k.host) {
      hostTaken++;
      if (k.scored) hostGoals++;
    } else {
      guestTaken++;
      if (k.scored) guestGoals++;
    }
  }
  final hostLeft = max(0, kicksPerSide - hostTaken);
  final guestLeft = max(0, kicksPerSide - guestTaken);
  // The early finish only applies in the first five rounds; in sudden death only complete pairs count.
  final regulation = hostTaken <= kicksPerSide && guestTaken <= kicksPerSide;
  if (regulation && hostGoals > guestGoals + guestLeft) return 'host';
  if (regulation && guestGoals > hostGoals + hostLeft) return 'guest';
  if (hostTaken >= kicksPerSide && hostTaken == guestTaken && hostGoals != guestGoals) {
    return hostGoals > guestGoals ? 'host' : 'guest';
  }
  return null;
}
