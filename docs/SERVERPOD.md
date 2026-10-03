# Dream League Football on Serverpod

Dream League Football's entire back end is one [Serverpod](https://docs.serverpod.dev) 4.0.3 project: **`football/`** at the repository root. This document explains what Serverpod does for the game, how each Serverpod feature is used, and how to work on and operate the server.

If you only want the endpoint list, see [API.md](API.md). For the online match protocol, see [MULTIPLAYER.md](MULTIPLAYER.md).

## Contents

1. [Why Serverpod, and what it does here](#1-why-serverpod-and-what-it-does-here)
2. [Project layout](#2-project-layout)
3. [Authentication](#3-authentication)
4. [Endpoints and how the web app calls them](#4-endpoints-and-how-the-web-app-calls-them)
5. [Data model and migrations](#5-data-model-and-migrations)
6. [Concurrency: transactions and row locks](#6-concurrency-transactions-and-row-locks)
7. [The web server: hosting the app and the relay](#7-the-web-server-hosting-the-app-and-the-relay)
8. [Rules the server enforces](#8-rules-the-server-enforces)
9. [Configuration and secrets](#9-configuration-and-secrets)
10. [Local development](#10-local-development)
11. [Testing](#11-testing)
12. [Serverpod Cloud: deploy and operate](#12-serverpod-cloud-deploy-and-operate)
13. [Working on the server: conventions](#13-working-on-the-server-conventions)

## 1. Why Serverpod, and what it does here

The football match itself runs in a player's browser (TypeScript, on a canvas). Everything that has to **outlive the tab or be trusted by two people** lives on the server:

| Need | Serverpod provides |
| --- | --- |
| Accounts that other people can't fake | `serverpod_auth_idp` email identity provider + JWT tokens |
| A solo World Cup that survives a refresh | Tables, endpoints, and server-side simulation of the other games |
| Introducing two browsers to each other | The `FriendMatch` row carries the WebRTC offer and answer |
| A match result neither player can forge alone | Two signed claims compared on the server, written under a row lock |
| Notifying a friend that you left, joined, or invited them | Polled endpoints backed by tables and a presence timestamp |
| A fallback when peer-to-peer fails | A WebSocket relay route on Serverpod's web server |
| Hosting the game itself | The same web server serves the built React app |
| Email for sign-up codes | Serverpod Cloud's built-in email service |
| Database, TLS, scaling, secrets | Serverpod Cloud (`scloud`) |

What Serverpod deliberately does **not** do: run the live match. A 22-player simulation at 60 frames per second is far cheaper in one browser than in a server loop per room, and it keeps latency down. See [MULTIPLAYER.md](MULTIPLAYER.md) for the reasoning and the consequences (host-authoritative simulation, signed results, plausibility checks).

## 2. Project layout

```
football/
├── pubspec.yaml                 # Dart workspace: football_server + football_client
├── football_server/
│   ├── bin/main.dart            # entry point -> lib/server.dart
│   ├── lib/server.dart          # Serverpod init: auth, cloud storage, relay route, SPA route
│   ├── lib/src/
│   │   ├── auth/                # EmailIdpEndpoint, JwtRefreshEndpoint, current_user helper
│   │   ├── profile/             # display name, record, account deletion
│   │   ├── tournament/          # solo World Cup: group logic, knockout bracket, endpoint
│   │   ├── friend/              # lobbies, friend matches, claims, relay route
│   │   ├── social/              # friends, blocks, invites, chat, reports, presence helpers
│   │   ├── admin/               # public maintenance status + operator tools
│   │   ├── data/world_cup_data.dart   # GENERATED from the TypeScript teams
│   │   ├── util/rate_limit.dart # in-memory token bucket
│   │   ├── generated/           # Serverpod code generator output (never edit)
│   │   └── **/*.spy.yaml        # model definitions
│   ├── migrations/              # 7 generated migrations (+ registry)
│   ├── config/                  # development / staging / production / test + passwords
│   ├── test/                    # unit tests
│   ├── web/spa/                 # the built React app (npm run build:web), served by the web server
│   └── scloud.yaml              # Serverpod Cloud project: "football"
└── football_client/             # generated Dart client (not used by the web app)
```

The Dart package names (`football_server`, `football_client`) and the Cloud project id (`football`) predate the game's rename to Dream League Football and stay as they are: the project id fixes the public URLs.

## 3. Authentication

Authentication is Serverpod's own `serverpod_auth_idp` with the **email identity provider** and the **JWT token manager**, configured in [`lib/server.dart`](../football/football_server/lib/server.dart):

```dart
pod.initializeAuthServices(
  tokenManagerBuilders: [JwtConfigFromPasswords()],
  identityProviderBuilders: [
    ServerpodCloudEmailIdpConfig(appDisplayName: 'Dream League Football'),
  ],
);
```

`appDisplayName` is the name the user sees in the verification email ("Dream League Football"). In development the code is printed to the server console; in staging and production Serverpod Cloud sends it by email with no further setup.

Two thin endpoint subclasses expose the generated behaviour:

- `emailIdp` (`EmailIdpEndpoint extends EmailIdpBaseEndpoint`) — `startRegistration`, `verifyRegistrationCode`, `finishRegistration`, `login`, `startPasswordReset`, `verifyPasswordResetCode`, `finishPasswordReset`, `hasAccount`.
- `jwtRefresh` (`JwtRefreshEndpoint extends RefreshJwtTokensEndpoint`) — `refreshAccessToken`.

### Sign-up flow (three Serverpod calls, then a profile)

1. `emailIdp/startRegistration(email)` → an `accountRequestId`; the code is emailed.
2. `emailIdp/verifyRegistrationCode(accountRequestId, code)` → a registration token.
3. `emailIdp/finishRegistration(registrationToken, password)` → `AuthSuccess` (access token, refresh token, expiry). The user is now signed in.
4. `profile/createProfile(displayName, acceptTerms)` — the game's own step: a unique public name. Until it exists the web app keeps the user on the "choose your player name" screen (`session.status === 'needsProfile'`).

### Tokens

Access tokens last **10 minutes**; the refresh token is stored with them in `localStorage`. The web client (`src/client/api/http.ts`) refreshes before expiry and once more on a 401, and maps Serverpod's authentication failure reasons to plain sentences ("Wrong email or password.").

The server reads the caller with `session.authenticated?.userIdentifier` (see `lib/src/auth/current_user.dart`). Every game endpoint sets `requireLogin => true`, so Serverpod rejects anonymous calls before our code runs. The only public endpoint is `liveOps/get` (maintenance status).

The auth module also defines a model named `UserProfile`; the game's own `UserProfile` table therefore imports the module with `import '...serverpod_auth_idp_server/core.dart' show AuthServices` to avoid a clash.

## 4. Endpoints and how the web app calls them

Serverpod exposes every `Endpoint` method as an HTTP call: `POST /<endpoint>/<method>` with a JSON body of named arguments and an `Authorization: Bearer <jwt>` header. The React app uses plain `fetch` through a ~150-line client (`src/client/api/http.ts`) instead of the generated Dart client:

```ts
// src/client/api/friend.ts
export const createLobby = () => call<LobbyView>('lobby/create', { clientVersion: CLIENT_VERSION });
```

Errors thrown on the server as `GameException` (a model in `game_exception.spy.yaml`) arrive as readable messages and are shown inline.

| Endpoint | Purpose | Details |
| --- | --- | --- |
| `emailIdp`, `jwtRefresh` | Sign-up, sign-in, password reset, token refresh | generated by Serverpod |
| `profile` | Profile, display-name check, favourite nation, record, delete account | [API.md](API.md#profile) |
| `tournament` | Solo World Cup run | [API.md](API.md#tournament) |
| `lobby` | Rooms: create, join by code, nation, ready, rematch, leave | [API.md](API.md#lobby) |
| `friendMatch` | Handshake, connected, leave, signed result, history | [API.md](API.md#friendmatch) |
| `friends` | Friend list, requests, blocks, invites, presence | [API.md](API.md#friends) |
| `chat`, `report` | Lobby chat, player reports | [API.md](API.md#chat-and-report) |
| `liveOps`, `admin` | Maintenance status; operator tools | [API.md](API.md#liveops-and-admin) |

After changing an endpoint signature, run `serverpod generate` and update the matching TypeScript in `src/client/api/`.

## 5. Data model and migrations

Models are `.spy.yaml` files next to the code that uses them. `serverpod generate` turns them into Dart classes, the ORM and the protocol; `serverpod create-migration` writes a SQL migration. The server applies pending migrations at boot (`--apply-migrations`).

### Tables

| Table | Model | What it stores |
| --- | --- | --- |
| `user_profile` | `UserProfile` | One per account: unique `displayName` (+ lower-cased `displayNameLower` with a unique index), `favouriteNation`, `termsAcceptedAt`, `bannedUntil`, `lastSeenAt` (presence) |
| `tournament` | `Tournament` | A solo run: owner, nation, `status` (`group`, `r32`, `r16`, `qf`, `sf`, `final`, `eliminated`, `champion`) |
| `tournament_fixture` | `TournamentFixture` | Every game of the run (72 group + knockout ties): teams, score, shootout goals, `decidedBy` (`90`/`et`/`pens`), `playedByUser`, idempotency nonce |
| `lobby` | `Lobby` | A room: unique 5-character `code`, host and guest, nations, ready flags, `status` (`open`/`live`/`closed`), `clientVersion`, link to the match and to a rematch room |
| `friend_match` | `FriendMatch` | The match: players, nations, `status` (`live`/`finished`/`abandoned`/`void`), both players' signed claims, final goals, `endReason`, `winnerUserId`, `leaverUserId`, WebRTC `offer`/`answer`, `transport`, JSON `stats` |
| `friendship` | `Friendship` | Directed request or accepted friendship, unique per pair |
| `user_block` | `UserBlock` | Who blocked whom |
| `lobby_invite` | `LobbyInvite` | An invite to a room, unique per room and recipient |
| `lobby_message` | `LobbyMessage` | Lobby chat lines |
| `player_report` | `PlayerReport` | Reports with optional match context |
| `audit_log` | `AuditLog` | Operator actions |
| `live_ops` | `LiveOps` | The maintenance switch and message (a single row) |

Plus the tables owned by `serverpod_auth_idp` (accounts, email credentials, refresh tokens) which Serverpod manages itself.

Non-persisted models (`*View`, `HeadToHead`, `RecordView`, `AdminStats`, `LiveStatus`, ...) are response shapes: they are what endpoints return so that the client never sees other users' ids it should not, or raw rows.

Users are referenced by their auth user id as a plain `String` (the auth module's UUID), not a foreign key. That makes **account deletion** simple and safe: personal rows are removed or nulled, and finished friend matches stay for the other player, who then sees "Removed player".

### Migrations

`football_server/migrations/` holds seven migrations (the schema, then additive changes such as `lastSeenAt`). The checked-in `migration_registry.txt` lists them. Rules:

- Always create a migration after changing a model that has a `table`: `serverpod create-migration` (add `--force` for destructive changes).
- Never edit generated files. A migration's `migration.sql` may be hand-edited only to avoid data loss, and the schema it ends with must still equal `definition.sql`.
- A new database is created from `definition.sql` and never replays migrations.

## 6. Concurrency: transactions and row locks

Two players act on the same `Lobby` or `FriendMatch` row within milliseconds of each other, most importantly when both sign the full-time score. A plain read-modify-write would let the second save overwrite the first. Every such write therefore uses a transaction with `lockMode: LockMode.forUpdate`:

```dart
await session.db.transaction((tx) async {
  final m = await FriendMatch.db.findById(session, id, transaction: tx, lockMode: LockMode.forUpdate);
  // change claims, then re-evaluate them
  await FriendMatch.db.updateRow(session, m!, transaction: tx);
});
```

This was a real bug found during development (a lost update between two simultaneous claims) and is the reason `_update` helpers exist in `lobby_endpoint.dart` and `friend_match_endpoint.dart`. Do not bypass them.

## 7. The web server: hosting the app and the relay

Serverpod 4's web server (built on Relic) is used for two things the JSON endpoints cannot do. Both are registered in `lib/server.dart`:

```dart
pod.webServer.addRoute(RelayRoute(pod.authenticationHandler!));
pod.webServer.addRoute(SpaRoute(Directory('web/spa'), fallback: File('web/spa/index.html')));
```

- **`SpaRoute`** serves the built React app (`npm run build:web` copies `dist/` into `football_server/web/spa`) with `index.html` as the single-page fallback, so deep links such as `/online?join=ABCDE` work. Because the page and the relay share one origin in production there is no CORS or cookie configuration. (The API lives on its sibling host `football.api.serverpod.space`, which the page derives from its own host.)
- **`RelayRoute`** is the WebSocket fallback for friend matches whose browsers cannot connect directly: `/relay/<matchId>`. The first frame must be `{"token": "<jwt>"}` within 8 seconds; the server verifies the token with the same authentication handler as the endpoints and admits only the two players of a **live** match. After that it forwards every text frame (max 64 KB) untouched to the other player, with a 20-second ping. Close codes are application codes in the 3000–4999 range (4003 refused, 4008 timed out), because Relic rejects others.

Neither route is required for the JSON API; if `web/spa` does not exist the SPA route is simply not added.

## 8. Rules the server enforces

All of these live in the endpoints, not the client:

- **Authorization.** A lobby, match or signal is visible only to its participants; a tournament only to its owner. Friend and block checks run on invites and joins.
- **Unique names**, case-insensitively, validated (3–16 of `A–Z a–z 0–9 _ -`), with a profanity mask for chat.
- **Rate limits** (`util/rate_limit.dart`, in-memory per user and action; fine for one instance): create room 6/min, join 20/min, claim 20/min, chat 8 per 10 s, friend request 10 per 10 min, invite 20 per 10 min, block 20 per 10 min, report 5/hour.
- **Version check.** A lobby records the client's build id (a hash of `src/client/game/**`, injected by Vite); joining with a different build is refused, because host and guest must run the same engine.
- **Maintenance mode.** While `live_ops.maintenance` is true no new rooms open; sign-in and running matches continue.
- **Suspensions.** `requireProfile` (used by every game endpoint) refuses a player whose `bannedUntil` is in the future with "This account is suspended.".
- **Tournament integrity.** A submitted score must belong to the caller's run, be the next unplayed fixture, be an integer 0–30; a repeated `nonce` returns the stored state, so retries are safe. Group games on the same matchday are simulated server-side (never future ones); a level knockout game requires shootout goals.
- **Result signing** (`friend/claims.dart`). Each player posts a claim `hostGoals:guestGoals:reason:leaver`. When both claims are identical the match is stored `finished`. If one player leaves, `friendMatch/leave` ends it at once as `abandoned` with the leaver recorded. If only one player has claimed, the other has a 45-second grace: after that a lone "the opponent left" claim is stored as `abandoned`, while a lone full-time signature is stored as `void` (nobody is given the win). Two claims that differ are stored as `void` (`mismatch`). A live match with no claims after 4 hours is closed as `void` (`timeout`). Abandoned and void matches count for nobody. Unit tests: `test/claims_test.dart`.
- **Presence.** `friends/list` checks the caller in (throttled to once per 25 s) by setting `lastSeenAt`; a player is "online" for 75 seconds afterwards.
- **Idle rooms.** An open lobby idle for 3 hours reads as closed; creating a room closes the player's older open rooms.

## 9. Configuration and secrets

`football_server/config/`:

| File | Purpose | In git? |
| --- | --- | --- |
| `development.yaml`, `test.yaml` | Local ports and embedded database (`database.dataPath`) | yes |
| `staging.yaml`, `production.yaml` | Template values; on Serverpod Cloud these are replaced by managed configuration | yes |
| `passwords.yaml` | Database password, JWT signing key, peppers, service secret | **no** (git-ignored and excluded from Cloud uploads) |
| `passwords.example.yaml` | The same keys with placeholders | yes |

Create your own `passwords.yaml` by copying the example and replacing every `<generate>` with a long random string (for example `openssl rand -base64 48`). Serverpod Cloud generates and manages the production values; extra secrets are set with the CLI:

```bash
scloud password set adminUserIds "<auth-user-id>[,<auth-user-id>]"   # who may call the admin endpoint
scloud password --help                  # list and remove passwords too
```

Passwords set that way are available to the server as `session.serverpod.getPassword('adminUserIds')`.

## 10. Local development

Prerequisites: Dart SDK (ships with Flutter) and the Serverpod CLI: `dart pub global activate serverpod_cli`. **No Docker is required**: `config/development.yaml` sets `database.dataPath: .serverpod/development/pgdata`, so Serverpod starts and manages an embedded PostgreSQL itself.

```bash
cd football/football_server
cp config/passwords.example.yaml config/passwords.yaml       # fill in secrets once
dart pub get
serverpod generate                                           # only after changing a model or endpoint
serverpod create-migration                                   # only after changing a table model
dart bin/main.dart --apply-migrations --role monolith        # API on :8080, web server on :8082
```

The sign-up verification code and password-reset code are printed in the server's console (`Registration code for <email>: <123456>`); the browser tests read them from the log file given in `SERVER_LOG`. In another terminal `npm run dev` serves the web app on port 5173, which calls the API on `localhost:8080`.

`lib/src/data/world_cup_data.dart` is generated from the TypeScript team files so the server knows every nation, group and fixture. After changing a roster, rating, group or fixture run `npm run export:data` in the repository root.

## 11. Testing

```bash
cd football/football_server
dart test            # stop any running dev server first: it holds a native DLL on Windows
```

`config/test.yaml` also uses an embedded database, so no Docker. The unit tests cover:

- `group_logic_test.dart` — group tables and tie-break order (points, then head-to-head, then goal difference, goals scored, then a deterministic draw).
- `knockout_test.dart` — the 32-team bracket is a proper tree ending in one final; every one of the C(12,8) = 495 sets of eight third-placed groups can fill the eight third-place slots; knockouts always have a winner.
- `claims_test.dart` — matching claims, abandon, grace period, one-sided claims.

HTTP smoke tests and Playwright browser tests that exercise the server through the real web app are in `scripts/` — see [DEVELOPMENT.md](DEVELOPMENT.md#tests).

## 12. Serverpod Cloud: deploy and operate

The game runs on **Serverpod Cloud**. Project id: `football` (`football_server/scloud.yaml`).

| | |
| --- | --- |
| Web app + relay | <https://football.serverpod.space> |
| API | <https://football.api.serverpod.space> |

### Deploy

```bash
npm run build:web                      # React build -> football/football_server/web/spa
cd football/football_server
scloud deploy --yes --non-interactive  # zips, uploads, builds (~2 min), rolls out (~1 min)
```

Cloud applies the committed migrations at start-up, provisions the database and TLS, and routes the two hosts. The `.scloudignore` excludes `config/passwords.yaml` and the config files (Serverpod Cloud supplies its own) but keeps `web/**` and the generated code, so the built app ships with the server.

### Operate

```bash
scloud status                          # project and deployment state
scloud log                             # server logs
scloud build                           # build logs
scloud db                              # database commands
scloud password set adminUserIds <id>  # allow operator endpoints for these users
```

Operator endpoints (`admin/*`, callable only by the listed users): `stats`, `setMaintenance(on, message)`, `suspend(name, hours)` (0 lifts it), `voidMatch(matchId, reason)`. Every action is written to `audit_log`.

### Cost note

The project is on the Serverpod Cloud Starter trial. A match uses almost no server resources while it is peer-to-peer; only the relay fallback keeps a socket open for the length of a match.

## 13. Working on the server: conventions

- Never edit `lib/src/generated/` or `football_client/`. Change a model, an endpoint, or `server.dart`, then `serverpod generate`.
- Run, in order: `dart analyze`, `dart format`, create/apply migrations if a model changed, restart the server, `dart test`.
- Any write to a row both players can touch uses a transaction and `LockMode.forUpdate` (section 6).
- New endpoints set `requireLogin => true` unless they must be public, and call `rateLimit(...)` if a user can spam them.
- Keep client and server in step: update `src/client/api/*.ts` when a signature changes and extend `scripts/smoke-*.mjs`.
- More detail for contributors: [football/AGENTS.md](../football/AGENTS.md).
