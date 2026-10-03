# Development guide

How to run, test, change and deploy Dream League Football.

## Prerequisites

| Tool | Needed for | Install |
| --- | --- | --- |
| Node.js 20+ | The web app and all scripts | <https://nodejs.org> |
| Dart SDK 3.12+ (ships with Flutter) | The Serverpod server | <https://docs.flutter.dev/get-started/install> |
| Serverpod CLI | `serverpod generate`, `create-migration` | `dart pub global activate serverpod_cli` |
| Serverpod Cloud CLI (`scloud`) | Deploying | See <https://docs.serverpod.dev/cloud> |
| Chrome or Edge | Browser tests (Playwright drives the installed browser) | |

**Docker is not needed.** The server's development and test configs set `database.dataPath`, so Serverpod runs its own embedded PostgreSQL.

On Windows run the Dart tools from PowerShell or cmd (the `.bat` shims are not on the Git Bash path).

## First run

```bash
npm install

# 1. Server secrets (once). Copy the template and replace every <generate> with a long random string.
cd football/football_server
cp config/passwords.example.yaml config/passwords.yaml
dart pub get

# 2. Start the server (applies migrations, API on :8080, web server + relay on :8082)
dart bin/main.dart --apply-migrations --role monolith

# 3. In another terminal, start the web app
cd ../..
npm run dev                                   # http://localhost:5173
```

Practice mode works with only step 3. In development the **sign-up verification code is printed in the server console** (`Registration code for you@example.com: <123456>`), so you can create accounts without email.

## Everyday commands

| Task | Command |
| --- | --- |
| Web dev server | `npm run dev` |
| Typecheck | `npm run typecheck` |
| Production build | `npm run build` |
| Build and copy into the server's `web/spa` | `npm run build:web` |
| Regenerate server data from the team files | `npm run export:data` |
| Regenerate Serverpod code after a model or endpoint change | `cd football/football_server && serverpod generate` |
| Create a database migration after a table model change | `serverpod create-migration` (add `--force` for destructive changes) |
| Analyse / format the server | `dart analyze` / `dart format .` |
| Server unit tests | `dart test` (stop a running dev server first) |

### Changing things

- **A table or model:** edit the `.spy.yaml`, `serverpod generate`, `serverpod create-migration`, restart the server. Never edit `lib/src/generated/` or `football_client/`.
- **An endpoint:** edit the Dart method, `serverpod generate`, then update the wrapper in `src/client/api/` and, if needed, `docs/API.md`.
- **A roster, rating, group or fixture:** edit `src/client/game/teams/*.ts`, then `npm run export:data` so the server agrees.
- **Anything that changes game physics or rules** (engine, ratings, teams): the build id changes, so players on an old tab cannot join a room with someone on the new build. That is intended.

## Tests

Test scripts live in `scripts/`. Most need the local server running and `SERVER_LOG` set to the file the server's console output is written to (they read the sign-up codes from it):

```bash
# start the server logging to a file (PowerShell example)
cd football/football_server
Start-Process dart -ArgumentList 'bin/main.dart','--apply-migrations','--role','monolith' -RedirectStandardOutput $env:TEMP\sp_out.log -WindowStyle Hidden

export SERVER_LOG="$TEMP/sp_out.log"
```

| Script | Needs | What it checks |
| --- | --- | --- |
| `dart test` (in `football_server`) | nothing running | Group tie-breaks, the 495 third-place combinations, the knockout bracket, claim resolution |
| `node scripts/smoke-api.mjs` | server | Sign-up, profile, a whole solo World Cup to the final, over HTTP |
| `node scripts/smoke-friend.mjs` | server | Lobby, handshake, claims, leave, history over HTTP |
| `node scripts/smoke-social.mjs` | server | Friends, blocks, invites, chat, reports, presence, operator rules |
| `node scripts/smoke-relay.mjs` | server | The WebSocket relay accepts the players and refuses strangers |
| `node scripts/test-shootout.mjs` | nothing | The penalty shootout rules |
| `node scripts/e2e-ui.mjs [--quick]` | server + Vite | Sign up in a real browser, choose a nation, play a World Cup match to full time, result saved (`--quick` skips the match) |
| `node scripts/e2e-knockout.mjs` | server + Vite | A Round-of-32 game through extra time and a penalty shootout; the CPU takes its own penalties |
| `node scripts/e2e-input.mjs` | Vite | Controller (simulated gamepad) and touch controls |
| `node scripts/e2e-friend.mjs [--relay\|--leave\|--abandon\|--invite]` | server + Vite | Two real browsers play a friend match end to end, in each of the situations in [MULTIPLAYER.md](MULTIPLAYER.md#testing-the-netcode) |
| `node scripts/e2e-loopback.mjs` | Vite | Host and guest in one page: fuzzed streams, fouls, penalties, cards, hidden-tab ticks |
| `node scripts/check-live.mjs` | internet | The deployed site: loads, deep links work, the API is reachable cross-origin. `APP=https://football.serverpod.space` |
| `node scripts/shots.mjs`, `shots-landscape.mjs` | server + Vite | Screenshots of every screen for design review |

The scripts launch Playwright against the installed Chrome or Edge (no browser download). Screenshots go to `.e2e-shots/` (git-ignored).

Dev-only hooks (never present in a production build): the `/dev/loopback` route, `window.__game`, `window.__shoot`, `window.__fm`, and `localStorage['wc2026.forceRelay']='1'` to force the relay transport.

## Deploying

```bash
npm run build:web                              # builds the app into football/football_server/web/spa
cd football/football_server
scloud deploy --yes --non-interactive          # about 3 minutes
node ../../scripts/check-live.mjs              # verify (set APP if needed)
```

Details, operations and secrets: [SERVERPOD.md §12](SERVERPOD.md#12-serverpod-cloud-deploy-and-operate). A first request right after a rollout can time out while the new instance settles; retry once.

Production sign-up sends a real email through Serverpod Cloud, so authenticated flows cannot be scripted against the live site without a real inbox. Test those locally.

## Troubleshooting

| Symptom | Cause and fix |
| --- | --- |
| `dart test` fails with a locked DLL | A dev server is still running. Stop it first |
| Browser tests fail with "set SERVER_LOG" | Export `SERVER_LOG` to the server's output file |
| The web app says it cannot reach the server | The server is not running on `:8080`, or `VITE_API_URL` points elsewhere |
| "Your game version differs from the host" when joining a room | The two players run different builds; both reload the page |
| A blank Online screen right after `npm install` | Vite re-optimising dependencies; reload once |
| Friend matches never leave "connecting" locally | Chrome hides local IPs with mDNS; the scripts launch Chrome with `--disable-features=WebRtcHideLocalIpsWithMdns`. Otherwise the relay takes over after 12 s |
| Sign-up code not arriving in production | Production emails the code; check spam. In development read the server console |
| `serverpod` / `dart` not found in Git Bash on Windows | Use PowerShell or cmd |
| Import clash on `UserProfile` | The auth module also exports one; import `AuthServices` with `show` |

## Conventions

- TypeScript strict; run `npm run typecheck` before committing.
- Keep engine changes behind the existing structure: constants in `constants.ts`, pure drawing in `render.ts`, rating effects in `ratings.ts`.
- Any server write to a row two players can touch uses a transaction and a row lock.
- A change to what the guest must draw also changes `snapshot.ts` and `guestView.ts`; cover it in `e2e-loopback.mjs`.
- Document behaviour in `docs/` and add a line to `CHANGELOG.md`.
