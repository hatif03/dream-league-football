import 'dart:math';

import 'package:serverpod/serverpod.dart';

import '../auth/current_user.dart';
import '../data/world_cup_data.dart';
import '../generated/protocol.dart';
import 'group_logic.dart';
import 'knockout.dart';

const _maxScore = 30;
const _finishedStatuses = {'eliminated', 'champion'};

/// Kick-off dates are only for ordering and display: the real 2026 knockout calendar.
final _roundStart = {
  'r32': DateTime.utc(2026, 6, 28, 19),
  'r16': DateTime.utc(2026, 7, 4, 19),
  'qf': DateTime.utc(2026, 7, 9, 19),
  'sf': DateTime.utc(2026, 7, 14, 19),
  'final': DateTime.utc(2026, 7, 19, 19),
};

class TournamentEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  final _rng = Random();

  /// The caller's most recent run, or null if they never started one.
  Future<TournamentView?> current(Session session) async {
    final t = await _latest(session);
    return t == null ? null : _view(session, t);
  }

  /// Starts a run as [nationId]. Only one run may be in progress.
  Future<TournamentView> start(Session session, String nationId) async {
    await requireProfile(session);
    if (!wcNations.containsKey(nationId)) throw GameException(message: 'Unknown nation.');
    final existing = await _latest(session);
    if (existing != null && !_finishedStatuses.contains(existing.status)) {
      throw GameException(message: 'A World Cup run is already in progress.');
    }

    final days = assignMatchdays(wcFixtures);
    final created = await session.db.transaction((tx) async {
      final t = await Tournament.db.insertRow(
        session,
        Tournament(userId: requireUserId(session), nationId: nationId, status: 'group'),
        transaction: tx,
      );
      await TournamentFixture.db.insert(
        session,
        [
          for (final f in wcFixtures)
            TournamentFixture(
              tournamentId: t.id!,
              round: 'group',
              groupName: f.group,
              matchday: days[f]!,
              kickoffUtc: f.kickoffUtc,
              homeNation: f.home,
              awayNation: f.away,
              venue: f.venue,
              playedByUser: false,
            ),
        ],
        transaction: tx,
      );
      return t;
    });
    return _view(session, created);
  }

  /// Drops the run in progress so the player can start another.
  Future<void> abandon(Session session) async {
    final t = await _latest(session);
    if (t == null) return;
    await session.db.transaction((tx) async {
      await TournamentFixture.db.deleteWhere(
        session,
        where: (f) => f.tournamentId.equals(t.id!),
        transaction: tx,
      );
      await Tournament.db.deleteRow(session, t, transaction: tx);
    });
  }

  /// Saves the score of the fixture the player just played.
  ///
  /// Group stage: the other games on that same matchday are simulated (never later ones).
  /// Knockouts: a level game needs shootout goals; the other ties of the round are simulated,
  /// then the next round is drawn from the winners. Sending the same [nonce] again returns
  /// the saved state instead of failing.
  Future<TournamentView> submitResult(
    Session session,
    UuidValue tournamentId,
    UuidValue fixtureId,
    String nonce,
    int homeScore,
    int awayScore,
    int? homePens,
    int? awayPens,
    String? decidedBy,
  ) async {
    await requireProfile(session);
    if (nonce.isEmpty || nonce.length > 64) throw GameException(message: 'Bad nonce.');
    if (homeScore < 0 || awayScore < 0 || homeScore > _maxScore || awayScore > _maxScore) {
      throw GameException(message: 'Impossible score.');
    }

    return session.db.transaction((tx) async {
      final t = await Tournament.db.findById(session, tournamentId, transaction: tx, lockMode: LockMode.forUpdate);
      if (t == null || t.userId != requireUserId(session)) {
        throw GameException(message: 'Run not found.');
      }
      final fixtures = await _fixtures(session, t, tx);
      final mine = fixtures.where((f) => f.id == fixtureId).firstOrNull;
      if (mine == null) throw GameException(message: 'Fixture not found.');
      if (mine.nonce == nonce) return _view(session, t, fixtures: fixtures, tx: tx);
      if (_finishedStatuses.contains(t.status)) throw GameException(message: 'This run is over.');
      if (mine.homeScore != null) throw GameException(message: 'That fixture was already played.');
      if (mine.homeNation != t.nationId && mine.awayNation != t.nationId) {
        throw GameException(message: 'That is not your fixture.');
      }
      if (mine.round != t.status) throw GameException(message: 'That fixture is not in the current round.');
      final next = _nextFixture(t, fixtures);
      if (next?.id != mine.id) throw GameException(message: 'Play your fixtures in order.');

      final knockout = mine.round != 'group';
      final ko = KoResult(homeScore, awayScore, homePens, awayPens);
      if (knockout ? !ko.valid : (homePens != null || awayPens != null)) {
        throw GameException(message: knockout ? 'A knockout game needs a winner.' : 'No shootouts in the group stage.');
      }
      mine
        ..homeScore = homeScore
        ..awayScore = awayScore
        ..homePens = knockout ? homePens : null
        ..awayPens = knockout ? awayPens : null
        ..decidedBy = knockout ? (homePens != null ? 'pens' : (decidedBy == 'et' ? 'et' : '90')) : null
        ..playedByUser = true
        ..nonce = nonce;
      final changed = [mine];

      if (!knockout) {
        for (final f in fixtures) {
          if (f.homeScore == null && f.round == 'group' && f.matchday == mine.matchday && f.id != mine.id) {
            final (h, a) = simulateScore(wcNations[f.homeNation]!, wcNations[f.awayNation]!, _rng);
            f
              ..homeScore = h
              ..awayScore = a;
            changed.add(f);
          }
        }
        await TournamentFixture.db.update(session, changed, transaction: tx);
        if (fixtures.where((f) => f.round == 'group').every((f) => f.homeScore != null)) {
          await _endGroupStage(session, t, fixtures, tx);
        }
      } else {
        for (final f in fixtures) {
          if (f.homeScore == null && f.round == mine.round && f.id != mine.id) {
            final r = simulateKnockout(wcNations[f.homeNation]!, wcNations[f.awayNation]!, _rng);
            f
              ..homeScore = r.home
              ..awayScore = r.away
              ..homePens = r.homePens
              ..awayPens = r.awayPens
              ..decidedBy = r.homePens != null ? 'pens' : '90';
            changed.add(f);
          }
        }
        await TournamentFixture.db.update(session, changed, transaction: tx);
        await _endKnockoutRound(session, t, mine, fixtures, tx);
      }
      return _view(session, t, fixtures: fixtures, tx: tx);
    });
  }

  /// All 72 group games are in: the player goes through to the Round of 32 or is out.
  Future<void> _endGroupStage(Session session, Tournament t, List<TournamentFixture> fixtures, Transaction tx) async {
    final stage = computeGroupStage(_resultsByGroup(fixtures));
    if (!stage.qualified.contains(t.nationId)) {
      t
        ..status = 'eliminated'
        ..eliminatedIn = 'group'
        ..finishedAt = DateTime.now().toUtc();
      await Tournament.db.updateRow(session, t, transaction: tx);
      return;
    }
    final created = <TournamentFixture>[];
    final pairs = buildR32(stage);
    for (var i = 0; i < pairs.length; i++) {
      created.add(_koFixture(t, pairs[i].$1, 'r32', pairs[i].$2, pairs[i].$3, i));
    }
    fixtures.addAll(await TournamentFixture.db.insert(session, created, transaction: tx));
    t.status = 'r32';
    await Tournament.db.updateRow(session, t, transaction: tx);
  }

  /// A knockout round is complete: the player is out, champion, or moves to the next round.
  Future<void> _endKnockoutRound(
    Session session,
    Tournament t,
    TournamentFixture played,
    List<TournamentFixture> fixtures,
    Transaction tx,
  ) async {
    final userWon = _winner(played) == t.nationId;
    if (!userWon) {
      t
        ..status = 'eliminated'
        ..eliminatedIn = played.round
        ..finishedAt = DateTime.now().toUtc();
    } else if (played.round == 'final') {
      t
        ..status = 'champion'
        ..finishedAt = DateTime.now().toUtc();
    } else {
      final nextRound = roundOrder[roundOrder.indexOf(played.round) + 1];
      final byNo = {for (final f in fixtures.where((f) => f.matchNo != null)) f.matchNo!: f};
      final created = <TournamentFixture>[];
      var i = 0;
      for (final no in matchesOfRound(nextRound)) {
        final src = feeders[no]!;
        created.add(_koFixture(t, no, nextRound, _winner(byNo[src.$1]!)!, _winner(byNo[src.$2]!)!, i++));
      }
      fixtures.addAll(await TournamentFixture.db.insert(session, created, transaction: tx));
      t.status = nextRound;
    }
    await Tournament.db.updateRow(session, t, transaction: tx);
  }

  TournamentFixture _koFixture(Tournament t, int no, String round, String home, String away, int i) {
    return TournamentFixture(
      tournamentId: t.id!,
      round: round,
      groupName: '',
      matchday: 0,
      matchNo: no,
      kickoffUtc: _roundStart[round]!.add(Duration(hours: i * 3)),
      homeNation: home,
      awayNation: away,
      venue: 'Match $no',
      playedByUser: false,
    );
  }

  /// Winning nation of a played fixture (a shootout decides a level knockout game).
  String? _winner(TournamentFixture f) {
    if (f.homeScore == null) return null;
    if (f.homeScore! != f.awayScore!) return f.homeScore! > f.awayScore! ? f.homeNation : f.awayNation;
    if (f.homePens == null || f.awayPens == null) return null;
    return f.homePens! > f.awayPens! ? f.homeNation : f.awayNation;
  }

  Future<Tournament?> _latest(Session session) {
    return Tournament.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(requireUserId(session)),
      orderBy: (t) => t.createdAt.desc(),
    );
  }

  Future<List<TournamentFixture>> _fixtures(Session session, Tournament t, Transaction? tx) async {
    final rows = await TournamentFixture.db.find(
      session,
      where: (f) => f.tournamentId.equals(t.id!),
      orderBy: (f) => f.kickoffUtc,
      transaction: tx,
    );
    return [...rows];
  }

  /// The player's next unplayed game in the current round.
  TournamentFixture? _nextFixture(Tournament t, List<TournamentFixture> fixtures) {
    if (_finishedStatuses.contains(t.status)) return null;
    return fixtures
        .where(
          (f) =>
              f.homeScore == null &&
              f.round == t.status &&
              (f.homeNation == t.nationId || f.awayNation == t.nationId),
        )
        .firstOrNull;
  }

  Map<String, List<GroupResult>> _resultsByGroup(List<TournamentFixture> fixtures) {
    final out = <String, List<GroupResult>>{};
    for (final f in fixtures.where((f) => f.round == 'group' && f.homeScore != null)) {
      out
          .putIfAbsent(f.groupName, () => [])
          .add(GroupResult(f.homeNation, f.awayNation, f.homeScore!, f.awayScore!));
    }
    return out;
  }

  Future<TournamentView> _view(
    Session session,
    Tournament t, {
    List<TournamentFixture>? fixtures,
    Transaction? tx,
  }) async {
    final all = fixtures ?? await _fixtures(session, t, tx);
    final results = _resultsByGroup(all);
    final stage = computeGroupStage(results);
    final standings = <StandingRow>[
      for (final e in stage.tables.entries)
        for (var i = 0; i < e.value.length; i++)
          StandingRow(
            groupName: e.key,
            nationId: e.value[i].nation,
            position: i + 1,
            played: e.value[i].played,
            won: e.value[i].won,
            drawn: e.value[i].drawn,
            lost: e.value[i].lost,
            goalsFor: e.value[i].gf,
            goalsAgainst: e.value[i].ga,
            points: e.value[i].points,
            qualified: (results[e.key]?.length ?? 0) == 6 && stage.qualified.contains(e.value[i].nation),
          ),
    ];
    final next = _nextFixture(t, all);
    return TournamentView(
      tournament: t,
      fixtures: all,
      standings: standings,
      nextFixtureId: next?.id,
      matchday: next?.matchday ?? 0,
    );
  }
}
