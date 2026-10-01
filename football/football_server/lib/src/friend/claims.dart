/// How two players' signed claims turn into a stored result.
///
/// A claim is the canonical text "hostGoals:guestGoals:reason:leaver" where
/// reason is `fulltime` or `abandoned`, and leaver is `host`, `guest` or empty.
/// The match is stored only when both claims are identical.
class Claim {
  final int hostGoals;
  final int guestGoals;
  final String reason;
  final String leaver;
  const Claim(this.hostGoals, this.guestGoals, this.reason, this.leaver);

  String get text => '$hostGoals:$guestGoals:$reason:$leaver';

  static Claim? parse(String? s) {
    if (s == null) return null;
    final p = s.split(':');
    if (p.length != 4) return null;
    final h = int.tryParse(p[0]), g = int.tryParse(p[1]);
    if (h == null || g == null) return null;
    return Claim(h, g, p[2], p[3]);
  }
}

/// Mutable view of the fields resolution reads and writes.
class MatchState {
  String status;
  String? hostClaim;
  String? guestClaim;
  DateTime startedAt;
  DateTime? firstClaimAt;
  int? hostGoals;
  int? guestGoals;
  String? endReason;
  String? leaver; // 'host' | 'guest'
  /// 'host', 'guest' or null (draw / no winner).
  String? winner;
  DateTime? endedAt;

  MatchState({
    required this.status,
    this.hostClaim,
    this.guestClaim,
    required this.startedAt,
    this.firstClaimAt,
  });
}

const claimGrace = Duration(seconds: 45);
const maxMatchAge = Duration(hours: 4);

void _end(MatchState m, String status, String reason, DateTime now) {
  m.status = status;
  m.endReason = reason;
  m.endedAt = now;
}

/// Settles [m] if its claims allow. Safe to call repeatedly.
void resolveClaims(MatchState m, DateTime now) {
  if (m.status != 'live') return;
  final h = Claim.parse(m.hostClaim), g = Claim.parse(m.guestClaim);

  if (h != null && g != null) {
    if (h.text != g.text) return _end(m, 'void', 'mismatch', now);
    if (h.reason == 'abandoned') {
      m.leaver = h.leaver.isEmpty ? null : h.leaver;
      return _end(m, 'abandoned', 'abandoned', now);
    }
    m.hostGoals = h.hostGoals;
    m.guestGoals = h.guestGoals;
    m.winner = h.hostGoals == h.guestGoals ? null : (h.hostGoals > h.guestGoals ? 'host' : 'guest');
    return _end(m, 'finished', 'fulltime', now);
  }

  final only = h ?? g;
  final since = m.firstClaimAt;
  if (only != null && since != null && now.difference(since) > claimGrace) {
    if (only.reason == 'abandoned') {
      // The peer who stayed says the other left and the other never answered.
      m.leaver = only.leaver.isEmpty ? null : only.leaver;
      return _end(m, 'abandoned', 'abandoned', now);
    }
    // A single full-time signature is not enough: nobody is given the win.
    return _end(m, 'void', 'timeout', now);
  }
  if (only == null && now.difference(m.startedAt) > maxMatchAge) {
    return _end(m, 'void', 'timeout', now);
  }
}
