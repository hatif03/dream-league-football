# Gameplay guide

## Modes

| Mode | Sign-in | What it is |
| --- | --- | --- |
| **World Cup** (solo) | required | One nation, the real 2026 draw, group stage then knockouts against the CPU. Saved on the server |
| **Play online** | required | Against another person: an 11 v 11 **match** or a **penalty duel**, by room code, link, QR, invite, or **Find a match** (matchmaking by rating). Result, rating and head-to-head record saved |
| **Practice** | not needed | Four team-mates and a goalkeeper on an open pitch. No clock, no rules, no pressure. Includes an interactive **tutorial** |
| **Friendly** (11 v 11) | not needed | A full match against the CPU with any two teams, half-time and your formation. Optionally decided by extra time and penalties if level. Nothing is saved; at full time you can play again or share the score |
| **Penalty shootout** | not needed | Just the shootout: five kicks each then sudden death against the CPU, with any two teams. Keyboard, controller or touch |

### Solo World Cup

- **Pick a nation** from all 48 (search, filter by confederation, see squad rating, formation, star players and group mates). Choose the CPU difficulty (easy, normal, hard).
- **Group stage.** The real draw: 12 groups (A–L) of four, three games each. You play your game of each matchday; the server **simulates the other games of that matchday** (never later ones) and updates the table. Tie-breaks: points, then among the tied teams head-to-head points, goal difference and goals scored, then overall goal difference and goals scored, then a deterministic draw.
- **Qualifying.** The top two of every group and the **eight best third-placed teams** go through to the Round of 32. The eight third-placed teams are placed in the official bracket slots by matching each slot's allowed groups (unit-tested for all 495 combinations).
- **Knockouts.** Round of 32, Round of 16, quarter-finals, semi-finals, final, following the real bracket. A level game plays **extra time** (one extra period: one real minute, 30 displayed minutes), and if still level a **penalty shootout** that you play: you take your kicks (aim with the arrows, shoot with `D`) and keep goal for the CPU's. The other ties of the round are simulated.
- **Outcome.** Champion, or the round you were knocked out in. Start another run any time; abandoning a run is a deliberate button.
- **Real time vs match time.** A match is **3 real minutes** by default (choose 3, 5 or 8 in *Settings → Gameplay*) and displays 90 football minutes (the clock counts up from 0:00 to 90:00). Extra time adds a third of that again. There is a **half-time break** at 45': play stops with a banner, everyone returns to the kick-off spots, and the other side kicks off the second half.
- **Formation.** Before a World Cup match, pick how your team lines up: 4-3-3, 4-2-3-1, 4-4-2, 3-5-2 or 3-4-3, with a pitch preview. The choice is remembered. (It does not apply to practice or to friend matches yet.)

### Friendly, tutorial and your club

- **Friendly:** *Practice → 11 v 11 friendly*. Same rules as a World Cup group match (offside, fouls, cards, half-time, added time) but nothing is saved. Tick "If it is level after 90, play extra time and penalties" to settle a draw like a knockout.
- **Penalty shootout:** *Practice → Penalty shootout*. Aim with the arrows (or the stick, or the touch pad) and shoot; when the CPU shoots, dive the right way. Five each, then sudden death.
- **Tutorial:** *Practice → Learn the basics* (offered to new players). A coach on the pitch gives one task at a time (run, sprint, pass, through or long ball, shoot, score, defend) and moves on when you do it. The wording follows your device (keys, controller or touch).
- **Your club:** *Profile → Design your club*. Pick a crest (shape, emblem, colours), a name and a kit; tick "wear this kit" to use it in solo matches and friendlies. It is saved to your account.
- **Achievements and leaderboard:** fourteen achievements (friend matches, streaks, World Cup progress, penalties, duels, rating, big wins, friends, avatar and club) on your profile. The leaderboard ranks players by **rating** (Elo) or by **points** (3 per friend-match win, 1 per draw, 25 per World Cup title).
- **Share a result:** the full-time screen has "Share result". Signed in, the picture is stored on the server and you share a **link** that shows the score as a preview in chat apps (the share sheet on phones, copied to the clipboard on a computer); signed out, you share or download the picture.
- **Daily challenge:** one goal a day on the Online screen (play two matches, win a duel, score four goals...), the same for everybody, with a streak of days in a row.

### Play online

See [MULTIPLAYER.md](MULTIPLAYER.md) for how it works. Pick the game at the top of the Online screen: **11 v 11 match** or **penalty duel**. **Find a match** puts you in the queue and pairs you with someone of a similar rating (the search widens the longer you wait); your rating (starting at 1000) moves after each finished game.

**Penalty duel.** Five penalties each, then sudden death, refereed by the server. Each kick you and your opponent choose one of six zones in secret (top or bottom, left, centre or right): the shooter where to shoot, the keeper where to dive. Corners are the best place to score and the riskiest (they can go wide or hit the post). You have 25 seconds per kick; if you do not choose, the server picks for you.

As a player of a room: *Online → Create a room*; share the code, link or QR; your friend joins; each picks a nation (your favourite nation is pre-selected); both press **I'm ready**; a 3-2-1 count-in starts the match. The nations must differ. You can chat in the room, and during the match a **Chat** button sends quick phrases ("Good luck!", "Nice one!", "GG", 👏 …) that your opponent sees for three seconds. At full time you see possession, shots, on target, saves and cards, and can start a **rematch** (host and guest swap, nations kept). Leaving a match tells your friend immediately and counts as abandoned for you, not as a win for them.

## Controls

The controls follow EA SPORTS FC so they feel familiar. **Settings → Keyboard → Layout** switches between two ready-made layouts taken from the EA FC settings, or you can rebind any key (the layout then shows as "Custom").

| Action | FIFA classic (default, arrows) | EA FC default (WASD) |
| --- | --- | --- |
| Move | Arrow keys | `W` `A` `S` `D` |
| Ground pass | `S` | `L` |
| Lob / cross / slide tackle | `A` | `K` |
| Through pass | `W` | `O` |
| Shoot / tackle | `D` | `;` |
| Sprint | `E` | `P` |
| Change player | `Q` | `I` |
| Jockey (contain) | `C` | `/` |

**Controller** (Xbox layout, as in EA FC): `A` pass, `B` shoot or tackle, `X` lob or slide, `Y` through pass, `RT` sprint, `LT` jockey, `LB` change player, `LB`+`Y` lobbed through ball, `Start` pause. On a PlayStation pad: Cross, Circle, Square, Triangle, R2, L2, L1. All of them can be rebound in *Settings → Controller*.

Pausing is `Esc` (or `Start`); no other key opens the pause menu, so it never collides with a layout.

The rest of this page uses the default keys. Every key can be changed in **Settings**.

| Action | Keyboard | Notes |
| --- | --- | --- |
| Move | Arrow keys | |
| Sprint | `E` | |
| Shot | `D` | Hold to charge, release to shoot. The vertical arrow held as you press picks the top or bottom of the goal |
| Short pass | `S` | Hold for a firmer pass |
| Long pass | `A` | A high ball over defenders |
| Through pass | `W` | Leads the receiver into space |
| Lofted through ball | `Q` + `W` | Hold `Q` while charging `W` |
| Switch player | `Q` | Jumps to the player the hint marker points at |
| Contain (hold) | `C` | Auto-jockeys the carrier and pokes for the ball |
| Standing tackle | `D` without the ball | A short lunge; committing and missing leaves you beaten |
| Slide tackle | `A` without the ball | A long, committed lunge. Risky: a missed or late slide is a foul |

**Charging.** Passes and shots charge on press and fire on release; hold time is power. A quick tap is a soft touch. The power bar sits under your player's name tag (at the top centre on touch devices). You can press a kick button while the ball is still travelling to you and it fires the moment you receive it (a first-time shot or pass).

**Controller.** Any standard gamepad works: the left stick or D-pad moves; face buttons, bumpers and triggers follow the EA FC layout above and can be rebound in *Settings → Controller*. The menus use the D-pad, A to select, B to go back, LB/RB to change tab.

**Touch.** A floating stick on the left; on the right seven buttons (through, long, pass, shot, contain, switch, sprint). Tap for a soft pass or shot; hold a button to charge. The layout can be swapped in *Settings → Touch*. Landscape is required for matches; portrait shows a rotate prompt.

## Rules in the match

- **Restarts:** kick-off after goals, throw-ins (taken with the hands, overhead), corners, goal kicks, with opponents kept back (4 m from a throw-in, 9.15 m from a corner or free kick, 11 m from a goal kick).
- **Offside** is applied to both teams at the moment of the pass: in the opponents' half, ahead of the ball and ahead of the second-last defender.
- **Fouls.** A slide tackle that takes the man (not the ball) is a foul. The CPU fouls too, depending on difficulty. Outside the box: a **free kick** with a four-man wall; inside: a **penalty**.
- **Cards.** Yellow cards for reckless challenges; a second yellow is a red; a very bad foul can be a straight red. A sent-off player leaves the pitch and his team plays a man short.
- **Goalkeepers** come off their line, dive for shots they must reach, catch weak shots and parry hard ones. A keeper may only handle the ball inside his own penalty area, and not from a team-mate's deliberate pass (he plays it with his feet instead). He holds a caught ball briefly before distributing, and the CPU keeper kicks long to an open team-mate.
- **Height.** The ball has a height: lofted passes and strong shots fly, and a ball above head height cannot be intercepted. A lofted pass cannot be intercepted in the air by anyone but its target.
- **Possession and tackling.** The nearest player in reach gets the ball, with a short protection after a clean tackle. A defender in body contact with a carrier slowly wins the ball; approaching from the side or front is much faster than from directly behind.
- **Clock.** 90 displayed minutes in 3 real minutes (or the length you chose), with half-time. At 90' the referee adds time: one minute, plus one for every goal and yellow card and two for a red, up to six, shown as `+N` beside the clock. At full time friend and World Cup group matches end; a drawn knockout goes to extra time and penalties.

## Broadcast touches

In World Cup matches and friendlies against the CPU (switchable in *Settings → Gameplay*):

- **Goal replays.** After the celebration the last four seconds before the goal play back, slightly slowed, with a REPLAY badge. Any key, tap or click skips it. (Not used in online matches, where the simulation must keep running for both players.)
- **Commentary captions.** One short line per event (goal, save, shot, foul, card, offside, corner, penalty, half time, added time, full time), announced to screen readers too.
- **Stadium crowd.** A synthesised crowd murmur that swells for goals, gasps at saves and shots, and groans at fouls (it follows the sound switch in *Settings → Audio*).

## Player ratings

Every player has six ratings on the familiar 1–99 scale: **pace, shooting, passing, dribbling, defending, physicality** (and an overall derived from them by role). They are not decoration: a baseline of 75 means "average", and each rating changes how that player actually plays.

| Rating | Effect |
| --- | --- |
| Pace | Top speed and acceleration of every movement, human and CPU |
| Shooting | Shot power and accuracy |
| Passing | Pass weight and accuracy |
| Dribbling | How much speed is kept while carrying the ball, and turning agility |
| Defending | Tackle reach |
| Physicality | The outcome of shoulder-to-shoulder duels |

So a strong team beats a weak team with the same effort. Squads are the real 2026 World Cup squads with ratings estimated from each player's real profile (the top contenders carefully, smaller squads by role and level).

## CPU difficulty

*Settings → Gameplay* or the World Cup team screen: **Easy** (the CPU is about 12 % slower and a little less accurate, and fouls less often), **Normal**, **Hard** (about 10 % faster, more accurate, fouls more).

## Real-life anchoring

Speeds and kick powers are anchored to real figures so the game "feels like football": a sprint is about 34 km/h, a carried sprint keeps about 90 % of it; shots range from about 70 km/h (a placed side-foot) to about 165 km/h (a screamer); the pitch, goals, penalty area and ball are real size. The ball is drawn slightly larger than life so you can follow it.
