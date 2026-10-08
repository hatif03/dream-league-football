# Football mechanics and experience roadmap

An honest inventory of what the match has, what a football game normally has that this one does not, and what to do about it. It reflects the code as of 8 October 2026.

## What the match already has

| Area | In the game |
| --- | --- |
| Match flow | Kick-off, half-time break, **added time at 90'**, full time, extra time and a penalty shootout in knockouts (and optionally in friendlies), a selectable match length (3, 5 or 8 real minutes) |
| Restarts | Throw-ins (by hand), corners, goal kicks, free kicks with a four-man wall, penalties, kick-off after a goal, offside |
| Discipline | Fouls (human slide tackles, and CPU fouls), yellow and red cards, a sent-off player leaves the pitch |
| Ball | Real-size pitch, ball height (lofted passes, chips, shots that rise or dip), charged power, accuracy that falls with power |
| Passing and shooting | Short, long, through and lofted-through passes, pass receiver selection and lane checks, first-time kicks, shot assist |
| Defending | Standing tackle, slide tackle, contain, second-defender pressure, marking |
| Goalkeepers | Positioning, dives, parries, catching only inside the box and not from a back-pass, long clearances |
| Players | Six ratings that change how each player really plays, kits, real squads for 48 nations |
| Tactics | **Choice of formation** (4-3-3, 4-2-3-1, 4-4-2, 3-5-2, 3-4-3) before a World Cup match (new) |
| Competition | Solo World Cup with the real draw and bracket, three CPU difficulties, online matches and **penalty duels** with matchmaking, Elo ratings and a daily challenge |
| Broadcast | **Goal replays**, commentary captions, a synthesised stadium crowd (new) |

## What is missing, ranked

**Cheap (hours) and worthwhile**

- Added time at the end of the first half too, and the second half swapping the direction of play. (Added time at 90' is done.)
- The advantage rule: let play go on after a foul when the fouled side keeps the ball.
- A stamina bar for sprinting, so pressing and long runs cost something.
- Choose the free-kick taker and corner taker; show an aiming arrow and a curve option for free kicks (the free-kick mechanic is functional but basic: it has a wall and a taker, but not much player control).
- A man-of-the-match line on the full-time screen, and replays of saves and near misses (goal replays are done).
- Penalties for a foul by a defender who denies a clear goal-scoring chance (a red card in the box).

**Medium (days)**

- A cross button, with headers and volleys, so wide play has a purpose.
- Skill moves and ball shielding for dribblers.
- Squads of 18 with substitutions, and injuries.
- Team tactics presets (press high, hold the line, counter) next to formations.
- Handball and other less common fouls.
- Manual goalkeeper control (and a keeper-only mode).

**Large (weeks)**

- VAR, spoken commentary, weather and stadiums. (Goal replays and commentary captions are done.)
- Spectating a friend's match.
- A career or manager mode with a season, transfers and a youth squad.

## Experience ideas, ranked

**Done in this round**

- Pre-made **avatars** (24), shown on the profile, in friends, in invites and in rooms.
- Choice of **formation** and **match length**.
- A **ping** readout in online matches, and **fair latency** (below).
- Notifications that close themselves; a Join button that works from anywhere.
- A small **vibration** on touch buttons and goals.

**Done in the second round**

- A full **11 v 11 friendly** against the CPU with any two teams (Practice → "11 v 11 friendly"), with formation choice and half-time.
- **Quick chat** in online matches (ten phrases and emotes sent over the match channel).
- An interactive **tutorial** (run, sprint, pass, through ball, shoot, score, defend), offered to new players.
- **Install as an app** (web app manifest, icons and an install card in Settings).
- **Shareable result cards**: a picture of the score (share sheet on phones, download on a computer).
- **Settings saved to your account** (keys, controller and touch layouts, difficulty, match length, formation, sound).
- A **club crest and kit editor**, saved to your account and worn in solo matches and friendlies.
- **Achievements** (12) and a global **leaderboard**.

**Done in the third round (Serverpod showcase)**

- **FIFA-style controls:** a keyboard layout switch (FIFA classic arrows / EA FC WASD), the EA FC controller layout, pause only on `Esc`/Start.
- **Penalty shootout mode** (Practice → Penalty shootout), friendlies that can be decided by extra time and penalties, and shootouts that work with controller and touch.
- **Online penalty duel** refereed by the Serverpod server (secret choices, server randomness, 25-second kicks).
- **Matchmaking** by rating for matches and duels.
- **Elo ratings**, an anti-farming cap, a leaderboard by rating or points, two new achievements.
- **Daily challenge** with a streak.
- **Live push** over a `/live` WebSocket route, replacing most polling.
- **Serverpod future calls:** a nightly maintenance cron and a timeout for every penalty kick.
- **Cloud storage + share links** with Open Graph previews (`/r/<id>`).
- **Match upgrades:** goal replays, commentary captions, a synthesised crowd, added time.
- Server **integration tests** with `serverpod_test`.

**Not done: Google or Apple sign-in.** Serverpod supports both, but each needs OAuth credentials created in your own Google Cloud or Apple Developer account (a client ID and secret that you must own and register the app's URLs with). Serverpod Cloud does not provide shared ones, so it was left out as agreed. To add it later: create the credentials, store them with `scloud password set`, and enable the provider in `server.dart` next to the email provider.

**Next, cheap (remaining)**

- A "recent opponents" list so a rematch with a friend is one tap.
- A low-graphics mode for older phones.
- Formation choice and your club kit in online matches (needs both choices carried in the room).
- Offline play (a service worker) for practice and friendlies.

**Next, bigger**

- Seasonal leaderboards and friends-only rankings.
- Sign-in with Google or Apple (see above: needs your own credentials).
- Ranked 11 v 11 matches that cannot be cheated. Today the rating moves for signed 11 v 11 results too, but a modified host could still cheat that kind of match (the penalty duel cannot be cheated: the server referees it); a pair can only earn rating from five matches a day. Fixing this needs a server-side referee or replay verification.
- Spectating, tournaments between friends, seasonal rating resets.

## Latency fairness in online matches

An online match is simulated in the host's browser. The host's key presses take effect at once; the guest's presses cross the network first. A reviewer rightly called this a large advantage for the host (near 0 ms against 80 ms or more).

What the game does now, only in online matches and only for the host:

1. Both browsers measure the round-trip time with a small ping on the existing once-a-second heartbeat. Each player sees the result as a "ms" chip under the pause button.
2. The host holds back their **own** key presses by half the round trip (capped at 100 ms), the time a guest's press takes to reach the simulation. The order of presses and releases is always kept. Practice, World Cup and the guest's controls are untouched.

What this does **not** fix: the guest still **sees** the match about 110 ms late (that delay is deliberate, it smooths 30 snapshots a second) plus half the round trip, so the guest reacts to a slightly older picture. Closing that gap fully would need prediction and rollback for the guest, which is a large change to the engine; the delay above removes the input half of the advantage without touching the simulation.

Because the host runs the simulation, a modified host can still cheat. The two-signature result and the guest's plausibility check limit what that can achieve (see [MULTIPLAYER.md](MULTIPLAYER.md)); a fully ranked 11 v 11 mode would need a server-side referee. The penalty duel is the first game built that way.
