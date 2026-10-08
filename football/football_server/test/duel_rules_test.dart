import 'dart:math';

import 'package:football_server/src/friend/penalty_rules.dart';
import 'package:football_server/src/rankings/challenge_rules.dart';
import 'package:football_server/src/ratings/elo.dart';
import 'package:test/test.dart';

typedef K = ({bool host, bool scored});

/// Alternating kicks, host first, from a string of pairs like "10 11" (1 = scored).
List<K> kicks(String pairs) {
  final out = <K>[];
  for (final p in pairs.split(' ')) {
    out.add((host: true, scored: p[0] == '1'));
    if (p.length > 1) out.add((host: false, scored: p[1] == '1'));
  }
  return out;
}

void main() {
  group('shootout rules', () {
    test('open at the start and while it can still swing', () {
      expect(shootoutWinner(const []), isNull);
      expect(shootoutWinner(kicks('11 11 11')), isNull);
    });

    test('ends early once one side cannot be caught', () {
      // Host 3-0 up after three each: the guest can reach two at most.
      expect(shootoutWinner(kicks('10 10 10')), 'host');
      // 2-0 up after two each: the guest could still draw level.
      expect(shootoutWinner(kicks('10 10')), isNull);
      // Guest 3-0 up with the host to kick the fourth: the host can reach three at most.
      expect(shootoutWinner(kicks('01 01 01 0')), 'guest');
    });

    test('five each decides by goals', () {
      expect(shootoutWinner(kicks('11 11 11 11 10')), 'host');
      expect(shootoutWinner(kicks('11 00 11 10 11')), 'host');
      expect(shootoutWinner(kicks('01 11 01 11 01')), 'guest');
    });

    test('level after five goes to sudden death, decided after each pair', () {
      final level = kicks('11 11 11 11 11');
      expect(shootoutWinner(level), isNull);
      // The host scoring the sixth kick must not end it before the guest kicks.
      expect(shootoutWinner([...level, (host: true, scored: true)]), isNull);
      expect(shootoutWinner([...level, (host: true, scored: true), (host: false, scored: false)]), 'host');
      expect(shootoutWinner([...level, (host: true, scored: false), (host: false, scored: true)]), 'guest');
      expect(shootoutWinner([...level, (host: true, scored: true), (host: false, scored: true)]), isNull);
    });
  });

  group('kick resolution', () {
    test('only returns known outcomes and favours goals', () {
      final rng = Random(7);
      final counts = <String, int>{};
      for (var i = 0; i < 4000; i++) {
        final o = resolveKick(shooterZone: i % 6, keeperZone: (i * 5) % 6, rng: rng);
        counts[o] = (counts[o] ?? 0) + 1;
      }
      expect(counts.keys.toSet().difference({'goal', 'saved', 'miss', 'post'}), isEmpty);
      expect(counts['goal']!, greaterThan(counts['saved']!));
    });

    test('diving to the shooting zone saves far more often than diving to the opposite corner', () {
      final rng = Random(11);
      var same = 0, opposite = 0;
      for (var i = 0; i < 3000; i++) {
        if (resolveKick(shooterZone: 0, keeperZone: 0, rng: rng) == 'saved') same++;
        if (resolveKick(shooterZone: 0, keeperZone: 5, rng: rng) == 'saved') opposite++;
      }
      expect(same, greaterThan(opposite * 5));
      expect(opposite, 0);
    });
  });

  group('Elo', () {
    test('is zero-sum and rewards the upset', () {
      final even = eloDeltas(hostRating: 1000, guestRating: 1000, hostScore: 1);
      expect(even.host, 12);
      expect(even.host + even.guest, 0);
      final upset = eloDeltas(hostRating: 900, guestRating: 1200, hostScore: 1);
      final expected = eloDeltas(hostRating: 1200, guestRating: 900, hostScore: 1);
      expect(upset.host, greaterThan(expected.host));
    });

    test('a draw between equals changes nothing', () {
      final d = eloDeltas(hostRating: 1100, guestRating: 1100, hostScore: 0.5);
      expect(d.host, 0);
      expect(d.guest, 0);
    });
  });

  group('daily challenge', () {
    test('is the same for everyone on a day and rotates', () {
      final a = challengeFor(DateTime.utc(2026, 10, 8, 1));
      final b = challengeFor(DateTime.utc(2026, 10, 8, 23, 59));
      expect(a.title, b.title);
      final titles = {for (var i = 0; i < 7; i++) challengeFor(DateTime.utc(2026, 10, 8 + i)).title};
      expect(titles.length, greaterThan(3));
      expect(dayKey(DateTime.utc(2026, 1, 5)), '2026-01-05');
    });

    test('progress counts the right matches', () {
      const win = ChallengeDef('win_duel', 't', 'd', 1);
      const ms = <ChallengeMatch>[
        (mode: 'match', won: true, goals: 3),
        (mode: 'penalties', won: true, goals: 4),
        (mode: 'penalties', won: false, goals: 2),
      ];
      expect(challengeProgress(win, ms), 1);
      expect(challengeProgress(const ChallengeDef('play_duels', 't', 'd', 2), ms), 2);
      expect(challengeProgress(const ChallengeDef('score_goals', 't', 'd', 4), ms), 3, reason: 'only normal matches count goals');
    });

    test('streak counts consecutive completed days', () {
      final today = DateTime.utc(2026, 10, 8);
      final done = <String, List<ChallengeMatch>>{};
      for (var i = 0; i < 3; i++) {
        final day = today.subtract(Duration(days: i));
        final def = challengeFor(day);
        // Enough matches of every kind to satisfy any challenge.
        done[dayKey(day)] = [
          for (var n = 0; n < 6; n++) (mode: 'match', won: true, goals: 3),
          for (var n = 0; n < 6; n++) (mode: 'penalties', won: true, goals: 5),
        ];
        expect(challengeProgress(def, done[dayKey(day)]!), greaterThanOrEqualTo(def.target));
      }
      expect(challengeStreak(today, done), 3);
      expect(challengeStreak(today, {dayKey(today): done[dayKey(today)]!}), 1);
      expect(challengeStreak(today, const {}), 0);
    });
  });
}
