# Changelog

What changed, newest first, grouped by theme. The game itself has been built since 25 September 2026; the Serverpod back end, online play and the new interface came in early October 2026.

## Third round: a bigger Serverpod showcase, FIFA controls (8 October 2026)

**Serverpod**

- **Penalty duel refereed by the server** (`penalty/state`, `penalty/submit`): secret zone choices, server randomness, 25-second kicks, standard shootout rules. New tables `penalty_kick`, columns `mode` on `lobby` and `friend_match`.
- **Matchmaking** (`matchmaking/join|status|cancel`, table `queue_entry`): a rating window that widens while waiting, same build and mode, blocks respected.
- **Elo ratings** (`UserProfile.rating`, `hostRatingDelta` / `guestRatingDelta`), applied in the finishing transaction, with an anti-farming cap; leaderboard by rating or points; two new achievements (14 total).
- **Daily challenge** (`challenges/today`) with a streak, computed from stored matches.
- **Live push**: a `/live` WebSocket route and an in-memory hub notify players of friends, room, chat, duel and queue changes; polling slowed to a safety net.
- **Future calls**: `MaintenanceFutureCall.nightly` (cron 03:00 UTC) and `DuelFutureCall.kickTimeout` (one per kick).
- **Cloud storage + share pages**: `share/createResult` stores the result picture, `/r/<id>` serves an Open Graph preview page. `maxRequestSize` raised to 3 MB.
- **Tests**: `serverpod_test` integration tests, rule unit tests (31 `dart test` cases in all), `smoke-duel`, `e2e-duel`.
- Migration `20261008081311877`.

**Game**

- **FIFA-style controls**: a keyboard layout switch (FIFA classic arrows / EA FC WASD / custom), the EA FC controller layout (RT sprint, LT jockey), pause only on Esc/Start.
- **Penalty shootout mode** (Practice → Penalty shootout) with keyboard, controller and touch; friendlies can be decided by extra time and penalties.
- **Goal replays**, **commentary captions**, a synthesised **stadium crowd**, and **added time** at 90 minutes (all switchable in Settings).
- Share links instead of downloads for signed-in players.

**Fixes found while testing**

- A malformed `/r/<id>` link caused a server error instead of opening the app.
- Sudden death could end after the first kick of a pair (the early-finish check now only applies to the first five rounds).
- Reading a matchmaking result raced with a live push and could fail with "no rows deleted" (the delete is idempotent now).
- The score card (about 850 KB) exceeded the first upload limit and Serverpod's default 512 KB request size.

## Second round of features (4 October 2026)

- **11 v 11 friendly** against the CPU, **interactive tutorial**, **quick chat** in online matches, **install as an app** (manifest, icons, install card), **shareable result cards**.
- **Settings saved to your account** (`UserProfile.settings`, `profile/saveSettings`), a **club crest and kit editor** (`UserProfile.club`, `profile/saveClub`), **12 achievements** and a global **leaderboard** (new `rankings` endpoint). New migration.
- Google and Apple sign-in were not added: they need credentials from your own Google or Apple developer account.

## Fixes and additions after the first phone tests (4 October 2026)

- **Phone: could not start a match.** Focusing a button switched the "last device used" to keyboard, so tapping Kick Off reshuffled the intro card under the finger and the tap missed; the next touch flipped it back. Focus no longer changes the device.
- **Invite toast: Join did nothing** when you were already on the Online screen (the join code was only read once). It now joins from anywhere, and asks before leaving a room you are in.
- **Toasts now close themselves** (they could stay forever on a phone). Invites close after 10 s.
- Removed the "Supporting <nation>" line from the profile (it repeated the favourite-nation menu above it).
- **Avatars:** 24 pre-made avatars (new `UserProfile.avatar` column, `profile/setAvatar`, avatar on friends, invites and rooms).
- **Online latency fairness:** ping measured on the heartbeat and shown in matches; the host's own key presses are held back by half the round trip.
- **Half-time** break, selectable **match length** (3, 5, 8 min), and a **formation** choice before World Cup matches.
- A small vibration on touch buttons and goals.
- New [docs/ROADMAP.md](docs/ROADMAP.md): the mechanics inventory, what is missing, and experience ideas.

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
