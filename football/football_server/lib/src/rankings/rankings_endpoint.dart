import 'package:serverpod/serverpod.dart';

import '../auth/current_user.dart';
import '../generated/protocol.dart';

/// Leaderboard points: a friend-match win is worth 3, a draw 1, a solo World Cup title 25.
const _winPoints = 3, _drawPoints = 1, _titlePoints = 25;

/// How long a computed leaderboard is reused. ponytail: one in-memory copy per server instance, computed
/// from every finished match; move to a stored table or a materialised view if the match count gets large.
const _cacheFor = Duration(seconds: 30);
List<LeaderEntry>? _cache;
DateTime _cachedAt = DateTime.fromMillisecondsSinceEpoch(0);

/// Forget the cached leaderboard, e.g. right after a match finishes or a World Cup is won.
void invalidateLeaderboard() => _cache = null;

/// Rankings and achievements, both derived from the matches and World Cup runs already stored.
class RankingsEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// The top [limit] players (at most 50) and the caller's own row, ranked `by` `rating` (Elo, from friend matches
  /// and penalty duels) or `points` (wins, draws and World Cup titles).
  Future<LeaderboardView> leaderboard(Session session, int limit, String? by) async {
    final me = requireUserId(session);
    final all = _sorted(await _entries(session), by ?? 'points');
    final top = all.take(limit.clamp(1, 50)).toList();
    final mine = all.where((e) => e.userId == me).firstOrNull;
    return LeaderboardView(top: top, you: mine, total: all.length);
  }

  /// The same entries ordered by [by], with ranks filled in.
  List<LeaderEntry> _sorted(List<LeaderEntry> entries, String by) {
    final list = [...entries];
    list.sort((a, b) {
      final primary = by == 'rating' ? b.rating.compareTo(a.rating) : b.points.compareTo(a.points);
      if (primary != 0) return primary;
      final byWins = b.wins.compareTo(a.wins);
      return byWins != 0 ? byWins : a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
    return [for (var i = 0; i < list.length; i++) list[i].copyWith(rank: i + 1)];
  }

  Future<List<LeaderEntry>> _entries(Session session) async {
    final now = DateTime.now();
    final cached = _cache;
    if (cached != null && now.difference(_cachedAt) < _cacheFor) return cached;

    final stats = <String, List<int>>{}; // userId -> [played, wins, draws, losses, titles]
    List<int> row(String id) => stats.putIfAbsent(id, () => [0, 0, 0, 0, 0]);

    final matches = await FriendMatch.db.find(session, where: (m) => m.status.equals('finished'));
    for (final m in matches) {
      for (final id in [m.hostUserId, m.guestUserId]) {
        if (id == null) continue;
        final r = row(id);
        r[0]++;
        if (m.winnerUserId == null) {
          r[2]++;
        } else if (m.winnerUserId == id) {
          r[1]++;
        } else {
          r[3]++;
        }
      }
    }
    final champions = await Tournament.db.find(session, where: (t) => t.status.equals('champion'));
    for (final t in champions) {
      row(t.userId)[4]++;
    }

    final profiles = stats.isEmpty
        ? <UserProfile>[]
        : await UserProfile.db.find(session, where: (p) => p.userId.inSet(stats.keys.toSet()));
    final byId = {for (final p in profiles) p.userId: p};

    final entries = <LeaderEntry>[];
    for (final e in stats.entries) {
      final p = byId[e.key];
      if (p == null) continue; // a deleted account drops off the board
      final s = e.value;
      entries.add(
        LeaderEntry(
          rank: 0,
          userId: e.key,
          name: p.displayName,
          avatar: p.avatar,
          played: s[0],
          wins: s[1],
          draws: s[2],
          losses: s[3],
          titles: s[4],
          points: s[1] * _winPoints + s[2] * _drawPoints + s[4] * _titlePoints,
          rating: p.rating,
        ),
      );
    }
    _cache = entries;
    _cachedAt = now;
    return entries;
  }

  /// Every achievement with the caller's progress.
  Future<List<AchievementView>> achievements(Session session) async {
    final profile = await requireProfile(session);
    final me = profile.userId;

    final matches = await FriendMatch.db.find(
      session,
      where: (m) => (m.hostUserId.equals(me) | m.guestUserId.equals(me)) & m.status.equals('finished'),
      orderBy: (m) => m.endedAt,
      limit: 2000,
    );
    var wins = 0, streak = 0, bestStreak = 0, duelWins = 0;
    for (final m in matches) {
      if (m.winnerUserId == me) {
        wins++;
        if (m.mode == 'penalties') duelWins++;
        streak++;
        if (streak > bestStreak) bestStreak = streak;
      } else {
        streak = 0;
      }
    }

    final runs = await Tournament.db.find(session, where: (t) => t.userId.equals(me));
    var qualified = false, reachedFinal = false, champion = false;
    for (final t in runs) {
      final out = t.status == 'eliminated' ? t.eliminatedIn : null;
      if (t.status != 'group' && !(t.status == 'eliminated' && out == 'group')) qualified = true;
      if (t.status == 'final' || t.status == 'champion' || out == 'final') reachedFinal = true;
      if (t.status == 'champion') champion = true;
    }
    var shootoutWin = false, bigWin = false;
    if (runs.isNotEmpty) {
      final nationOf = {for (final t in runs) t.id!: t.nationId};
      final fixtures = await TournamentFixture.db.find(
        session,
        where: (f) => f.tournamentId.inSet(nationOf.keys.toSet()) & f.playedByUser.equals(true),
      );
      for (final f in fixtures) {
        final nation = nationOf[f.tournamentId];
        final home = f.homeNation == nation;
        final mine = (home ? f.homeScore : f.awayScore) ?? 0;
        final theirs = (home ? f.awayScore : f.homeScore) ?? 0;
        if (mine - theirs >= 4) bigWin = true;
        if (f.decidedBy == 'pens') {
          final pm = (home ? f.homePens : f.awayPens) ?? 0;
          final pt = (home ? f.awayPens : f.homePens) ?? 0;
          if (pm > pt) shootoutWin = true;
        }
      }
    }
    final friends = await Friendship.db.count(
      session,
      where: (f) => (f.requesterId.equals(me) | f.addresseeId.equals(me)) & f.status.equals('accepted'),
    );

    AchievementView a(String id, String title, String description, int progress, int target) => AchievementView(
      id: id,
      title: title,
      description: description,
      done: progress >= target,
      progress: progress.clamp(0, target),
      target: target,
    );
    int flag(bool b) => b ? 1 : 0;
    return [
      a('first_match', 'Kick-off', 'Finish a match against a friend.', matches.length, 1),
      a('first_win', 'First win', 'Beat a friend.', wins, 1),
      a('five_wins', 'Regular winner', 'Beat friends 5 times.', wins, 5),
      a('ten_matches', 'Club regular', 'Finish 10 matches against friends.', matches.length, 10),
      a('streak_3', 'Hat-trick of wins', 'Win 3 friend matches in a row.', bestStreak, 3),
      a('wc_qualified', 'Out of the group', 'Qualify for the Round of 32 in the World Cup.', flag(qualified), 1),
      a('wc_final', 'Finalist', 'Reach a World Cup final.', flag(reachedFinal), 1),
      a('wc_champion', 'World champions', 'Win the World Cup.', flag(champion), 1),
      a('pens_hero', 'Shootout hero', 'Win a World Cup game on penalties.', flag(shootoutWin), 1),
      a('big_win', 'Goal feast', 'Win a World Cup game by 4 goals or more.', flag(bigWin), 1),
      a('duel_win', 'Cool from the spot', 'Win an online penalty duel.', duelWins, 1),
      a('rating_1100', 'Rising star', 'Reach a rating of 1100.', profile.rating - 1000, 100),
      a('three_friends', 'Squad goals', 'Have 3 friends.', friends, 3),
      a('your_mark', 'Making your mark', 'Pick an avatar and design your club.', flag(profile.avatar != null) + flag(profile.club != null), 2),
    ];
  }
}
