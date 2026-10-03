# Gameplay guide

## Modes

| Mode | Sign-in | What it is |
| --- | --- | --- |
| **World Cup** (solo) | required | One nation, the real 2026 draw, group stage then knockouts against the CPU. Saved on the server |
| **Play a friend** (online) | required | Head-to-head against another person, by room code, link, QR or invite. Result and head-to-head record saved |
| **Practice** | not needed | Four team-mates and a goalkeeper on an open pitch. No clock, no rules, no pressure |

### Solo World Cup

- **Pick a nation** from all 48 (search, filter by confederation, see squad rating, formation, star players and group mates). Choose the CPU difficulty (easy, normal, hard).
- **Group stage.** The real draw: 12 groups (A–L) of four, three games each. You play your game of each matchday; the server **simulates the other games of that matchday** (never later ones) and updates the table. Tie-breaks: points, then among the tied teams head-to-head points, goal difference and goals scored, then overall goal difference and goals scored, then a deterministic draw.
- **Qualifying.** The top two of every group and the **eight best third-placed teams** go through to the Round of 32. The eight third-placed teams are placed in the official bracket slots by matching each slot's allowed groups (unit-tested for all 495 combinations).
- **Knockouts.** Round of 32, Round of 16, quarter-finals, semi-finals, final, following the real bracket. A level game plays **extra time** (one extra period: one real minute, 30 displayed minutes), and if still level a **penalty shootout** that you play: you take your kicks (aim with the arrows, shoot with `D`) and keep goal for the CPU's. The other ties of the round are simulated.
- **Outcome.** Champion, or the round you were knocked out in. Start another run any time; abandoning a run is a deliberate button.
- **Real time vs match time.** A match is **3 real minutes** and displays 90 football minutes (the clock counts up from 0:00 to 90:00). Extra time adds one real minute (30 displayed).

### Play a friend

See [MULTIPLAYER.md](MULTIPLAYER.md) for how it works. As a player: *Online → Create a room*; share the code, link or QR; your friend joins; each picks a nation (your favourite nation is pre-selected); both press **I'm ready**; a 3-2-1 count-in starts the match. The nations must differ. You can chat in the room. At full time you see possession, shots, on target, saves and cards, and can start a **rematch** (host and guest swap, nations kept). Leaving a match tells your friend immediately and counts as abandoned for you, not as a win for them.

## Controls

Defaults. Every key can be changed in **Settings**.

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

**Controller.** Any standard gamepad works: the left stick or D-pad moves; face buttons, bumpers and triggers map to the actions and can be rebound in *Settings → Controller*. The menus use the D-pad, A to select, B to go back, LB/RB to change tab.

**Touch.** A floating stick on the left; on the right seven buttons (through, long, pass, shot, contain, switch, sprint). Tap for a soft pass or shot; hold a button to charge. The layout can be swapped in *Settings → Touch*. Landscape is required for matches; portrait shows a rotate prompt.

## Rules in the match

- **Restarts:** kick-off after goals, throw-ins (taken with the hands, overhead), corners, goal kicks, with opponents kept back (4 m from a throw-in, 9.15 m from a corner or free kick, 11 m from a goal kick).
- **Offside** is applied to both teams at the moment of the pass: in the opponents' half, ahead of the ball and ahead of the second-last defender.
- **Fouls.** A slide tackle that takes the man (not the ball) is a foul. The CPU fouls too, depending on difficulty. Outside the box: a **free kick** with a four-man wall; inside: a **penalty**.
- **Cards.** Yellow cards for reckless challenges; a second yellow is a red; a very bad foul can be a straight red. A sent-off player leaves the pitch and his team plays a man short.
- **Goalkeepers** come off their line, dive for shots they must reach, catch weak shots and parry hard ones. A keeper may only handle the ball inside his own penalty area, and not from a team-mate's deliberate pass (he plays it with his feet instead). He holds a caught ball briefly before distributing, and the CPU keeper kicks long to an open team-mate.
- **Height.** The ball has a height: lofted passes and strong shots fly, and a ball above head height cannot be intercepted. A lofted pass cannot be intercepted in the air by anyone but its target.
- **Possession and tackling.** The nearest player in reach gets the ball, with a short protection after a clean tackle. A defender in body contact with a carrier slowly wins the ball; approaching from the side or front is much faster than from directly behind.
- **Clock.** 90 displayed minutes in 3 real minutes. At full time friend and World Cup group matches end; a drawn knockout goes to extra time and penalties.

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
