import 'dart:math';

import '../data/world_cup_data.dart';
import 'group_logic.dart';

// The official 2026 knockout bracket (FIFA match numbers 73-104). A code like "1E" is the
// winner of group E, "2A" the runner-up of group A, and "3:ABCDF" the third-placed team of
// one of those groups. Sources: FIFA's knockout schedule and Wikipedia's
// "2026 FIFA World Cup knockout stage".
const r32Slots = <int, (String, String)>{
  73: ('2A', '2B'),
  74: ('1E', '3:ABCDF'),
  75: ('1F', '2C'),
  76: ('1C', '2F'),
  77: ('1I', '3:CDFGH'),
  78: ('2E', '2I'),
  79: ('1A', '3:CEFHI'),
  80: ('1L', '3:EHIJK'),
  81: ('1D', '3:BEFIJ'),
  82: ('1G', '3:AEHIJ'),
  83: ('2K', '2L'),
  84: ('1H', '2J'),
  85: ('1B', '3:EFGIJ'),
  86: ('1J', '2H'),
  87: ('1K', '3:DEIJL'),
  88: ('2D', '2G'),
};

/// Later rounds: the two earlier matches whose winners meet. (There is no third-place game.)
const feeders = <int, (int, int)>{
  89: (74, 77),
  90: (73, 75),
  91: (76, 78),
  92: (79, 80),
  93: (83, 84),
  94: (81, 82),
  95: (86, 88),
  96: (85, 87),
  97: (89, 90),
  98: (93, 94),
  99: (91, 92),
  100: (95, 96),
  101: (97, 98),
  102: (99, 100),
  104: (101, 102),
};

String roundOf(int matchNo) {
  if (matchNo <= 88) return 'r32';
  if (matchNo <= 96) return 'r16';
  if (matchNo <= 100) return 'qf';
  if (matchNo <= 102) return 'sf';
  return 'final';
}

const roundOrder = ['group', 'r32', 'r16', 'qf', 'sf', 'final'];

/// Match numbers of a round, in order.
List<int> matchesOfRound(String round) => [
  ...r32Slots.keys,
  ...feeders.keys,
].where((n) => roundOf(n) == round).toList()..sort();

/// Puts the eight qualifying third-placed teams into the eight slots that take one.
///
/// FIFA publishes a 495-row table for this. We assign by matching each slot to one of the
/// groups it allows, which always has a solution for any eight groups (see the test) and
/// respects every slot's published constraint. // ponytail: not row-for-row identical to
/// FIFA's table when several valid assignments exist.
Map<int, String> assignThirds(Set<String> groups) {
  final slots = r32Slots.entries
      .where((e) => e.value.$2.startsWith('3:'))
      .map((e) => (e.key, e.value.$2.substring(2)))
      .toList();
  final order = groups.toList()..sort();
  final out = <int, String>{};
  final used = <String>{};
  bool go(int i) {
    if (i == slots.length) return true;
    for (final g in order) {
      if (used.contains(g) || !slots[i].$2.contains(g)) continue;
      used.add(g);
      out[slots[i].$1] = g;
      if (go(i + 1)) return true;
      used.remove(g);
      out.remove(slots[i].$1);
    }
    return false;
  }

  if (!go(0)) throw StateError('no third-place assignment for $groups');
  return out;
}

/// The sixteen Round-of-32 pairings as (matchNo, homeNation, awayNation).
List<(int, String, String)> buildR32(GroupStageResult stage) {
  final thirdGroups = <String>{};
  for (final e in stage.tables.entries) {
    if (stage.qualified.contains(e.value[2].nation)) thirdGroups.add(e.key);
  }
  final thirds = assignThirds(thirdGroups);
  String resolve(int no, String code) {
    if (code.startsWith('3:')) return stage.tables[thirds[no]!]![2].nation;
    final pos = int.parse(code[0]) - 1;
    return stage.tables[code.substring(1)]![pos].nation;
  }

  return [for (final e in r32Slots.entries) (e.key, resolve(e.key, e.value.$1), resolve(e.key, e.value.$2))];
}

/// A knockout game decided on the pitch: scores after extra time, and shootout goals if level.
class KoResult {
  final int home;
  final int away;
  final int? homePens;
  final int? awayPens;
  const KoResult(this.home, this.away, [this.homePens, this.awayPens]);

  /// 'home' or 'away'. A level game must carry a shootout with a winner.
  String get winner {
    if (home != away) return home > away ? 'home' : 'away';
    return homePens! > awayPens! ? 'home' : 'away';
  }

  bool get valid {
    if (home != away) return homePens == null && awayPens == null;
    return homePens != null && awayPens != null && homePens != awayPens && homePens! >= 0 && awayPens! >= 0;
  }
}

/// A simulated knockout tie: a normal score, and a shootout (tilted to the stronger side) if level.
KoResult simulateKnockout(WcNation home, WcNation away, Random rng) {
  final (h, a) = simulateScore(home, away, rng);
  if (h != a) return KoResult(h, a);
  final pHome = (0.5 + 0.015 * (home.strength - away.strength)).clamp(0.3, 0.7);
  final homeWins = rng.nextDouble() < pHome;
  final w = 3 + rng.nextInt(3); // winner scores 3-5
  final l = w - 1 - rng.nextInt(2); // loser one or two fewer
  return KoResult(h, a, homeWins ? w : l, homeWins ? l : w);
}
