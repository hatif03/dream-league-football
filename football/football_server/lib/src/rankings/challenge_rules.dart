/// One day's challenge. They rotate through [_defs] by the date, so every player gets the same one,
/// and past days can be recomputed to count a streak without storing anything.
class ChallengeDef {
  const ChallengeDef(this.kind, this.title, this.description, this.target);
  final String kind;
  final String title;
  final String description;
  final int target;
}

/// What the rules need to know about one finished online match of a player.
typedef ChallengeMatch = ({String mode, bool won, int goals});

const _defs = [
  ChallengeDef('play_matches', 'Warm-up', 'Play 2 online matches today.', 2),
  ChallengeDef('win_matches', 'Winner', 'Win an online match today.', 1),
  ChallengeDef('win_duel', 'Nerves of steel', 'Win a penalty duel today.', 1),
  ChallengeDef('score_goals', 'Goal feast', 'Score 4 goals in online matches today.', 4),
  ChallengeDef('play_duels', 'Spot kick specialist', 'Play 2 penalty duels today.', 2),
  ChallengeDef('win_matches', 'Double up', 'Win 2 online matches today.', 2),
  ChallengeDef('play_matches', 'Match day', 'Play 3 online matches today.', 3),
];

/// The UTC day as `YYYY-MM-DD`.
String dayKey(DateTime t) {
  final u = t.toUtc();
  return '${u.year.toString().padLeft(4, '0')}-${u.month.toString().padLeft(2, '0')}-${u.day.toString().padLeft(2, '0')}';
}

/// The challenge of the UTC day containing [t].
ChallengeDef challengeFor(DateTime t) {
  final u = t.toUtc();
  final days = DateTime.utc(u.year, u.month, u.day).millisecondsSinceEpoch ~/ Duration.millisecondsPerDay;
  return _defs[days % _defs.length];
}

/// How far [matches] (that day's finished matches of one player) get them through [def].
int challengeProgress(ChallengeDef def, List<ChallengeMatch> matches) {
  switch (def.kind) {
    case 'play_matches':
      return matches.where((m) => m.mode == 'match').length;
    case 'win_matches':
      return matches.where((m) => m.mode == 'match' && m.won).length;
    case 'win_duel':
      return matches.where((m) => m.mode == 'penalties' && m.won).length;
    case 'play_duels':
      return matches.where((m) => m.mode == 'penalties').length;
    case 'score_goals':
      return matches.where((m) => m.mode == 'match').fold(0, (a, m) => a + m.goals);
  }
  return 0;
}

/// Days in a row, ending with [today] if it is done (or yesterday if not), on which the day's challenge was met.
/// [byDay] maps a day key to that day's finished matches.
int challengeStreak(DateTime today, Map<String, List<ChallengeMatch>> byDay) {
  var streak = 0;
  var d = DateTime.utc(today.toUtc().year, today.toUtc().month, today.toUtc().day);
  bool met(DateTime day) {
    final def = challengeFor(day);
    return challengeProgress(def, byDay[dayKey(day)] ?? const []) >= def.target;
  }

  if (met(d)) streak++;
  d = d.subtract(const Duration(days: 1));
  for (var i = 0; i < 60 && met(d); i++) {
    streak++;
    d = d.subtract(const Duration(days: 1));
  }
  return streak;
}
