# Changelog

What changed, newest first, grouped by theme. The game itself has been built since 25 September 2026; the Serverpod back end, online play and the new interface came in early October 2026.

## Dream League Football (October 2026)

- **Renamed the application to Dream League Football** (header logo, page title, share text, legal text, pitch advertising boards, package name). The solo mode keeps the name "World Cup". The engine codename `PitchKickGame` and the Serverpod Cloud project id `football` are unchanged.
- **Serverpod sign-in email** now reads "Dream League Football" (`appDisplayName` in `lib/server.dart`) instead of "football".
- Header logo shrinks on small screens instead of pushing the profile chip off the edge.
- Rewrote the documentation: README, [docs/SERVERPOD.md](docs/SERVERPOD.md), [docs/API.md](docs/API.md), [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md), [docs/MULTIPLAYER.md](docs/MULTIPLAYER.md), [docs/GAMEPLAY.md](docs/GAMEPLAY.md), [docs/UI.md](docs/UI.md), [docs/DEVELOPMENT.md](docs/DEVELOPMENT.md).

## The new interface ("Matchday Night")

- Full UI redesign: console-style navigation with a footer of button prompts, route-based screens, real dialogs, flags, menu sounds, a notification bell, a mobile bottom bar and a rotate prompt. See [UI_PLAN.md](UI_PLAN.md) and [docs/UI.md](docs/UI.md).
- Match creation and sharing: one-tap rooms, code / link / share sheet / QR, 5-box code entry, live join and leave toasts, nation picker, 3-2-1 count-in.
- **Leaving is reported**: `friendMatch/leave` ends a match as `abandoned` at once; a `bye` frame tells the opponent within about 100 ms; closing the tab reports the same through a keep-alive request; a poll covers a silent channel.
- Presence (`UserProfile.lastSeenAt`, `PersonView.online`) with an online dot.
- CPU difficulty (easy, normal, hard), CPU fouls, yellow and red cards, card counts in the match stats.
- Phone landscape layout (a `desk:` Tailwind variant means "wide and tall"), invite toasts that cannot be missed on page load, a closing tab frees a waiting lobby, old `/?room=CODE` links redirect, Settings and the pause menu open on the tab for the device in use.

## Online play

- Browser-side API client for Serverpod with token refresh; React Query hooks.
- WebRTC link with the Serverpod WebSocket relay as fallback; the guest's renderer with interpolation and a plausibility check on the host's stream.
- HTTP smoke tests for the server and the relay; real two-browser end-to-end tests.

## Serverpod back end

- Serverpod 4.0.3 project: email sign-up with an emailed code, JWT tokens, profiles and unique display names, account deletion.
- The solo World Cup on the server: group simulation by matchday, tie-breaks, the official Round-of-32 bracket with third-place assignment, extra time and shootout results.
- Lobbies and friend matches with the WebRTC handshake on the match row, two-signature results, abandon and void handling, row locks for simultaneous writes.
- The `/relay/<matchId>` WebSocket route; the same web server hosts the built app.
- Friends, blocks, invites, lobby chat, player reports, maintenance mode, audit log and operator endpoints.
- Database migrations, unit tests, Serverpod Cloud deployment.

## The game

- Scaffold: Vite, React 19, Tailwind v4, TypeScript.
- The engine: real-size pitch, pseudo-3D broadcast camera, charged passes and shots, through and lofted balls, tackling, goalkeepers, offside, set pieces, fouls and free kicks, extra time, a penalty shootout game.
- 48 nations with kits, squads and FIFA-style ratings; the real 2026 draw and group fixtures.
- Rebindable keyboard, controller and touch input.
