import 'dart:math';

import 'package:football_server/src/data/world_cup_data.dart';
import 'package:football_server/src/tournament/group_logic.dart';
import 'package:football_server/src/tournament/knockout.dart';
import 'package:test/test.dart';

void main() {
  test('every set of eight third-placed groups can fill the eight third slots', () {
    const all = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L'];
    var count = 0;
    void choose(int start, List<String> picked) {
      if (picked.length == 8) {
        final m = assignThirds(picked.toSet());
        expect(m.length, 8);
        expect(m.values.toSet().length, 8, reason: 'each group used once: $picked');
        for (final e in m.entries) {
          final allowed = r32Slots[e.key]!.$2.substring(2);
          expect(allowed.contains(e.value), isTrue, reason: 'slot ${e.key} allows $allowed, got ${e.value}');
        }
        count++;
        return;
      }
      for (var i = start; i < all.length; i++) {
        choose(i + 1, [...picked, all[i]]);
      }
    }

    choose(0, []);
    expect(count, 495);
  });

  test('bracket is a proper 32-team tree ending in one final', () {
    expect(r32Slots.length, 16);
    expect(feeders.length, 15);
    // Every R32 match feeds exactly one later match, and every later match has two distinct feeders.
    final used = <int>[];
    for (final f in feeders.values) {
      used..add(f.$1)..add(f.$2);
    }
    expect(used.toSet().length, used.length);
    expect(used.toSet().containsAll([...r32Slots.keys]), isTrue);
    expect(matchesOfRound('r16').length, 8);
    expect(matchesOfRound('qf').length, 4);
    expect(matchesOfRound('sf').length, 2);
    expect(matchesOfRound('final'), [104]);
  });

  test('a full simulated group stage produces 16 distinct R32 ties', () {
    final rng = Random(3);
    final byGroup = <String, List<GroupResult>>{};
    for (final f in wcFixtures) {
      final (h, a) = simulateScore(wcNations[f.home]!, wcNations[f.away]!, rng);
      byGroup.putIfAbsent(f.group, () => []).add(GroupResult(f.home, f.away, h, a));
    }
    final pairs = buildR32(computeGroupStage(byGroup));
    expect(pairs.length, 16);
    final teams = pairs.expand((p) => [p.$2, p.$3]).toList();
    expect(teams.toSet().length, 32);
    for (final p in pairs) {
      expect(wcNations[p.$2]!.group == wcNations[p.$3]!.group, isFalse, reason: 'same-group clash in match ${p.$1}');
    }
  });

  test('knockout results always have a winner', () {
    final rng = Random(9);
    for (var i = 0; i < 500; i++) {
      final r = simulateKnockout(wcNations['brazil']!, wcNations['haiti']!, rng);
      expect(r.valid, isTrue);
      expect(['home', 'away'].contains(r.winner), isTrue);
    }
    expect(const KoResult(1, 1).valid, isFalse);
    expect(const KoResult(1, 1, 4, 4).valid, isFalse);
    expect(const KoResult(2, 1, 5, 4).valid, isFalse);
    expect(const KoResult(1, 1, 5, 4).winner, 'home');
  });
}
