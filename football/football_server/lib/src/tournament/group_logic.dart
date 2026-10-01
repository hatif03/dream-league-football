import 'dart:math';

import '../data/world_cup_data.dart';

/// A finished group game, home/away as in the fixture.
class GroupResult {
  final String home;
  final String away;
  final int homeScore;
  final int awayScore;
  const GroupResult(this.home, this.away, this.homeScore, this.awayScore);
}

class TableRow {
  final String nation;
  int played = 0, won = 0, drawn = 0, lost = 0, gf = 0, ga = 0, points = 0;
  TableRow(this.nation);
  int get gd => gf - ga;
}

/// A fixture's matchday: a team's n-th group game in kickoff order.
/// Each group plays two games per matchday, so it is the index in the
/// group's kickoff-sorted list divided by two.
Map<WcFixture, int> assignMatchdays(List<WcFixture> fixtures) {
  final out = <WcFixture, int>{};
  final byGroup = <String, List<WcFixture>>{};
  for (final f in fixtures) {
    byGroup.putIfAbsent(f.group, () => []).add(f);
  }
  for (final list in byGroup.values) {
    list.sort((a, b) => a.kickoffUtc.compareTo(b.kickoffUtc));
    for (var i = 0; i < list.length; i++) {
      out[list[i]] = i ~/ 2 + 1;
    }
  }
  return out;
}

Map<String, TableRow> _table(Iterable<String> nations, Iterable<GroupResult> results) {
  final rows = {for (final n in nations) n: TableRow(n)};
  for (final r in results) {
    final h = rows[r.home], a = rows[r.away];
    if (h == null || a == null) continue;
    h
      ..played += 1
      ..gf += r.homeScore
      ..ga += r.awayScore;
    a
      ..played += 1
      ..gf += r.awayScore
      ..ga += r.homeScore;
    if (r.homeScore > r.awayScore) {
      h.won += 1;
      a.lost += 1;
      h.points += 3;
    } else if (r.homeScore < r.awayScore) {
      a.won += 1;
      h.lost += 1;
      a.points += 3;
    } else {
      h.drawn += 1;
      a.drawn += 1;
      h.points += 1;
      a.points += 1;
    }
  }
  return rows;
}

/// Deterministic stand-in for the drawing of lots, so a reload shows the same table.
int _lot(String nation) => nation.codeUnits.fold(7, (h, c) => (h * 31 + c) & 0x7fffffff);

/// Ranks one group: points, then (among teams level on points) head-to-head
/// points, goal difference and goals scored, then overall goal difference,
/// goals scored, then a deterministic draw.
// ponytail: head-to-head is applied once, not recursively on sub-ties.
List<TableRow> rankGroup(List<String> nations, List<GroupResult> results) {
  final overall = _table(nations, results);
  final rows = overall.values.toList()..sort((a, b) => b.points.compareTo(a.points));

  final ranked = <TableRow>[];
  var i = 0;
  while (i < rows.length) {
    var j = i + 1;
    while (j < rows.length && rows[j].points == rows[i].points) {
      j++;
    }
    final tied = rows.sublist(i, j);
    if (tied.length > 1) {
      final ids = tied.map((r) => r.nation).toSet();
      final h2h = _table(ids, results.where((r) => ids.contains(r.home) && ids.contains(r.away)));
      tied.sort((a, b) {
        final x = h2h[a.nation]!, y = h2h[b.nation]!;
        final c = y.points.compareTo(x.points);
        if (c != 0) return c;
        final g = y.gd.compareTo(x.gd);
        if (g != 0) return g;
        final s = y.gf.compareTo(x.gf);
        if (s != 0) return s;
        final og = b.gd.compareTo(a.gd);
        if (og != 0) return og;
        final os = b.gf.compareTo(a.gf);
        if (os != 0) return os;
        return _lot(a.nation).compareTo(_lot(b.nation));
      });
    }
    ranked.addAll(tied);
    i = j;
  }
  return ranked;
}

/// Ranked tables for every group, plus the set of nations through to the
/// round of 32 (top two of each group and the eight best third-placed teams).
/// Third-placed teams only qualify once all twelve groups have finished.
class GroupStageResult {
  final Map<String, List<TableRow>> tables;
  final Set<String> qualified;
  const GroupStageResult(this.tables, this.qualified);
}

GroupStageResult computeGroupStage(Map<String, List<GroupResult>> resultsByGroup) {
  final groups = <String, List<String>>{};
  for (final n in wcNations.values) {
    groups.putIfAbsent(n.group, () => []).add(n.id);
  }
  final tables = <String, List<TableRow>>{};
  final qualified = <String>{};
  final thirds = <TableRow>[];
  var allDone = true;
  for (final e in groups.entries) {
    final results = resultsByGroup[e.key] ?? const [];
    final ranked = rankGroup(e.value, results);
    tables[e.key] = ranked;
    if (results.length < 6) allDone = false;
    qualified.addAll(ranked.take(2).map((r) => r.nation));
    thirds.add(ranked[2]);
  }
  if (allDone) {
    thirds.sort((a, b) {
      final p = b.points.compareTo(a.points);
      if (p != 0) return p;
      final g = b.gd.compareTo(a.gd);
      if (g != 0) return g;
      final s = b.gf.compareTo(a.gf);
      if (s != 0) return s;
      return _lot(a.nation).compareTo(_lot(b.nation));
    });
    qualified.addAll(thirds.take(8).map((r) => r.nation));
  }
  return GroupStageResult(tables, qualified);
}

int _poisson(Random rng, double lambda) {
  final l = exp(-lambda);
  var k = 0;
  var p = 1.0;
  do {
    k++;
    p *= rng.nextDouble();
  } while (p > l);
  return k - 1;
}

/// A plausible score for a simulated game. The side with the higher average
/// starting-eleven overall scores more on average; upsets happen naturally.
(int, int) simulateScore(WcNation home, WcNation away, Random rng) {
  const base = 1.3, k = 0.05;
  final d = home.strength - away.strength;
  final lh = (base * exp(k * d)).clamp(0.3, 4.0).toDouble();
  final la = (base * exp(-k * d)).clamp(0.3, 4.0).toDouble();
  return (min(_poisson(rng, lh), 9), min(_poisson(rng, la), 9));
}
