# football_server — the Dream League Football back end

A [Serverpod](https://serverpod.dev) 4.0.3 server (Dart, PostgreSQL). It gives the browser game accounts, a persistent solo World Cup, friend rooms with signed results, a social layer, a WebSocket relay, and it serves the built web app. It runs on **Serverpod Cloud** as project `football` (<https://football.serverpod.space>, API <https://football.api.serverpod.space>).

The full guide is [../../docs/SERVERPOD.md](../../docs/SERVERPOD.md); every endpoint is in [../../docs/API.md](../../docs/API.md).

## Run it

```bash
cp config/passwords.example.yaml config/passwords.yaml   # then replace each <generate> with a random string
dart pub get
dart bin/main.dart --apply-migrations --role monolith     # API :8080, web server + relay :8082
```

No Docker: `config/development.yaml` sets `database.dataPath`, so Serverpod runs an embedded PostgreSQL. The sign-up verification code is printed in this console. The web app runs from the repository root with `npm run dev` (port 5173).

```bash
dart test                         # unit tests (stop the dev server first)
serverpod generate                # after changing a .spy.yaml model or an endpoint
serverpod create-migration        # after changing a model that has a table
```

## What is where

| Path | Contents |
| --- | --- |
| `lib/server.dart` | Auth (email identity provider + JWT), cloud storage, the relay route, the web-app route |
| `lib/src/auth` | Email and JWT-refresh endpoints (subclasses of Serverpod's), current-user helpers |
| `lib/src/profile` | Display name, record, delete account |
| `lib/src/tournament` | The solo World Cup: group logic, the official 2026 knockout bracket, results |
| `lib/src/friend` | Lobbies, friend matches, two-signature results (`claims.dart`), the WebSocket relay |
| `lib/src/social` | Friends, blocks, invites, lobby chat, reports, presence |
| `lib/src/admin` | Public maintenance status and operator tools |
| `lib/src/data/world_cup_data.dart` | Generated from the TypeScript team files (`npm run export:data`) |
| `migrations/` | Generated database migrations |
| `config/` | Per-environment configuration; `passwords.yaml` is git-ignored |
| `web/spa/` | The built React app (git-ignored; `npm run build:web` fills it) |

## Deploy

```bash
npm run build:web                      # in the repository root
scloud deploy --yes --non-interactive  # here
```
