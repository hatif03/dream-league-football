# Dream League Football

An arcade, FIFA-style football game that runs in your browser, with a **[Serverpod](https://serverpod.dev) backend** for accounts, a persistent solo World Cup, and live online matches against friends.

Play it: <https://football.serverpod.space> (web) · API: <https://football.api.serverpod.space>

![Home screen](docs/img/home.png)

| | |
| --- | --- |
| ![Match](docs/img/match.png) | ![Lobby](docs/img/lobby.png) |
| ![World Cup run](docs/img/world-cup-hub.png) | ![Online hub](docs/img/online.png) |

On a phone the same game runs in landscape with on-screen controls:

<img src="docs/img/phone-match.png" alt="Phone landscape match" width="520"> <img src="docs/img/phone-home.png" alt="Phone home screen" width="170">

## Powered by Serverpod

The whole back end is a single Serverpod 4.0.3 project (Dart + PostgreSQL) in [`football/`](football/). It is the reason the game can remember anything, and it does more than store rows:

| Serverpod feature | What Dream League Football uses it for |
| --- | --- |
| **Authentication** (`serverpod_auth_idp`, email identity provider) | Sign-up with an emailed verification code, sign-in, password reset. Codes are printed to the console in development and emailed through **Serverpod Cloud's email service** in production, branded "Dream League Football". |
| **JWT token manager** | Short-lived access tokens (10 minutes) plus refresh tokens; the React app refreshes on expiry. |
| **Endpoints** (`Endpoint` classes, `requireLogin`) | Every game call: profile, solo tournament, friend rooms, match results, friends, chat, reports, operator tools. Called from TypeScript as plain `POST /<endpoint>/<method>` JSON, so the web app does not need the generated Dart client. |
| **ORM + models** (`.spy.yaml`) | 12 tables (profiles, tournaments, fixtures, lobbies, friend matches, friendships, blocks, invites, chat, reports, audit log). Typed, generated, with transactions and **row locks** (`LockMode.forUpdate`) so two players signing a result at the same instant never overwrite each other. |
| **Migrations** | 7 versioned migrations applied at boot (`--apply-migrations`). |
| **Embedded PostgreSQL** | Local development and tests need no Docker: `database.dataPath` makes Serverpod run its own Postgres. |
| **Web server (Relic)** | Serves the built React app with a single-page fallback, and hosts the **`/relay/:matchId` WebSocket** that carries a match when two browsers cannot connect directly. One origin in production: no CORS, no cookies. |
| **Serverpod Cloud** (`scloud`) | One-command deploy of the server, the database, the web app and the email service. Secrets (such as the operator list) are set with `scloud password set`. |
| **Testing** (`serverpod_test`, `dart test`) | Unit tests for tie-breaks, the 2026 knockout bracket (all 495 third-place combinations) and the two-signature result protocol. |

Read [docs/SERVERPOD.md](docs/SERVERPOD.md) for the full tour, and [docs/API.md](docs/API.md) for every endpoint.

## What you can do

- **Solo World Cup.** Pick one of the **48 nations** of the 2026 World Cup and play the real group draw, matchday by matchday. The server simulates the other games, builds the group tables (with head-to-head tie-breaks), draws the official Round-of-32 bracket (including the third-placed-team slots), and takes you through knockouts with extra time and a penalty shootout you take yourself. Every result is saved to your account.
- **Play a friend online.** One tap creates a room; share the 5-character code, a link, the share sheet or a QR code. A friend can also be invited from your friends list. Both players see joins, leaves, nation picks and "ready" live, then a 3-2-1 count-in starts an 11v11 match. One browser runs the simulation and streams it to the other over WebRTC (with the Serverpod relay as fallback). Both players sign the final score; the result and head-to-head record are stored. Leaving a match tells your opponent immediately.
- **Practice** on an open pitch with no clock and no pressure (works signed out).
- **Friends, chat, invites, blocks and reports**, a record with head-to-head, presence dots, account deletion.
- **Real football rules.** Offside, throw-ins, corners, goal kicks, fouls with free kicks and a four-man wall, penalties, yellow and red cards, extra time, shootouts.
- **Depth.** Charged shots and passes, through balls, lofted passes, slide tackles, contain, a goalkeeper with dives and handling rules, FIFA-style player ratings (pace, shooting, passing, dribbling, defending, physicality) that change how every player actually plays, and three CPU difficulty levels.
- **Play on anything.** Keyboard, controller (Gamepad API) or touch. Every input is rebindable. The menus are console-style (arrows or D-pad, Enter/A, Esc/B) and the footer shows the buttons for the device you used last.

## Quick start

Prerequisites: Node.js 20+, and for the online features the Dart SDK with the Serverpod CLI (`dart pub global activate serverpod_cli`). No Docker needed.

```bash
npm install
npm run dev                 # the web app on http://localhost:5173 (practice works with no server)
```

With the Serverpod server (accounts, World Cup, friends):

```bash
cd football/football_server
cp config/passwords.example.yaml config/passwords.yaml    # then fill in the development secrets
dart bin/main.dart --apply-migrations --role monolith     # API :8080, web + relay :8082
```

In development the sign-up code is printed in the server console. Full instructions, including how to run the tests, are in [docs/DEVELOPMENT.md](docs/DEVELOPMENT.md).

Deploy to Serverpod Cloud:

```bash
npm run build:web                                  # builds the app into football/football_server/web/spa
cd football/football_server
scloud deploy --yes --non-interactive
```

## Default controls

| Action | Keyboard | Action | Keyboard |
| --- | --- | --- | --- |
| Move | Arrow keys | Through pass | `W` |
| Sprint | `E` | Lofted through ball | `Q` + `W` |
| Shot / standing tackle | `D` | Switch player | `Q` |
| Short pass | `S` | Contain (hold) | `C` |
| Long pass / slide tackle | `A` | | |

Hold a shot or pass to charge power, release to kick. All keys, controller buttons and touch buttons can be changed in Settings. More in [docs/GAMEPLAY.md](docs/GAMEPLAY.md).

## Tech stack

- **Back end:** Serverpod 4.0.3, Dart 3.12, PostgreSQL, Serverpod Cloud
- **Front end:** React 19, React Router 6, TanStack Query, Tailwind CSS v4, TypeScript, Vite
- **Game:** a hand-written engine on HTML5 Canvas (`requestAnimationFrame`) with a pseudo-3D TV broadcast camera
- **Real time:** WebRTC data channels, with a Serverpod WebSocket relay as fallback
- **Tests:** Playwright (real Chrome) end-to-end scripts, HTTP smoke tests, `dart test`

## Documentation

| Document | What it covers |
| --- | --- |
| [docs/SERVERPOD.md](docs/SERVERPOD.md) | How Serverpod is used: auth, endpoints, models, migrations, relay, web hosting, Cloud deploy, operations |
| [docs/API.md](docs/API.md) | Every endpoint, its arguments and rules |
| [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) | The whole system, the repo layout, the client, the engine, data flow |
| [docs/MULTIPLAYER.md](docs/MULTIPLAYER.md) | Online match design: host and guest, snapshots, WebRTC, relay, result signing, leaving |
| [docs/GAMEPLAY.md](docs/GAMEPLAY.md) | Modes, controls, rules, ratings, difficulty, the World Cup format |
| [docs/UI.md](docs/UI.md) and [UI_PLAN.md](UI_PLAN.md) | The "Matchday Night" design system, screens, navigation, mobile |
| [docs/DEVELOPMENT.md](docs/DEVELOPMENT.md) | Setup, scripts, all tests, deploying, troubleshooting |
| [PLAN.md](PLAN.md) | The original plan, the review that fixed it, and build status |
| [CHANGELOG.md](CHANGELOG.md) | What changed, by date |
| [AGENTS.md](AGENTS.md), [football/AGENTS.md](football/AGENTS.md) | Detailed engineering notes for contributors and coding agents |

## Repository layout

```
.
├── src/client/              # React app
│   ├── api/                 # fetch client for Serverpod (http, session, friend, tournament, social)
│   ├── game/                # the engine, renderer, teams, ratings, netcode glue
│   ├── net/                 # WebRTC + relay transport for friend matches
│   ├── screens/             # routed screens (home, world cup, online, match, settings...)
│   └── ui/                  # design system: shell, menu navigation, dialogs, sounds, HUD
├── football/                # the Serverpod project
│   ├── football_server/     # endpoints, models, migrations, relay, tests, web/spa (built app)
│   └── football_client/     # generated Dart client (unused by the web app)
├── scripts/                 # smoke and end-to-end tests, data export, web build
└── docs/                    # documentation and screenshots
```

## Naming

The application is **Dream League Football**. Two internal names remain on purpose: the engine class `PitchKickGame` (file `engine.ts`) and the Serverpod Cloud project id `football`, which fixes the hosts `football.serverpod.space` and `football.api.serverpod.space`.
