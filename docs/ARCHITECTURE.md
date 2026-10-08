# Architecture

Dream League Football has three parts: a **React web app** that contains the whole game, a **Serverpod server** that remembers things and introduces players, and a **real-time link** between two browsers for online matches.

```
┌────────────────────────── Browser ───────────────────────────┐        ┌──────────── Serverpod (Dart) ────────────┐
│ React 19 app (Vite, Tailwind v4, React Query)                 │  JSON  │ Endpoints  profile tournament lobby       │
│  ├─ screens / ui   menus, navigation, dialogs, HUD            │◄──────►│            friendMatch friends chat ...   │
│  ├─ api/           fetch client + token refresh               │ HTTPS  │ Auth       email IdP + JWT                │
│  ├─ game/          PitchKickGame engine + canvas renderer     │        │ ORM        15 game tables, migrations     │
│  └─ net/           WebRTC / relay link, live socket           │        │ Web server SPA, /relay, /live, /r/<id>    │
└───────────────────────────────▲───────────────────────────────┘        │ Future calls, cloud storage, Elo, duels   │
                                │ WebRTC data channel (or relay)          │ Hosted on Serverpod Cloud                 │
                                ▼                                         └──────────────────────────────────────────┘
                         the other player's browser
```

Everything about the server is in [SERVERPOD.md](SERVERPOD.md); the online match protocol is in [MULTIPLAYER.md](MULTIPLAYER.md); this document describes the code in the repository and how data flows through it.

## Repository map

| Path | What is there |
| --- | --- |
| `src/client/index.tsx`, `router.tsx` | Entry point and routes (providers: React Query, session, settings, hints, dialogs, notifications) |
| `src/client/screens/` | One file per routed screen: `HomeScreen`, `AuthScreens` (login, sign-up, reset, welcome), `WorldCupScreen`, `OnlineScreen` (hub and lobby), `PracticeScreen`, `ProfileScreen`, `SettingsScreen`, `LegalScreens`, `MatchScreen` |
| `src/client/screens/match/` | `LocalMatch` (practice, friendly, World Cup, shootout), `FriendMatchStage` (online match), `DuelStage` (the server-refereed penalty duel), `shared.tsx` (stage, pause menu, intro card, result panel), `usePause` |
| `src/client/ui/` | The design system: `AppShell`, `MenuNav` (spatial navigation), `Dialog`, `controls`, `hints`, `Notifications`, `MatchHud`, `SettingsPanels`, `sfx`, `Flag`, `art` |
| `src/client/api/` | `http.ts` (transport), `session.ts`, `tournament.ts`, `friend.ts`, `duel.ts` (matchmaking, duel, daily challenge, sharing), `social.ts`, `rankings.ts`, `queries.ts` |
| `src/client/game/` | The engine and everything it needs (below) |
| `src/client/net/peerMatch.ts` | The `Link` between two browsers: WebRTC first, relay fallback |
| `src/client/net/live.ts` | The `/live` push socket: one connection, `useLive(topics, handler)` |
| `src/client/components/game/` | `TouchControls`, `TeamCrest` (kit jersey), `ShootoutHud` |
| `football/football_server/` | The Serverpod server |
| `scripts/` | Test scripts, `export-server-data.mjs`, `build-web.mjs` |

## The client

### Routing and session

`router.tsx` wraps routes in a root layout with all providers. Menu screens live inside `AppShell` (header, tabs, footer prompts). Guest-only routes (`/login`, `/signup`, `/reset-password`) and private routes (`/welcome`, `/world-cup`, `/online`, `/profile`) are guarded by the session state, which has four values from `session.ts`: `loading`, `out`, `needsProfile` (signed in, no display name yet) and `in`. `/match` is outside the shell: the pitch takes the whole viewport. `matchContext.tsx` carries *what* to play (practice, World Cup fixture, friend match) from the menu to the match screen and back (`start`, `end`).

### Server state

TanStack Query holds server data (`useRun`, `useRecord`, `useHistory`, `useLeaderboard`, `useDailyChallenge`, the friends list). `Notifications.tsx` runs the one global friends refetch (on a `friends` push from the server, plus a 20 s poll that doubles as the presence heartbeat; 6 s if the live socket is down), shows invite and friend-request toasts and the bell. Rooms, chat, the matchmaking queue and duels refetch on pushes from the live socket too, with a slow poll as the safety net.

### Settings

`ui/settings.tsx` stores key bindings, controller bindings, touch layout, CPU difficulty, match length, goal replays, commentary and sound in `localStorage` (`wc2026.keybindings`, `wc2026.padbindings`, `wc2026.touch`, `wc2026.difficulty`, `wc2026.matchSecs`, `wc2026.replays`, `wc2026.commentary`, `wc2026.sound`) and copies them to the account (`api/settingsSync.ts`). The `wc2026.*` prefix is historical and kept so players do not lose their settings or sign-in.

## The game engine (`src/client/game/`)

`engine.ts` holds the stateful `PitchKickGame` class (loop, physics, input, AI, possession, rules). Pure modules around it:

| File | Responsibility |
| --- | --- |
| `constants.ts` | All scale, geometry, physics and gameplay tunables. The pitch is real size (105 m × 68 m, `PX_PER_M`); `M(metres)` converts |
| `math.ts` | `len`, `dist`, `clamp`, `shade`, `distToSegment` |
| `types.ts` | `PlayerEntity`, `HudState`, `MatchStats`, ... |
| `entities.ts` | Builds player entities from a squad |
| `projection.ts` | The broadcast camera: `proj(x, y)`, zoom, camera clamps |
| `render.ts` | Pure canvas renderer: sky, crowd, pitch, goals with nets, depth-sorted players and ball |
| `ratings.ts` | Turns the six FIFA-style ratings into movement, shot, pass, dribble and tackle multipliers |
| `keybindings.ts`, `inputDevices.ts`, `useDeviceInput.ts` | Keyboard, controller and touch input; the last device used |
| `snapshot.ts`, `guestView.ts` | The online wire format and the guest's renderer ([MULTIPLAYER.md](MULTIPLAYER.md)) |
| `shootout.ts` | `PenaltyShootout`: the shootout game (World Cup knockouts, friendlies, and the standalone mode) |
| `teams/` | The 48 nations (squads, kits, ratings), formations, and the real group draw and fixtures (`schedule.ts`) |

### How a frame works

1. `requestAnimationFrame` calls the loop; elapsed time is clamped to 50 ms.
2. Input (keyboard events, pad polling, touch buttons) is turned into **canonical key codes**. Rebinding only changes the mapping from physical key to canonical code, so the game logic never sees custom keys.
3. `update(dt)` runs the controlled player, the CPU (off-ball positioning, marking, pressing, set pieces), possession, ball physics (with height), the keepers' reactions, rules (out of play, offside, fouls and cards, goals) and the clock.
4. The engine builds a `Scene` (camera, ball, players with kits, markers) and calls `renderScene`.
5. A `HudState` is pushed to React (score, clock, message, charge, names, stats, replay flag, added time) so the HUD is ordinary React, not canvas.
6. Local matches also get an event stream (`onEvent`: goal, save, shot, foul, card, offside, restarts, half time, added time, full time) that feeds the commentary captions (`ui/Commentary.tsx`) and the synthesised crowd (`ui/crowd.ts`). With replays on, the engine keeps the last four seconds as light frames (copies of the players, at 30 a second) and plays them back after the goal celebration; online matches do not use replays.

The world is **flat 2D** (x = goal to goal, y = touchline to touchline). Only rendering is pseudo-3D: `proj` maps the field onto a tilted TV view with perspective scale, a zoom that crops the pitch like a tele camera, and a camera that follows the ball in both axes.

### Teams and data

Each nation is one small file in `game/teams/` with name, formation, kits (home, away, goalkeeper), and 11 players (shirt number, surname, position, six ratings). Rosters were transcribed from the official 2026 World Cup squad lists. `schedule.ts` contains the real group draw (12 groups of 4) and the 72 group fixtures. `npm run export:data` generates `football_server/lib/src/data/world_cup_data.dart` from these files so the server shares the same nations, groups and fixtures.

## Data flow examples

**Signing in.** `LoginScreen` → `session.signIn` → `emailIdp/login` → tokens stored in `localStorage` → `profile/me` → the session becomes `in` (or `needsProfile`) → the router sends the player where they were going (`_redirect`).

**Playing a World Cup match.** `WorldCupScreen` shows `tournament/current`. "Play match" → `matchContext.start({kind: 'worldcup', ...})` → `MatchScreen` → `LocalMatch` creates `PitchKickGame` with the two teams and `knockout: true` for knockout rounds. At full time (after extra time and, if level, a `PenaltyShootout`) `LocalMatch` calls `tournament/submitResult` with a fresh nonce; the server simulates the rest of the matchday or round and returns the new `TournamentView`, which replaces the cached run.

**Playing a friend.** See [MULTIPLAYER.md](MULTIPLAYER.md).

**Finding a match and a penalty duel.** `QuickMatch` → `matchmaking/join` → the server pairs two players and pushes a `queue` event over `/live` → both clients call `match.start({kind: 'duel'})` → `DuelStage` fetches `penalty/state`, each player taps a zone → `penalty/submit` → the server resolves the kick when both have chosen (or at the deadline, by a future call), pushes a `duel` event, and at the end applies Elo and returns the rating change in the `DuelView`.

## Build and hosting

Vite builds the app (`npm run build` → `dist/`). `scripts/build-web.mjs` copies it into `football/football_server/web/spa`, and the Serverpod web server serves it with a single-page fallback. Vite also injects a build id (a hash of `src/client/game/**`) that both players of an online match must share. In development Vite serves on port 5173 and calls the API on `localhost:8080`; in production the API host is derived from the page host (`<project>.serverpod.space` → `<project>.api.serverpod.space`), overridable with `VITE_API_URL` and `VITE_RELAY_URL`.

## Design decisions worth knowing

- **No generated Dart client in the web app.** Serverpod's plain JSON calls are enough, and keeping a thin hand-written TypeScript client avoids a second code generator.
- **One origin for page and relay** avoids CORS and cookie questions in production.
- **Simulation stays in TypeScript and in a browser.** See [MULTIPLAYER.md](MULTIPLAYER.md).
- **The engine is one big class on purpose.** Input, player actions, AI, possession and rules share a lot of mutable state; splitting them would need a context object and carries risk. Stateless parts (constants, math, projection, rendering, ratings) are already separate modules.
- **Internal codename.** The engine class is still `PitchKickGame`; the product is Dream League Football.
