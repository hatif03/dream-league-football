# Serverpod project

This project is a Serverpod server (backend).
Build for multiple users, use Serverpod's built-in authentication, which is already set up in `lib/server.dart`.

The user starts the server with `serverpod start`. There is no need to check if the server is running: make the changes and call the `serverpod` MCP tools as needed. If the server is not running, an informative error message will be received from the MCP server. Then STOP and ask the user to start it. NEVER start the server yourself.

While running, `serverpod start` watches for file changes to run incremental code generation and hot reload the running server.

Calling `serverpod generate` directly is not needed, but might be useful to troubleshoot when an incremental generation fails.

ALWAYS use the MCP server instead of the command line. Use the MCP server to:

- `create_migration` and `apply_migrations` for database (after you change data models).
- `create_repair_migration` if the database has drifted out of sync with the migrations.
- `tail_server_logs` to read logs from the server.
- `hot_reload` / `hot_restart` to reload or restart the server. Use `hot_restart` for changes that hot reload cannot apply, such as changes to `main()`.

NEVER edit generated code. The server's `lib/src/generated/` directory and the whole `football_client` package are rewritten by the code generator. Change the `.spy.yaml` models, the endpoints, or `lib/server.dart` instead.

Migrations are a narrow exception: the `migration.sql` of a generated migration MAY be edited by hand when the generated SQL would lose data — to add a data transformation, or to reach a destructive change through non-destructive steps. Never touch the other files in the migration directory, and keep the schema the SQL ends up with identical to `definition.sql` — new databases are created from that file and never run `migration.sql`.

Only when the server cannot be started at all, fall back to the CLI in the server package:

- `serverpod generate` to regenerate the client and the generated server code.
- `serverpod create-migration` after changing a model with a `table` (add `--force` for destructive changes). It only writes the migration; `serverpod start` applies pending migrations when it boots the server.

Tests need no Docker. `config/test.yaml` sets `database.dataPath`, so Serverpod starts and manages the test database (an embedded PostgreSQL) itself, and the project's `docker-compose.yaml` is not used for it. Just run `dart test` in the server package.

Checklist after doing changes, in this order:

- `dart analyze` (CLI)
- `dart format` (CLI)
- `create_migration` and `apply_migrations` (MCP - only if necessary)
- Do `serverpod` MCP `hot_restart` if required (hot reload is done automatically)
- Run tests, if applicable (`dart test` in the server package)
- Check `serverpod` MCP `tail_server_logs` for any issues.

Note: this project was created with `--ide none`, so the `serverpod` MCP server is not configured here. The server was run directly (`dart bin/main.dart --apply-migrations --role monolith`) and migrations were made with `serverpod create-migration`.

## What this server is

The back end of "World Cup 2026", an arcade football game played in the browser (the React app is in the repo root, `src/client`). It stores accounts, solo World Cup runs, friend rooms and results; the live match itself runs in a player's browser. Read `../PLAN.md` sections 0 and 0b before changing behaviour.

- Endpoints are called from TypeScript with plain JSON (`POST /<endpoint>/<method>`, Bearer JWT), not the generated Dart client. After changing an endpoint signature, update `../src/client/api/*.ts`.
- `lib/src/profile`: display name, record, account deletion. `lib/src/tournament`: the solo World Cup (group simulation, the official 2026 bracket, extra-time and shootout results). `lib/src/friend`: rooms, the WebRTC handshake on the match row, two-signature results (`claims.dart`), and the WebSocket relay route. `lib/src/social`: friends, blocks, invites, chat, reports. `lib/src/admin`: public maintenance status and operator tools (user ids come from the `adminUserIds` password).
- `lib/src/data/world_cup_data.dart` is GENERATED from the TypeScript teams: run `npm run export:data` in the repo root after changing a roster, rating, group or fixture.
- Every write to a row both players of a room or match can touch must run in a transaction with `lockMode: LockMode.forUpdate`; two players sign within milliseconds of each other.
- `lib/server.dart` serves the built React app from `web/spa` (`npm run build:web` in the repo root) and registers the relay route. The auth module also exports a `UserProfile`: import `AuthServices` with `show`.
- Deploy: `scloud deploy --yes --non-interactive` (project `football`, region Europe).
- Test: `dart test` here (stop a running dev server first: it holds a native DLL). HTTP and browser tests are in `../scripts`.
