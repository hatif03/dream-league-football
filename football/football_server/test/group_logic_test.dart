import 'dart:math';

import 'package:football_server/src/data/world_cup_data.dart';
import 'package:football_server/src/tournament/group_logic.dart';
import 'package:test/test.dart';

void main() {
  test('every group has 6 fixtures, 2 per matchday, each team once per matchday', () {
    final days = assignMatchdays(wcFixtures);
    expect(days.length, 72);
    for (final g in 'ABCDEFGHIJKL'.split('')) {
      for (var md = 1; md <= 3; md++) {
        final fx = wcFixtures.where((f) => f.group == g && days[f] == md).toList();
        expect(fx.length, 2, reason: 'group $g md $md');
        final teams = fx.expand((f) => [f.home, f.away]).toSet();
        expect(teams.length, 4, reason: 'group $g md $md has a team playing twice');
      }
    }
  });

  test('head-to-head beats goal difference between tied teams', () {
    // A and B level on 6 pts; B has the better overall GD but A won their meeting.
    final r = rankGroup(['a', 'b', 'c', 'd'], const [
      GroupResult('a', 'b', 1, 0),
      GroupResult('a', 'c', 0, 1),
      GroupResult('a', 'd', 1, 0),
      GroupResult('b', 'c', 3, 0),
      GroupResult('b', 'd', 4, 0),
      GroupResult('c', 'd', 0, 0),
    ]);
    expect(r.map((x) => x.nation).take(2), ['a', 'b']);
    expect(r.first.points, 6);
  });

  test('group stage qualifies 32 once all groups are finished', () {
    final rng = Random(1);
    final byGroup = <String, List<GroupResult>>{};
    for (final f in wcFixtures) {
      final (h, a) = simulateScore(wcNations[f.home]!, wcNations[f.away]!, rng);
      byGroup.putIfAbsent(f.group, () => []).add(GroupResult(f.home, f.away, h, a));
    }
    final stage = computeGroupStage(byGroup);
    expect(stage.qualified.length, 32);
  });

  test('stronger sides win more often', () {
    final rng = Random(7);
    final strong = wcNations['germany']!, weak = wcNations['haiti']!;
    var sw = 0, ww = 0;
    for (var i = 0; i < 2000; i++) {
      final (h, a) = simulateScore(strong, weak, rng);
      if (h > a) sw++;
      if (a > h) ww++;
    }
    expect(sw, greaterThan(ww * 2));
    expect(ww, greaterThan(0)); // upsets still happen
  });
}
