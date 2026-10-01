import 'package:football_server/src/friend/claims.dart';
import 'package:test/test.dart';

MatchState live({String? h, String? g, DateTime? first}) => MatchState(
  status: 'live',
  hostClaim: h,
  guestClaim: g,
  startedAt: DateTime.utc(2026, 7, 1, 12),
  firstClaimAt: first,
);

final t0 = DateTime.utc(2026, 7, 1, 12, 5);

void main() {
  test('matching full-time claims store the score and the winner', () {
    final m = live(h: '2:1:fulltime:', g: '2:1:fulltime:');
    resolveClaims(m, t0);
    expect(m.status, 'finished');
    expect((m.hostGoals, m.guestGoals, m.winner), (2, 1, 'host'));
  });

  test('a draw has no winner', () {
    final m = live(h: '1:1:fulltime:', g: '1:1:fulltime:');
    resolveClaims(m, t0);
    expect((m.status, m.winner), ('finished', null));
  });

  test('different claims void the match and give nobody the win', () {
    final m = live(h: '10:0:fulltime:', g: '0:10:fulltime:');
    resolveClaims(m, t0);
    expect((m.status, m.endReason, m.winner), ('void', 'mismatch', null));
  });

  test('a single full-time claim waits, then voids', () {
    final m = live(h: '3:0:fulltime:', first: t0);
    resolveClaims(m, t0.add(const Duration(seconds: 10)));
    expect(m.status, 'live');
    resolveClaims(m, t0.add(const Duration(seconds: 50)));
    expect((m.status, m.endReason, m.winner), ('void', 'timeout', null));
  });

  test('a lone abandon claim becomes an abandoned match naming the leaver', () {
    final m = live(g: '0:0:abandoned:host', first: t0);
    resolveClaims(m, t0.add(const Duration(seconds: 60)));
    expect((m.status, m.leaver, m.winner), ('abandoned', 'host', null));
  });

  test('two abandon claims disagree (each names the other) and void', () {
    final m = live(h: '0:0:abandoned:guest', g: '0:0:abandoned:host');
    resolveClaims(m, t0);
    expect(m.status, 'void');
  });

  test('resolution is idempotent once settled', () {
    final m = live(h: '2:1:fulltime:', g: '2:1:fulltime:');
    resolveClaims(m, t0);
    m.hostGoals = 99;
    resolveClaims(m, t0.add(const Duration(days: 1)));
    expect(m.hostGoals, 99);
    expect(m.status, 'finished');
  });
}
