import 'package:serverpod/serverpod.dart';

import '../auth/current_user.dart';
import '../generated/protocol.dart';
import '../rankings/rankings_endpoint.dart' show invalidateLeaderboard;
import '../util/rate_limit.dart';
import 'claims.dart';

const _maxSdp = 64 * 1024;

class FriendMatchEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<MatchView> get(Session session, UuidValue matchId) async {
    final userId = requireUserId(session);
    var m = await _mine(session, matchId, userId);
    // Settling writes, so it goes through the locked path; plain reads stay lock-free.
    if (_wouldSettle(m)) m = await _update(session, matchId, userId, (_) {});
    return _view(session, m, userId);
  }

  /// Host posts the WebRTC offer (with every ICE candidate already in it).
  Future<void> postOffer(Session session, UuidValue matchId, String sdp) async {
    final userId = requireUserId(session);
    _checkSdp(sdp);
    await _update(session, matchId, userId, (m) {
      if (m.hostUserId != userId) throw GameException(message: 'Only the host posts the offer.');
      if (m.status != 'live') throw GameException(message: 'The match is over.');
      m
        ..offer = sdp
        ..answer = null;
    });
  }

  /// Guest posts the answer to the host's offer.
  Future<void> postAnswer(Session session, UuidValue matchId, String sdp) async {
    final userId = requireUserId(session);
    _checkSdp(sdp);
    await _update(session, matchId, userId, (m) {
      if (m.guestUserId != userId) throw GameException(message: 'Only the guest posts the answer.');
      if (m.status != 'live' || m.offer == null) throw GameException(message: 'No offer to answer.');
      m.answer = sdp;
    });
  }

  /// Polled by both peers until the handshake completes.
  Future<SignalView> getSignal(Session session, UuidValue matchId) async {
    final userId = requireUserId(session);
    final m = await _mine(session, matchId, userId);
    return SignalView(offer: m.offer, answer: m.answer, status: m.status);
  }

  /// Either peer reports how the match is connected; the handshake is then cleared.
  Future<void> connected(Session session, UuidValue matchId, String transport) async {
    final userId = requireUserId(session);
    if (transport != 'direct' && transport != 'relay') throw GameException(message: 'Bad transport.');
    await _update(session, matchId, userId, (m) {
      m
        ..transport = transport
        ..offer = null
        ..answer = null;
    });
  }

  /// The caller walks out of a match that is still being played. It ends at once as
  /// abandoned, naming them as the one who left, so the opponent is told immediately
  /// instead of waiting out the reconnect and signing windows. A player who already
  /// signed full time is not treated as leaving.
  Future<MatchView> leave(Session session, UuidValue matchId) async {
    final userId = requireUserId(session);
    final m = await _update(session, matchId, userId, (m) {
      if (m.status != 'live') return;
      final isHost = m.hostUserId == userId;
      final mine = Claim.parse(isHost ? m.hostClaim : m.guestClaim);
      if (mine != null && mine.reason == 'fulltime') return;
      m
        ..status = 'abandoned'
        ..endReason = 'left'
        ..leaverUserId = userId
        ..endedAt = DateTime.now().toUtc()
        ..offer = null
        ..answer = null;
    });
    return _view(session, m, userId);
  }

  /// Signs the result as the caller sees it. [reason] is `fulltime`, or
  /// `abandoned` when the opponent left. Posting the same claim twice is fine.
  Future<MatchView> claim(
    Session session,
    UuidValue matchId,
    int hostGoals,
    int guestGoals,
    String reason,
    String? stats,
  ) async {
    final userId = requireUserId(session);
    if (reason != 'fulltime' && reason != 'abandoned') throw GameException(message: 'Bad reason.');
    if (hostGoals < 0 || guestGoals < 0 || hostGoals > 30 || guestGoals > 30) {
      throw GameException(message: 'Impossible score.');
    }
    rateLimit(userId, 'match.claim', max: 20);
    // Both players sign within milliseconds of each other; the row lock makes
    // sure neither write drops the other's claim.
    final m = await _update(session, matchId, userId, (m) {
      final isHost = m.hostUserId == userId;
      final leaver = reason == 'abandoned' ? (isHost ? 'guest' : 'host') : '';
      final text = Claim(hostGoals, guestGoals, reason, leaver).text;
      final existing = isHost ? m.hostClaim : m.guestClaim;
      if (existing != null && existing != text) {
        throw GameException(message: 'You already signed a different result.');
      }
      if (isHost) {
        m.hostClaim = text;
        // The simulation runs on the host, so only the host reports its numbers.
        if (stats != null && stats.length <= 1024 && reason == 'fulltime') m.stats = stats;
      } else {
        m.guestClaim = text;
      }
      m.firstClaimAt ??= DateTime.now().toUtc();
    });
    return _view(session, m, userId);
  }

  /// The caller's recent friend matches, newest first.
  Future<List<MatchView>> history(Session session, int limit) async {
    final userId = requireUserId(session);
    final rows = await FriendMatch.db.find(
      session,
      where: (m) => m.hostUserId.equals(userId) | m.guestUserId.equals(userId),
      orderBy: (m) => m.startedAt.desc(),
      limit: limit.clamp(1, 50),
    );
    final out = <MatchView>[];
    for (var m in rows) {
      if (_wouldSettle(m)) m = await _update(session, m.id!, userId, (_) {});
      out.add(await _view(session, m, userId));
    }
    return out;
  }

  void _checkSdp(String sdp) {
    if (sdp.isEmpty || sdp.length > _maxSdp) throw GameException(message: 'Bad handshake.');
  }

  Future<FriendMatch> _mine(Session session, UuidValue id, String userId) async {
    final m = await FriendMatch.db.findById(session, id);
    return _checkMine(m, userId);
  }

  FriendMatch _checkMine(FriendMatch? m, String userId) {
    if (m == null || (m.hostUserId != userId && m.guestUserId != userId)) {
      throw GameException(message: 'Match not found.');
    }
    return m;
  }

  /// Read-modify-write under a row lock, so two players' updates never overwrite
  /// each other. Claims are re-evaluated after every change.
  Future<FriendMatch> _update(
    Session session,
    UuidValue id,
    String userId,
    void Function(FriendMatch m) change,
  ) {
    return session.db.transaction((tx) async {
      final m = _checkMine(
        await FriendMatch.db.findById(session, id, transaction: tx, lockMode: LockMode.forUpdate),
        userId,
      );
      change(m);
      _settle(m);
      if (m.status == 'finished') invalidateLeaderboard();
      return FriendMatch.db.updateRow(session, m, transaction: tx);
    });
  }

  MatchState _state(FriendMatch m) => MatchState(
    status: m.status,
    hostClaim: m.hostClaim,
    guestClaim: m.guestClaim,
    startedAt: m.startedAt,
    firstClaimAt: m.firstClaimAt,
  );

  bool _wouldSettle(FriendMatch m) {
    final s = _state(m);
    resolveClaims(s, DateTime.now().toUtc());
    return s.status != m.status;
  }

  /// Applies [resolveClaims] to the row in memory.
  void _settle(FriendMatch m) {
    final before = m.status;
    final s = _state(m);
    resolveClaims(s, DateTime.now().toUtc());
    if (s.status == before) return;
    m
      ..status = s.status
      ..hostGoals = s.hostGoals
      ..guestGoals = s.guestGoals
      ..endReason = s.endReason
      ..endedAt = s.endedAt
      ..winnerUserId = s.winner == 'host' ? m.hostUserId : s.winner == 'guest' ? m.guestUserId : null
      ..leaverUserId = s.leaver == 'host' ? m.hostUserId : s.leaver == 'guest' ? m.guestUserId : null
      ..offer = null
      ..answer = null;
  }

  Future<String> _name(Session session, String? userId) async {
    if (userId == null) return 'Removed player';
    final p = await UserProfile.db.findFirstRow(session, where: (t) => t.userId.equals(userId));
    return p?.displayName ?? 'Removed player';
  }

  Future<MatchView> _view(Session session, FriendMatch m, String userId) async {
    return MatchView(
      match: m,
      hostName: await _name(session, m.hostUserId),
      guestName: await _name(session, m.guestUserId),
      youAreHost: m.hostUserId == userId,
    );
  }
}
