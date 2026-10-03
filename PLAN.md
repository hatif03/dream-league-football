# Plan: online Dream League Football

> **Naming.** The game is called **Dream League Football** (renamed in October 2026). Its solo mode is still "World Cup", played with the 48 nations of the 2026 World Cup. The engine's internal codename `PitchKick` (class `PitchKickGame`) and the Serverpod Cloud project id `football` (which fixes the URLs `football.serverpod.space` and `football.api.serverpod.space`) are unchanged on purpose. See [README.md](README.md) and [docs/](docs/) for the finished system; this file is the design history and the reasoning behind it.

This is the build plan for turning the current browser game into a deployed online game, with Serverpod as the accounts and database backend.

The pitch simulation stays in TypeScript, inside one player's browser. The two browsers connect with WebRTC (PeerJS or the browser's own data channel). Serverpod does not run the live match. It owns accounts, the room, the handshake that introduces the two peers, and the saved result.

Two ways to play a match that is remembered. Alone, you take one nation from the group draw through to the final against the CPU, and every result is saved. With a friend, you invite them or share a room code, and the saved match names who won and who lost. Practice stays in the browser and is not recorded.

## 0. Review of this plan (October 2026): holes found and decisions

Checked against Serverpod 4.0.3 source and the current repo. Each item below overrides the section it names.

**Wrong or unnecessary**

1. **No hand-written Relic JSON routes (§4).** Serverpod already serves every endpoint method as `POST /<endpoint>/<method>` with a JSON body and `Authorization: Bearer <jwt>`. The React app calls those with `fetch`. We write plain Dart endpoints and a ~60-line `api.ts`. Relic is used only for the two things endpoints cannot do: serving the built web app, and the relay WebSocket.
2. **Auth is not `/api/auth/*` (§4).** Use the generated `emailIdp` endpoints. Registration is three calls: `startRegistration(email)` → emailed code → `verifyRegistrationCode(accountRequestId, code)` → `finishRegistration(token, password)`. Signup therefore needs a code-entry step. Dev prints the code in the server log. Production sends it through Serverpod Cloud email with no config.
3. **JWT access tokens last 10 minutes.** The client must store the refresh token and call `jwtRefresh.refreshAccessToken` before expiry or on a 401. The plan said "session survives a refresh" without saying how.
4. **A result "hash" is pointless (§2).** The server sees the plaintext. Each peer posts the structured claim (home/away nation, scores, end reason). The server compares fields and stores both claims.
5. **The constants checksum is too narrow (§2, §5).** `engine.ts`, `ratings.ts`, and the team files change physics as much as `constants.ts`. The version check is a build hash of `src/client/game/**`, injected by Vite.
6. **The plan contradicts itself on an unsaved CPU match.** §3 allowed one, §4 removed it. Decision: the front has World Cup, Play with a friend, and Practice. Logged out, only Practice works. There is no unsaved exhibition mode.

**Missing**

7. **Where the web app is hosted.** Decision: the built Vite bundle is served by the Serverpod web server (static route plus SPA fallback). One origin in production, so no CORS and no cookie question. In dev, Vite runs on 5173 and Serverpod allows that origin.
8. **Authorization rules.** Every endpoint requires login. A match, lobby, and signal row is readable only by its participants. A tournament only by its owner. Friend and block checks run on invite and join. Profile names are unique case-insensitively (`displayNameLower` with a unique index).
9. **Tournament result forgery.** Anyone can POST any score for their own run with curl. That is accepted, since there is no leaderboard. The server still validates: fixture belongs to that run, is unplayed, is the next matchday, scores are integers 0–30, and the nonce is new.
10. **Matchday is undefined in the data.** Define it: a team's n-th group game in kickoff order. A matchday is complete for a group when both of its games are stored.
11. **Third-placed slots.** FIFA's Annex C table (495 rows) cannot be reproduced from memory and must not be invented. Each Round-of-32 slot that takes a third-placed team publishes its set of allowed groups. Assign the eight qualifiers by bipartite matching over those sets, then confirm the sets against the FIFA regulations before knockouts ship. Knockouts stay after the group stage.
12. **Tie-break order.** Points, then among the tied teams only: head-to-head points, goal difference, goals scored; then overall goal difference, goals scored; then a deterministic draw seeded by the nation id. Fair-play points are not modelled.
13. **Ragequit is a grief vector (§3, §5).** "One signature means void" lets the loser close the tab to dodge a loss. Decision: still no win is awarded, but the row is stored as `abandoned` with the leaver's id (the peer who stayed claims it), and the profile shows an abandon count. No ranking depends on it.
14. **Signalling is two posts, not a polling storm.** Use non-trickle ICE: wait for candidate gathering (cap 2 s), then post one offer and one answer that already contain every candidate. Poll the signal route about 4 times a second until the answer arrives. `ice` rows are dropped.
15. **Two data channels.** One unreliable and unordered for snapshots, one reliable and ordered for inputs and events. §5 implied this; it is now a requirement.
16. **The relay is a Relic WebSocket route, not a Serverpod stream endpoint.** A TypeScript client cannot speak Serverpod's stream protocol. Whether Serverpod Cloud keeps one socket open for a whole match is unverified. Test it at deploy before promising the fallback.
17. **Rate limits.** Serverpod has none built in. A small in-memory token bucket (per user, per action) guards signup-adjacent and spammy endpoints: create room, chat, friend request. One instance only; move to the database if it scales out.
18. **Account deletion.** Match, lobby and friendship rows reference users with a plain nullable id (no cascade). Deleting a user nulls the id and the UI shows "removed player".
19. **Engine size.** `engine.ts` is 3,518 lines, not ~1,900. Making the away side drivable by a second human is the largest single task and gets its own gate (§6, phase 3).
20. **Hidden host tab.** `requestAnimationFrame` drops to ~1 Hz in a hidden tab. The host's loop uses a fixed timestep with a catch-up cap, and the host shows a warning banner on `visibilitychange`.

**Decisions on layout.** The Serverpod project is `football/` at the repo root (`football_server`, `football_client`), matching the existing Serverpod Cloud project id `football`. The generated Dart client stays unused by React. Local development uses embedded Postgres through `database.dataPath`, so Docker is not needed.

## 0b. Build status (October 2026)

Live at <https://football.serverpod.space> (web) and <https://football.api.serverpod.space> (API), project `football` on Serverpod Cloud. Deploy: `npm run build:web`, then `scloud deploy` from `football/football_server`.

**Built and tested**

- **Phase 0–1.** Serverpod 4.0.3 project in `football/`. The original Node template server is gone. React talks to generated endpoints with `fetch` (`src/client/api/`). Email sign-up with the emailed code, sign-in, password reset, JWT refresh, unique display name, terms and privacy pages, account deletion. New game front with World Cup, Play a Friend and Practice.
- **Phase 2.** Solo World Cup, complete: the real group draw, matchday-limited simulation of the other games, group tables with head-to-head, the 2026 knockout bracket (slots checked against FIFA and Wikipedia), extra time, a penalty shootout you take and keep goal in, champion or the round you went out. Unit tests cover all 495 combinations of third-placed groups.
- **Phase 3–4.** Online friend matches. Host browser runs `PitchKickGame` with a guest seat; the guest draws snapshots (`GuestView`). Direct WebRTC with a Serverpod WebSocket relay as fallback, both tested in real browsers. Rooms by code or link, invites, lobby chat, ready-up, rematch with host swapped, build check, two-signature results (`resolveClaims`), abandon and void handling, reconnect for 25 s, a plausibility check on the host's stream.
- **Phase 5.** Friends (by exact name), blocks, invites, reports with match context, record and head-to-head, maintenance switch, audit log, operator endpoints (suspend, void a match, stats).
- **Phase 6.** Controller (Gamepad API, rebindable) and touch controls (stick plus seven buttons, layout swappable), settings tabs, the legend follows the last device used.
- **Phase 7.** Fouls from slide tackles, free kicks with a four-man wall, penalties, match stats (possession, shots, on target, saves) shown at full time and stored for friend matches.

**Where the build differs from the plan above**

- No hand-written API routes (item 1 of §0). Nation ids are derived from the team name (`unitedstates`, `czechrepublic`), not the file key.
- The WebRTC handshake lives on the `FriendMatch` row (`offer`, `answer`), not in a `MatchSignal` table. `Lobby` has host and guest columns, not a `LobbySeat` table. The solo run keeps its results in `TournamentFixture`, with no `Match` row per game.
- The server compares the two result claims as plain text rather than a hash (item 4). A claim is `hostGoals:guestGoals:reason:leaver`.
- The hidden-tab problem is solved with a Web Worker clock (`enableBackgroundTicks`), not a fixed-step catch-up.

**Added after the first live test (3 October 2026)**

A first real match between two accounts exposed the gaps below; all are built, tested locally in real browsers, and deployed.

- **A complete UI rework** ("Matchday Night", see [UI_PLAN.md](UI_PLAN.md) and [docs/UI.md](docs/UI.md)): console-style menus you can drive with arrows, Enter/Esc or a pad, a footer that shows the buttons of the device used last, route-based screens, real dialogs instead of `window.confirm`, flags, menu sounds, a phone layout with a bottom tab bar, landscape matches and a rotate prompt.
- **Match creation and sharing**: one tap creates a room; code, link, share sheet and QR are ready at once; the joiner types a 5-character code or opens the link; both players see joins, leaves, nation picks and readiness live; a 3-2-1 count-in starts the match.
- **Leaving is now reported.** `friendMatch/leave` ends a live match at once as `abandoned` with the leaver recorded; the opponent gets a "left the match" screen within about 100 ms (a `bye` frame on the channel, then a server poll as a backstop). Closing the tab reports the same thing (`fetch` with `keepalive` on `pagehide`), and a waiting lobby is freed the same way.
- **Presence**: `UserProfile.lastSeenAt` and `PersonView.online` (75 s window) drive the green dot and the invite toast.
- **Referee and difficulty**: yellow and red cards, CPU fouls, three CPU difficulty levels, extra match stats (cards).
- **Naming**: the application is now Dream League Football, including the Serverpod sign-in email.

**Still open**

- Production sign-up cannot be smoke-tested without a real inbox; the operator endpoints need `scloud password set adminUserIds <user-id>` before they work.
- A friend whose tab is closed mid-reconnect waits out the 25 s window; there is no "host migration".
- The relay is verified locally for a whole match; a full match over Serverpod Cloud's relay has not been timed in production.
- Replays, spectators, other sign-in providers (Google, Apple), a global leaderboard.
- Physical phones: layouts were checked at emulated sizes only.

## 1. What exists now

The game is a client-side canvas match. `PitchKickGame` in `src/client/game/engine.ts` owns the loop, physics, input, CPU, and match rules. React (`src/client/pages/HomePage.tsx`) draws the menus and the HUD. Nothing about a match is saved. Closing the tab ends it.

The only local persistence is key bindings in `localStorage` (`src/client/game/keybindings.ts`). The keyboard can be remapped today. A controller and on-screen touch buttons are planned. They will drive the same eleven actions.

### Match flow and modes

- Intro screen with Play Match and Practice. It does not look like a game front, and it will be replaced. Rematch restarts the same teams. Menu returns to the intro. A settings modal pauses the local loop and rebinds keys.
- Team picker, one side at a time. It opens on the live or next World Cup 2026 group-stage fixture from a static list in `src/client/game/teams/schedule.ts` (72 group games). Knockout rounds are not in that list.
- **Match:** 11v11, you attack right, clock runs 0:00 to 90:00 in about three real minutes, full time freezes play, the conceding side kicks off.
- **Practice:** a few of your players plus the opponent keeper, no clock, no offside, no throw-ins or corners. Goals flash and reset. Your keeper is always auto-managed.

### Teams, ratings, controls

- 48 qualified nations, real XIs, shirt numbers, formations, home kit, change kit, goalkeeper kit.
- Pace, Shooting, Passing, Dribbling, Defending, Physicality, and overall. The six face stats change speed, shot and pass power and accuracy, dribble control, tackle reach, and shoulder duels.
- FIFA-style PC controls, fully rebindable: move, sprint, charged shot, short pass, lofted long pass, through ball, lofted through ball (modifier + through), switch player, standing tackle, slide tackle, contain, keeper rush.
- Charge on press, release to kick. First-time kicks are buffered while your pass is still travelling. Control follows your pass. Q is the only manual switch; winning the ball also snaps control to that teammate.

### Simulation already in the engine

- Real-scale pitch, broadcast camera, pseudo-3D players, crowd, hoardings, goal net that ripples on a score.
- Ball height: grounded passes, lofted balls, chips, bounces. Shots over the bar do not score.
- Assisted shooting and passing, including a check for a defender in the passing lane.
- Inertia, a dribble speed penalty, and turn rate tied to dribbling.
- Standing tackle, slide tackle, contain, and shoulder battles. Strong shots bounce off outfielders.
- Goalkeepers: angle play, rush, catch versus parry, dive, hands only inside their own box and not off a teammate's pass, hold then clear.
- Offside with a restart. Throw-ins taken by hand, goal kicks, corners, opponents pushed back to a legal distance, a short beat while the ball rolls out of view.
- CPU that carries, shoots, passes under pressure, presses, and steps up a second defender to contain.
- Goal celebration, nameplates, power bar, scoreboard.

### What the server does today

`src/server/app.ts` starts the template Node server and loads one module, `example`. That module is the project template, not a game API.

- Signup, login, logout, and session, used by `LoginPage`, `SignupPage`, `LogoutPage`, `router.tsx`, `Page.tsx`, and `autoLogin.ts`.
- One fixed demo account, created by `src/server/migrations/createDemoUser.ts`.
- One store, `exampleItems` (title, created date, owner). List, read, create, rename. Pages: `/example/:itemId` and `/example/private`.
- A daily cron whose body is empty.
- Frame-ancestor allowlist so the hosting studio, localhost, and Expo preview can embed the app.

The home page and the engine never call it. There is no match table, no ratings record, and no socket.

An Expo app under `mobile/` is a sign-in shell. It does not run the game.

### Controls on keyboard, controller, and phone

When the controller and touch paths exist, the engine still will not care which device was used. It only sees the eleven actions in `GameAction`: four directions, sprint, shot, short pass, long pass, through pass, switch player, and contain. A keyboard key, a controller button, and an on-screen button are three ways to turn the same action on.

Settings gets three tabs. The player uses whichever devices are connected. They can be mixed: a controller for movement and the keyboard for a pass. Nothing is sent to the server. Each device's map is stored on that browser.

- **Keyboard.** Already built. Click an action, press a key, and it is saved. Two actions cannot share a key.
- **Controller.** The browser Gamepad API, so an Xbox, PlayStation, or other standard pad works with no plugin. The left stick moves. The face buttons, shoulders, and triggers start on a FIFA-style pad layout and can be rebound the same way as keys: pick an action, press the button. A stick is only for movement, not for shot or pass.
- **Phone.** A thumb stick and buttons drawn over the pitch when the screen is touch-sized, or when the player chooses Touch in settings. The same actions, in a default layout, and the player can swap which button does which action. Dragging a button to a new corner is enough customisation. A Bluetooth pad on a phone is the controller path, not a third scheme.

The bottom legend shows the device they used last, so a phone does not list keyboard letters.

### Home screen

The current intro is a plain mode menu. Replace it with a game front: a title treatment, then World Cup (play alone from the draw to the final), Play with a friend, and Practice. Team select sits behind World Cup and behind a friend room. New screenshots and a new demo video come after this, not from the current intro.

### Football rules still missing locally

These are match features, independent of accounts:

- Fouls, free kicks, and penalties. Restarts today are throw-in, goal kick, corner, and offside only.
- A defensive wall and a proper set-piece routine.
- Difficulty settings for the CPU.
- Match stats that survive the session (possession, shots, saves, scorers). The HUD computes some of this every frame and then drops it.
- A solo World Cup. The schedule file is the 72 group games only. Knockout rounds are not stored yet.

## 2. Target shape

Two browsers and one database. No match server.

```
Browser A (sim host)                     Browser B (guest)
  Runs engine.ts as the referee            Sends inputs over WebRTC
  Sends snapshots over WebRTC              Renders those snapshots, mirrored
        \                                  /
         \                                /
          Serverpod (Dart + Postgres)
            login, friends, rooms
            exchanges the WebRTC handshake
            stores the result if both peers agree
```

During a direct match the ball never passes through Serverpod. Serverpod is used before kickoff (who is playing, which nation) and after the whistle (the score). The only exception is the fallback in the next section: if the direct channel never opens, that one match's inputs and snapshots travel over a WebSocket on Serverpod.

The sim host is the tab that runs physics. That is not the same job as the home nation on the scoreboard. The room creator is the sim host for the first match. Rematch flips it. Either nation can be placed on the left of the scoreline. On the pitch, each human attacks the goal in front of them: the sim host's player attacks right, and the guest's picture and stick are mirrored so they attack the other goal. Both clients agree which nation is home before kickoff, and the saved score uses that, not "whoever hosted the tab."

One side is the host. That tab runs the same engine a local match runs today. The other side does not run a second simulation. Two copies would disagree within a second: the loop uses `requestAnimationFrame` timing, and kicks call `Math.random()`. The guest sends buttons. The host decides possession, goals, and offside, and streams a snapshot back.

`localStorage` stays what it is: key bindings on that machine. It is not shared with the other player and cannot sync a match. The picture stays the canvas 2D renderer in `render.ts`. WebGL is not required for peer-to-peer and is not part of this plan.

### What PeerJS is for

PeerJS is a small library over WebRTC data channels. It is a fit for the live match. The public PeerJS cloud (`0.peerjs.com`) is not a fit for a deployed game: it is a free broker we do not control, and it can drop or rate-limit the handshake.

Use `RTCPeerConnection` in the browser, or PeerJS pointed at no cloud of ours. Serverpod is the only server we run. It is the signaling server: the host posts an offer, the guest posts an answer, both post ICE candidates, on the match row.

Most home connections open the data channel directly. A public STUN server (for example Google's) is only asked "what is my address?" and we do not host it. When a pair cannot connect directly, the fallback is a relay on Serverpod itself: the same snapshots and inputs go over a WebSocket on the Serverpod app instead of peer-to-peer. That path is laggier. It exists so a blocked network still gets a match, and so we do not operate a second machine. There is no coturn box and no match process. Before that fallback is treated as ready, confirm the deployed Serverpod app will keep one WebSocket open for a whole match (about three real minutes, longer if the tab stays open). Snapshots on that socket are the exception to "the ball stays off Serverpod." The direct path never uses it.

The handshake itself is a burst of small messages (offer, answer, then several network candidates). Writing them onto a row and polling every few seconds will miss the window. While the channel is opening, both browsers poll the signal route about five times a second, or share one short WebSocket used only for those messages. Polling stops when the data channel opens. Candidates are applied in the order they were created.

### Rules

- The host's engine is the referee for that match. The guest does not simulate the ball.
- Both browsers submit the same result hash to Serverpod. The hash is the score, which side won (or a draw), and how it ended (full time, extra time, penalties, forfeit). Scorers and minutes are stored beside it and are allowed to differ. Matching hashes are stored. A mismatch voids the match.
- The guest checks the snapshot as it arrives: a player faster than the pace cap, or a ball that teleports, is a reason to refuse to sign. This catches a clumsy cheat. It does not stop two friends who agree to lie. That is acceptable. This version is friend matches, not a ranked ladder.
- Practice never opens a data channel and never writes a result.
- If the sim host closes the tab, the match ends. There is no process left to keep the game alive. Each side signs what they believe happened. If those signatures disagree, including a forfeit one side never saw, the match is void. A disconnect does not by itself award a win.
- The template server is removed once Serverpod answers auth. Two backends must not both store users.

## 3. What a deployed online game still needs

### Accounts and trust

- Sign-in required to start a World Cup or to play a friend. Guest play remains for practice and for a one-off CPU match, and those are not saved.
- Email and password first. Google (and the other Serverpod providers) can follow.
- Unique public display name, separate from the email.
- Email verification, password reset, logout everywhere, account deletion. Password reset needs a mail sender configured on Serverpod. Without it, reset is a dead button.
- Deleting an account removes the login and the display name. Friend matches already stored stay. The other player still sees the score, with that name shown as removed.
- Terms acceptance stored with a timestamp.
- Ban and suspension stored in Postgres. A local flag does nothing.
- Report a player from the full-time screen, with the match id attached.
- Block list so those two users are not paired again.
- Rate limits on signup, room creation, and chat.
- Profanity filter and mute on chat.

### Records that have to outlive the tab

- Profile: display name, region, favourite nation, created date, ban state.
- Match: id, mode (`tournament` or `friend`), status (lobby, live, finished, abandoned, void), both user ids when it is a friend match, host user id, both nations, home score, away score, winner user id, loser user id (both empty on a draw), started and ended time, end reason, and for a friend match whether the ball went direct or through the Serverpod relay. The WebRTC offer, answer, and ICE candidates live on this row only until the channel opens, then they are cleared.
- Match events: goals with the scorer and the minute. Assists are not stored until the engine tracks one. Cards come with fouls, which are later. A final stat line (possession, shots, shots on target, passes, saves) is stored only after the engine counts those on purpose. The HUD does not do that today.
- Career, with no skill rating: friend wins, draws, and losses, plus each finished World Cup (champion, or the round they went out). A friend match is stored only when both players sign the same score, and that row is what both profiles show.
- Lobby: room code, host, ready flags, selected nations, invited friend.
- Friends, blocks, and a short chat log for the lobby (match quick-chat is not stored).
- Optional replay: a compact input log in file storage, not a video file.
- Live-ops config: maintenance flag, enabled nations, featured fixture, and the minimum client version. Physics numbers stay in `constants.ts`. The server does not override them. The lobby checksum is the physics.
- Audit log for bans, voids, and renames.

### Realtime match

- The host tab runs `engine.ts`. The guest sends buttons and aim, not positions.
- The host sends snapshots (players, ball including height, possession, phase) around 20–30 Hz over the WebRTC data channel. The guest renders them. The guest may predict their own player, then correct to the host's snapshot.
- The sim host's clock is the match clock. Opening settings on either side is a local overlay. It does not pause the other player.
- The sim host's tab has to stay in the foreground. If the browser hides it, show a warning that the match will stutter for both players. Switching back does not rewind the score.
- If the data channel drops, show a short grace period. If it does not return, the remaining peer submits a forfeit. Reconnect means a new handshake on the same match id, only if the host tab is still open.
- Human goalkeepers and restart takers. The player whose restart it is has a timeout; if they do not take it, the host applies the default (short throw, keeper clear).
- Both clients must be the same build. Serverpod stores a client version on the lobby and refuses a mismatched join.

### Playing a friend

This is the online mode. There is no public queue and no ranked ladder.

- Display names are unique, compared without regard to case. Add a friend by that exact name. Accept or decline. Remove a friend.
- From the friend list, invite them to a room. They get the invite when they next open the app, and live if the lobby row is polled while they are on the screen.
- A room code still works, so you can play someone who is not on the list yet. Adding them as a friend is optional.
- Both pick a nation, ready up, side swap, rematch. Nations lock at kickoff.
- A friend match lasts 90 minutes and can end as a draw. It does not go to extra time.
- The two nations must be different.
- A room code expires after a few hours of inactivity, and when the match ends.
- If either tab closes, the other waits out a short grace period and then signs a forfeit. The stored result still needs both signatures to match. If the player who left never signs, the match stays unfinished until a timeout, then becomes void rather than a win for whoever happened to still be connected.
- Recent matches and the head-to-head record against that friend: wins, draws, losses, and the score of each meeting. A draw is stored as a draw, not as a win for either side. A forfeit that both sides signed is a loss for the player who left and a win for the one who stayed.
- The game front, while you are logged in, asks for pending invites every few seconds. An invite is not only visible from inside a lobby.

### Chat and the relay

- Lobby chat is stored on the room in Postgres, so a friend who joins a few seconds later still sees it. Short messages, rate limited.
- During the match, quick chat goes over the same channel as the inputs (direct or relay). It is not written to the database.
- Mute and block. A blocked user cannot invite you or join your room.
- Direct WebRTC first. If it is not open within a few seconds, both browsers fall back to a WebSocket on Serverpod and the match continues. The players are not asked to retry. One server, no second process.

### Solo World Cup

You play alone, as one nation, from the group draw through to the final. The CPU is the other side of every match you play. Signing in is required, because the run has to be there after the tab closes.

- The groups are the real draw already in `schedule.ts`: 12 groups of four, and your nation plays its three group games, one matchday at a time. After you finish a matchday, the server simulates only the other games on that same matchday. It does not play out matchday two or three early, so the table cannot tell you that you are already through.
- The favourite in a simulated game is the side with the higher average overall of its starting eleven, with a small chance of an upset, and the score is a plausible one (a stronger side wins by more). Those results are stored, so the table is the same if you reload.
- Group order is points, then head-to-head, then goal difference, then goals scored. The top two in each group and the eight best third-placed teams go through. That is the 2026 format: 32 teams.
- The knockout bracket uses the official 2026 slot table: which group winner plays which runner-up or third-placed team, and that third-placed slot changes with which groups those eight teams came from. Round of 32, round of 16, quarter-final, semi-final, final. There is no third-place playoff in this version. You only play your nation's tie. The other ties in that round are simulated when your tie ends, then the winners move on.
- On screen you always attack right, even when your nation is the away side in the real fixture. The saved score uses the fixture's home and away nations, so the goals land on the correct row of the table.
- A group game can finish as a draw. A knockout that is level after 90 minutes cannot. Extra time and penalties are a new mode in the engine, not a column on the fixture: 30 minutes of extra time on the same clock scale, then five penalties each, sudden death after that. The group stage can ship before that mode exists. Knockouts wait for it.
- Cards and suspensions are not part of this campaign. Fouls come later. A player is never banned for the next match in the first version.
- If you leave before the whistle, nothing is saved. That fixture is still unplayed and starts again at 0–0. Closing the tab after a saved result resumes at the next unplayed match, not back at the draw.
- If you miss the knockout cut, or you lose a knockout, the run ends and the profile records the round. If you win the final, it records you as champion. You can start another World Cup with the same or another nation. One run is in progress at a time.
- The result of a match you played is whatever the full-time whistle on your machine produced. This is your own campaign, not a ranking against other people, so it does not need a second signature. The post carries a nonce for that fixture. Sending it twice updates the same row. If the post fails, the client keeps the result and retries. A whistle without a saved row is not a finished match.

### Anti-cheat

This architecture does not have a neutral referee. Be explicit about that.

- The guest rejects a snapshot that breaks the pace cap or jumps the ball, and then refuses to sign.
- Serverpod stores a result only when both signatures match. One player cannot post 10–0 alone.
- Two colluding clients can still sign a fake score. A modified host can still lie in ways a shallow snapshot check will miss.
- Friend matches accept that. A ranked ladder is out of scope.
- Squad ratings stay the copy compiled into that client build. The host must not accept a ratings blob from the guest.

### Around the match

- Full-time screen that reads the saved stat line, with rematch and report.
- The invite itself is the notification that matters. A friend-online presence light can follow.
- Admin: ban, void a match, toggle maintenance, see live match count.
- Privacy policy and account deletion, because personal data will exist.
- Nothing to deploy beside Serverpod. Direct matches keep running if Serverpod restarts after the channel is open. A match that had fallen back to the Serverpod relay drops if Serverpod restarts, and the forfeit path applies.
- Backups of Postgres.

### Explicitly later

- A store app. `mobile/` does not run the canvas game. Touch controls on the website are in the build, below. They are not a second app.
- Spectators and shareable replay links.
- Custom clubs. Nations stay the identity.
- Voice chat.
- Ranked play, seasons, divisions, and a public matchmaking queue.

## 4. Making Serverpod the backend

Serverpod 4 (Dart, Postgres, Relic web server). The React app talks to Relic routes that return JSON. It does not use the generated Flutter client. Lobby updates poll the room row. Do not reimplement Serverpod's private stream protocol in TypeScript. Do not send match snapshots through Serverpod except on the relay fallback, and do not send them through Postgres.

The first thing to prove is sign-in. A Relic route must call Serverpod's own email-and-password auth, and the browser must come back with a session that survives a refresh. If that call is awkward, fix it before any tournament or lobby table. Passwords never go anywhere except that auth module.

Flutter is already installed at `C:\src\flutter` (3.47.5) and `C:\src\flutter\bin` is on the system PATH. Cursor has to be restarted before this environment sees the `flutter` command. The Serverpod CLI is installed and will not run until that `flutter` command resolves.

### New project

Create a Serverpod project beside this repo, or in `serverpod/` at the root. It is a separate Dart package. Do not put it inside `src/server`.

Local dev uses Serverpod's embedded Postgres. Production uses Serverpod Cloud's Postgres, or another managed Postgres. Do not point production at the embedded database.

Suggested layout:

```
serverpod/                 Dart server, YAML models, migrations
  lib/src/web/             Relic routes the React app calls, including WebRTC signaling
src/client/                existing React game, auth rewritten, PeerJS data channel
```

No `match-server/` package. The host tab is the match server.

The React client keeps its own dev server (Vite). Serverpod does not have to serve the canvas bundle. In production, static files can be a CDN or Serverpod `SpaRoute`. Either is fine. The API origin and the page origin need CORS and cookie settings chosen on purpose (Authorization header is simpler than cross-site cookies).

### Data model (Postgres, Serverpod YAML)

| Model | Holds |
|---|---|
| `UserProfile` | Serverpod auth user id, display name, region, favourite nation, created at, banned until, terms accepted at |
| `Match` | mode (`tournament` or `friend`), status, home user, away user, host user, home nation id, away nation id, home score, away score, winner user id, loser user id, result hash, tournament id, round, started at, ended at, end reason (full time, forfeit, abandon, void) |
| `Tournament` | user id, nation id, status (group, round of 32, round of 16, quarter, semi, final, champion, eliminated), eliminated in round, created at, finished at |
| `TournamentFixture` | tournament id, round, home nation, away nation, home score, away score, played by user or simulated, winner nation, match id when the user played it |
| `MatchSignal` | match id, from user, kind (offer, answer, ice), payload, created at. Deleted when the channel opens or the match ends |
| `MatchEvent` | match id, minute, type, player name, side |
| `MatchStats` | match id, per side possession, shots, shots on target, passes, saves |
| `Lobby` | code, host user, status, match id once live |
| `LobbySeat` | lobby id, user id, side, nation id, ready |
| `LobbyMessage` | lobby id, user id, text, created at |
| `Friendship` | user id, other user id, status (pending, accepted) |
| `Block` | user id, blocked user id |
| `Report` | reporter, target, match id, reason, created at, resolved at |
| `LiveOps` | single row: maintenance, min client version, message |
| `AuditLog` | actor, action, target, created at |

Nation ids are the existing file keys (`argentina`, `brazil`, …), not a copy of every player. Squads stay in the client bundle. The server stores the nation id and checks it is one of the 48. The host loads ratings from that bundle. The guest's ratings are not accepted as input.

Indexes: match by user and by status, lobby by code, friendship by user.

### HTTP API the React app calls

All routes sit on the Relic server, session-checked against Serverpod auth. Passwords never go anywhere except Serverpod's auth module.

- `POST /api/auth/register`, `POST /api/auth/login`, `POST /api/auth/logout`, `POST /api/auth/password-reset`
- `GET /api/me`, `PATCH /api/me` (display name, region, favourite nation)
- `GET /api/me/matches`, `GET /api/matches/:id`, `GET /api/me/record` (friend wins, draws, losses, and World Cups finished)
- `POST /api/tournaments`, `GET /api/tournaments/current`, `POST /api/tournaments/:id/result` with a fixture nonce (the match you just played; the server then simulates the other games on that same matchday only)
- `POST /api/lobbies`, `POST /api/lobbies/join`, `POST /api/lobbies/:id/ready`, `POST /api/lobbies/:id/nation`, `DELETE /api/lobbies/:id`
- `GET /api/friends`, `POST /api/friends`, `POST /api/friends/:id/accept`, `DELETE /api/friends/:id`
- `POST /api/lobbies/:id/invite`, `GET /api/invites`
- `GET /api/lobbies/:id/messages`, `POST /api/lobbies/:id/messages`
- `POST /api/reports`, `POST /api/blocks`
- `GET /api/live-ops` (public: maintenance and min version)
- `POST /api/matches/:id/signal` and `GET /api/matches/:id/signal` for the WebRTC offer, answer, and ICE candidates
- `POST /api/matches/:id/result` with the result hash, from each peer

When both seats are ready, Serverpod creates a `Match` and names the room creator as the sim host. Both browsers run the handshake through the signal routes. The data channel then carries the match. Each peer posts the result once. The handler stores the score only when the two hashes match, and is safe to call twice. A timeout with only one signature stores nothing.

### Client files that stop using the template server

| File | Change |
|---|---|
| `src/server/**` | Delete once Serverpod is serving auth. Includes `app.ts`, `example/`, `migrations/createDemoUser.ts` |
| the template server config file | Remove with the server |
| `package.json` | Drop the template server packages when nothing imports them. Vite remains the client build |
| `src/client/index.tsx` | Replace the template `renderApp` with a normal React root. Keep the router, React Query, and toast |
| `src/client/lib/autoLogin.ts` | Remove sandbox demo auto-login |
| `src/client/router.tsx` | Session comes from Serverpod (`GET /api/me`), not the template `useSession`. Guest routes and private routes stay, aimed at the new session |
| `src/client/pages/LoginPage.tsx` | Call `POST /api/auth/login`. Remove demo credential prefill |
| `src/client/pages/SignupPage.tsx` | Call register. Collect display name and terms |
| `src/client/pages/LogoutPage.tsx` | Call logout |
| `src/client/pages/ExamplePage.tsx` | Remove |
| `src/client/pages/PrivateExamplePage.tsx` | Remove |
| `src/client/components/Page.tsx` | Header session from the new auth client |
| `mobile/` | Leave unused, or point its sign-in at Serverpod later. It is not part of the web launch |

New client modules:

- `src/client/api/session.ts` — token storage, `me`, login, logout.
- `src/client/api/lobby.ts` — rooms, invites, and friends.
- `src/client/net/peerMatch.ts` — WebRTC data channel. Host sends snapshots, guest sends inputs. Signaling goes through Serverpod, not through the PeerJS public cloud.

### Home page flow

`HomePage.tsx` phases today are `intro | select | playing`.

Online adds:

`intro` → World Cup, play with a friend, or practice.

- World Cup and practice keep a single local engine. Practice does not open a socket and does not save. World Cup saves after each whistle. There is no separate unsaved exhibition match on the front.
- Play with a friend requires a session. Otherwise the button goes to login.
- The lobby is the friend screen: room code, both nations, ready. The game front polls invites while you are logged in.
- `playing` online mounts the same canvas, but the engine is constructed in net mode (section 5), and settings do not call `setPaused(true)` on a shared match. The guest's view is mirrored.

## 5. Peer match

The host tab runs the engine. The guest tab is a renderer with a controller attached. They talk on a WebRTC data channel.

### Engine work before the channel exists

The engine reads `window` key events and draws through `render.ts`. Online play needs a cut between those.

- **Input as data.** A `ControlState` (move axes, sprint, charge, kick released this frame, tackle, slide, contain, switch, keeper rush). The local player is filled from `keybindings.ts`. The remote player is filled from the data channel.
- **Snapshot out, snapshot in.** The host builds a snapshot each send: players, ball (`x, y, z, vx, vy, vz`), owner id, phase, score, clock, message, restart kind. Stable ids are team + squad index. The guest's `render.ts` draws that snapshot instead of its own world.
- **The guest does not step physics.** Running `engine.ts` on both sides looks simpler and desyncs immediately, because frame time differs and `kickNoise()` uses `Math.random()`.
- **Both sides human.** On the sim host, the remote seat uses the guest's `ControlState` through the same path as the controlled player, with movement flipped so they attack the far goal. `updateAwayTeam` stays for CPU matches only, including every World Cup match.
- **Pause.** `setPaused` remains for local and practice. A peer match ignores it.
- **Same build.** Lobby join compares a checksum of `constants.ts`. A mismatch is refused before the offer is created.

### On the wire

Guest → host, about 20 Hz, and immediately on a button edge (shot release, tackle):

```
{ type: "input", tick, control: ControlState }
```

Host → guest, about 20–30 Hz. Snapshot packets are unordered and may be dropped. Input packets are reliable, so a shot release is not lost behind a stale position.

```
{ type: "snapshot", tick, state: Snapshot }
{ type: "event", name, payload }   // goal, restart, fulltime
```

Signaling (offer, answer, ICE) is JSON posted to Serverpod. It is not on this channel, because the channel does not exist yet.

At full time or forfeit, each peer hashes the score, which side won, and the end reason, and posts it. Serverpod writes the row when the hashes match.

### Feel across latency

- The guest interpolates the host's last snapshots.
- The guest may predict their own player from the buttons they are holding, then ease onto the host snapshot. Possession changes snap.
- Charge and the first-time buffer stay on the host. The host sees the guest's press and release. A late release still fires if that player can still kick; otherwise it is dropped and the guest's prediction rewinds.
- A slide starts on the guest immediately and rewinds if the next snapshot says it did not.

Play a full half across two machines on the same LAN before calling it done. Then try two different home networks, including a pair that only connects through the Serverpod relay.

### When the host leaves

There is no standby process. The player still connected waits out the grace period, then signs a forfeit. If the other signature never arrives, or it names a different winner, the match is void. A network drop that kills both the direct channel and the relay uses the same path.

## 6. Build order

Each phase is shippable. Friend play is the online goal. Do not start invites and chat before two browsers can finish a match and save the score.

### Phase 0 — tooling

- Restart the environment so `flutter` and `serverpod version` run.
- Create the Serverpod app, embedded Postgres locally, first empty deploy to the existing Serverpod account.
- React app still talks to nothing. Local CPU game still works.

### Phase 1 — game front, then auth

- Replace the template dev command with the Vite dev server and a normal React root in the same step that sign-in moves to Serverpod. Do not delete the template server first and leave the game unable to start.
- Prove email-and-password through a Relic route before building tables.
- Replace the intro with a game front: World Cup, Play with a friend, and Practice. World Cup and Play with a friend lead to login until accounts exist. The front polls invites once login exists.
- `UserProfile` on first login. Display name, unique. Terms timestamp.
- Delete the example module, demo user migration, and template session usage.
- Practice stays playable logged out.

### Phase 2 — your World Cup

- `Tournament`, `TournamentFixture`, and `Match` for mode `tournament`.
- Pick a nation, play its three group games against the CPU one matchday at a time, and see the saved table. Other games on that matchday are simulated only after yours. A draw is a legal result. Reload resumes the next unplayed fixture. Leaving mid-match does not save a partial score.
- The result post is idempotent. A failed post retries.
- Extra time, penalties, and the official knockout slot table come in the same phase only after a group can be finished. Until then the run stops at the group table.
- A friend match still needs both signatures. The tournament result comes from the one browser that played it.

### Phase 3 — host and guest inside one browser tab pair

- Extract `ControlState` and `Snapshot` without changing local feel.
- Local match and practice keep running the engine and the renderer together. That is the regression gate.
- The guest path can render a snapshot with an empty input. Still no network.

### Phase 4 — play a friend

- Lobby tables, room code, signal routes, and the Serverpod relay fallback.
- WebRTC when it connects. The relay when it does not. Host runs the engine. Guest sends inputs and draws snapshots.
- Full time stores the match only when both result hashes match. The row names the winner and the loser, or a draw, and both profiles show that record.
- Disconnect grace and forfeit.
- Settings overlay does not pause the shared match.
- Rematch in a fresh lobby, same nations, host flipped.
- Play a full half on a LAN, then across two home networks, including one relayed match.

### Phase 5 — friends, chat, invites

- Friend request, accept, remove, block.
- Invite a friend into your room. Room code remains for anyone else.
- Lobby chat stored on the room. Quick chat on the match channel, not stored.
- Recent matches and head-to-head against that friend.
- Reports, account deletion, maintenance flag. Maintenance blocks new rooms and still allows login. It does not cut a channel that is already open.

### Phase 6 — keyboard, controller, and touch

- Controller through the Gamepad API, with the same eleven actions and the same rebinding screen.
- On-screen stick and buttons when the screen is touch-sized or the player chooses Touch. Swapping which button does which action is enough.
- The legend follows the device last used.
- This is the website, not the Expo app.

### Phase 7 — football completeness

Can run in parallel with phases 4 and 5. The sim host's tab runs this same engine, so a rule added locally is the rule online. Cards do not suspend anyone in the World Cup save. That campaign already shipped without bookings.

- Fouls, free kicks, penalties, wall.
- Persisted stat line filled in properly (possession sampled by the sim, not the HUD).
- CPU difficulty for local and practice only.

### Phase 8 — later

- Replays in Serverpod file storage.
- Spectators on a read-only socket.
- Extra auth providers (Google, Apple).
- A Flutter client, if wanted, can then call generated endpoints. The React routes stay.
- Ranked play and seasons, only if a real player base exists. Not part of this build.

## 7. What we will not do

- Run the 30 Hz pitch on Serverpod streams.
- Hand-write Serverpod's Flutter WebSocket protocol in TypeScript.
- Keep the template server storing users after Serverpod auth is live.
- Trust one browser for a friend-match score. Both peers sign, or that match is void. A solo World Cup result is the player's own saved run.
- Use the public PeerJS cloud as the broker.
- Sync the match through `localStorage`, or rewrite the renderer in WebGL for networking's sake.
- Build ranked play, seasons, or a public queue.
- Block friend play on a mobile port.

## 8. How to know it is working

- Logged out: practice and a one-off CPU match play, and nothing is saved.
- Logged in: start a World Cup, finish one group game, reload, and only that matchday's other games have been filled in. The next matchday is still unplayed. Leave mid-match, come back, and that fixture is 0–0 again. Finish the run and the profile says champion or the round you went out.
- A friend match that is level at 90 minutes is stored as a draw. A knockout that is level goes to extra time.
- Logged in: signup, login, display name, logout, and the session survives a refresh.
- Two browsers, one room code: both pick a nation, ready, kick off, score, see the same score, finish, and both match histories show that game.
- Killing one tab: the other sees a grace period. If only one side signs, the match is void and nobody is given the win.
- One peer posting a different score: the match is void and is not added to either friend's record.
- The guest's team attacks the goal opposite the sim host's team. The saved home and away nations match what both players picked, not which tab ran the physics.
- A client build with a different constants checksum is refused before the offer.
- Two browsers that cannot open WebRTC still finish a match through the Serverpod relay.
- You can add a friend, invite them, chat in the lobby, play, and both profiles show who won and who lost, including after a reload.
- Maintenance on: login works, new rooms do not start, and an open channel keeps playing.
- Restarting the Serverpod app does not erase finished matches and does not stop a channel that has already connected.

## 9. Why the live match still stays out of Serverpod

Peer-to-peer removes the match process. It does not move the tick into Serverpod.

Serverpod remains the right place for accounts, friends, rooms, chat history, signaling, the relay fallback, and the stored result. The pitch stays in the sim host's browser because:

- Serverpod streams yield an object when an event happens, for a Dart client. This game needs a snapshot every few dozen milliseconds in a TypeScript page.
- A handshake is a handful of JSON posts. A match is thousands of snapshots. Sending those through Postgres or a Serverpod stream would put the ball on a round trip to the server, which is the latency peer-to-peer exists to avoid.
- `localStorage` and the canvas renderer are already doing their jobs. Storage is per browser. The renderer draws whatever world it is given. Neither one connects two players.

The host tab is the referee. Serverpod introduces the two browsers, then writes down the result they both sign.
