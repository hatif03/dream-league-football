# Online matches

How two people play against each other in Dream League Football, and the part Serverpod plays in it. There are two kinds of online game, and they are built differently on purpose:

| | **11 v 11 match** | **Penalty duel** |
| --- | --- | --- |
| Who runs the game | The host's browser (host-authoritative) | **The Serverpod server (referee)** |
| Result | Both players sign the score | The server decides; nothing to sign |
| Can a player cheat? | A host could try; two signatures and plausibility checks catch it | No: a request is a number from 0 to 5 |
| Latency matters | Yes (see below) | No: turn-based, 25 s per kick |
| Found by | Room code, link, invite, **or matchmaking** | Room code, link, invite, **or matchmaking** |
| Changes your rating | Yes (K = 24) | Yes (K = 16) |

Sections: [the match](#the-idea-in-one-paragraph) · [finding an opponent](#finding-an-opponent-matchmaking) · [the penalty duel](#the-penalty-duel) · [live updates](#live-updates) · [ratings](#ratings).

## The idea in one paragraph

The match is **simulated in one player's browser** (the *host*) and **drawn in the other's** (the *guest*). The two browsers talk directly over WebRTC; if that cannot connect they talk through a WebSocket relay on the **Serverpod** server. Serverpod's endpoints introduce the players (rooms, the WebRTC handshake), watch for people leaving, and store the result, which both players have to sign. The server never runs the game.

```
            ┌─────────────────────── Serverpod (football.api / football) ───────────────────────┐
            │ lobby/*   friendMatch/*   friends/*   chat/*          /relay/<matchId> (WebSocket) │
            └───────▲───────────▲────────────────────────────────────────────▲───────────────────┘
                    │ rooms,    │ handshake, leave,                          │ fallback transport
                    │ invites   │ signed result                              │
        ┌───────────┴──┐        │                                  ┌─────────┴────┐
        │  HOST browser │◄══════╪═══ WebRTC data channel ══════════►│ GUEST browser │
        │ PitchKickGame │  snapshots ≈30/s →        ← inputs         │  GuestView    │
        │  (simulation) │                                            │  (renderer)   │
        └──────────────┘                                            └──────────────┘
```

## Why host-authoritative

- A 22-player simulation with physics, AI and rules is cheap in a browser and expensive as a server process per room. Peer-to-peer costs the server almost nothing.
- Latency is lower: the host plays with zero delay, the guest sees the host's world about 110 ms behind plus the network.
- The cost is trust: the host could cheat. The design answers that with **two-signature results** and a **plausibility check** (below), and the stakes are kept modest: a rating moves only for a finished match both players signed, at most five rated matches count per pair per day, and abandoned or void matches count for nobody.

## Lifecycle of a friend match

1. **Room.** `lobby/create` (host) → a 5-character code. The guest joins by code, link (`/online?join=CODE`), QR code or an invite from `friends/invite`. Both players pick different nations and press ready; when both are ready the server creates the `FriendMatch` row and returns its id. Everyone sees joins, leaves, nation picks and readiness (the server pushes a `lobby` event over the [live socket](#live-updates); a slow poll of `lobby/get` is the fallback), with toasts. The build id must match (the lobby stores `clientVersion`).
2. **Count-in.** A 3-2-1 count-in starts both browsers at about the same time.
3. **Handshake** (`friendMatch/postOffer`, `postAnswer`, `getSignal`). The host creates an `RTCPeerConnection` with two Google STUN servers and a data channel, **waits for ICE gathering to finish** (capped at 2.5 s) and posts one offer that already contains every candidate ("non-trickle ICE"). The guest polls `getSignal` (every 250 ms), answers the same way, and the host polls for the answer. Two small posts instead of a stream of candidates keeps the signalling to Serverpod trivial. The offer and answer live on the `friend_match` row.
4. **Transport.** If the channel is not open within 12 s the pair switches to the **relay**: each connects a WebSocket to `/relay/<matchId>`, authenticates with its JWT in the first frame, and the server forwards frames between them. `friendMatch/connected(transport)` records which transport was used. A setting (`localStorage` `wc2026.forceRelay=1`) forces the relay for testing.
5. **Play.** The host runs `PitchKickGame` with a `guestSeat`; the guest runs `GuestView`.
6. **Result.** Both sides sign the final score (below). The full-time panel shows the stats, offers a rematch (host and guest swap) and a report button.

## Messages

All frames are JSON text, identical over WebRTC and the relay (`src/client/net/peerMatch.ts`).

| Direction | Frame | Rate | Content |
| --- | --- | --- | --- |
| host → guest | **snapshot** | ≈ 30/s, unreliable and unordered | Sender time and sequence, camera, ball (x, y, z, vx, vy, vz), one 16-number row per player on the pitch, who each side controls, score, match clock, HUD (messages, charge, stats, cards) |
| guest → host | **input** | on change, plus a 250 ms heartbeat, reliable and ordered | Canonical key codes pressed and released |
| both | **bye** (`{"k":"b"}`) | once | "I am leaving on purpose" |
| both | **emote** (`{"k":"e","c":3}`) | on demand, at most one per 1.2 s | Quick chat: `c` is the index of a phrase in `src/client/net/emotes.ts` |
| both | **ping / pong** (`{"k":"p","t":…}` and `{"k":"o","t":…}`) | 1/s | Doubles as the heartbeat for silence detection and measures the round-trip time |

A player row is `[x, y, vx, vy, facingX, facingY, anim, kick, dive, diveDir, slide, slideX, slideY, flags, squadIndex, team]` (`src/client/game/snapshot.ts`). Rows carry their squad index and team, so when a player is sent off the rows simply disappear and the guest matches the rest by identity, not position.

**Mirroring.** The host's world has the host attacking right. The guest's view mirrors x so that the guest also attacks right, and the guest's keys go through the same code path as the host's own player (`flipWorld`, `runGuestSeat`, `SeatState`) inside the host's engine. The guest's controls therefore feel identical to the host's.

## Feel across latency

- **Fair latency.** Each side measures the round trip (a smoothed ping, shown as a "ms" chip). The host holds back their own key presses by half of it (capped at 100 ms), which is how long the guest's presses take to reach the simulation, so neither player's input has a head start. Order of presses and releases is preserved, and it only applies to the host of a friend match. The guest still sees the match about 110 ms late plus half the round trip; see [ROADMAP.md](ROADMAP.md#latency-fairness-in-online-matches) for what this does and does not fix.

- The guest renders about **110 ms in the past** and interpolates between snapshots, so 30 packets a second look smooth.
- A jump larger than 260 px between snapshots is treated as a restart/teleport (kick-off, set piece), not a run.
- The host's own player is unaffected by network delay.
- The host's hidden tab: browsers throttle `requestAnimationFrame` in background tabs, which would freeze the match for the guest. `enableBackgroundTicks()` steps the simulation from a **Web Worker** clock instead, so the match keeps running (the host gets a banner too).

## Signed results

Each player posts `friendMatch/claim` with the score as they saw it: the canonical text `hostGoals:guestGoals:reason:leaver`.

| Claims | Stored as |
| --- | --- |
| Both identical, reason `fulltime` | `finished`, winner by goals (a draw has no winner) |
| Both identical, reason `abandoned` | `abandoned`, with the leaver |
| Different | `void` (`mismatch`): counts for nobody |
| One only, after 45 s: "opponent left" | `abandoned` |
| One only, after 45 s: full time | `void` (`timeout`): a single signature is never enough |
| None after 4 hours | `void` (`timeout`) |

Writes happen in a transaction with a row lock, so two near-simultaneous claims can never overwrite each other (see [SERVERPOD.md §7](SERVERPOD.md#7-concurrency-transactions-and-row-locks)). The rules are unit-tested in `football_server/test/claims_test.dart`.

**Plausibility check.** The guest watches the host's stream: a player moving faster than 700 px/s (a sprint is about 250), or repeated impossible jumps, count as anomalies. After three, the guest **refuses to sign** the result and the match is not recorded. Reports (`report/create`) carry the match id for review.

## Leaving, disconnecting and crashes

This was the biggest UX gap found in the first live test (a player quit and the other never knew). It is now handled in layers, fastest first:

1. **Quit from the pause menu** → confirm dialog → the app sends a `bye` frame on the channel **and** calls `friendMatch/leave`. The opponent's screen changes within about 100 ms ("*Name* left the match") and the server row is already `abandoned` with `leaverUserId` set.
2. **Closing the tab or navigating away** → the `pagehide` handler sends `friendMatch/leave` with `fetch(..., { keepalive: true })`, which browsers allow to finish after the page is gone. A waiting lobby is freed the same way (`lobby/leave`).
3. **Silent network loss** → no data for 8 s means the link is dead. Both sides try to **reconnect for 25 s**; if that fails the one who stayed signs an `abandoned` claim naming the other.
4. **Backstop poll.** While playing, each client also reads `friendMatch/get` every 3 s, so a leave is noticed even if the data channel is silent.
5. **Server timeouts** (above) settle anything nobody reported.

An abandoned or void match counts for nobody in the profile record; the "abandoned" counter shows how often a player left.

Presence (the green dot, invite toasts) uses `UserProfile.lastSeenAt`, refreshed by the friends poll (see [API.md](API.md#friends)).

## Finding an opponent: matchmaking

No friend online? `matchmaking/join(mode, clientVersion)` puts the player in a queue for a 11 v 11 match or a penalty duel. The server pairs two waiting players when they play the same mode on the same build, neither has blocked the other, and their ratings are within `100 + 15 × secondsWaited` points (the window widens the longer both wait). It then creates a **ready** room with nations chosen for them (their favourite nation if set, otherwise random, never the same), starts the match and pushes a `queue` event. The player who waited longer hosts.

The app shows "Searching… 12s" with how many others are waiting, can be cancelled, and resumes after a reload (`matchmaking/status` is also the keep-alive: a player who stops asking for 20 s stops being matched). Both players land straight in the game: the 11 v 11 handshake above, or the duel below.

## The penalty duel

A duel is five penalties each, then sudden death, **refereed by Serverpod** (`penalty/state`, `penalty/submit`). The goal is six zones (top/bottom × left/centre/right). On each kick both players choose a zone in secret: the shooter where to shoot, the keeper where to dive. When both have chosen, or after 25 seconds (whoever did not choose gets a random zone), the server draws the result with its own `Random.secure()`.

```
  shooter ── submit(zone 0-5) ─┐                            ┌─ DuelView (kick shown only once settled)
                               ├─► Serverpod: lock match row ─► draw: goal / saved / wide / post ─► next kick or finish + Elo
  keeper  ── submit(zone 0-5) ─┘            ▲                └─ liveHub: "duel" event to both players
                                            └─ also: lazy check in penalty/state, and a future call at the deadline
```

- **Hidden information.** `DuelView` carries who shoots and the zones of *settled* kicks only; the open kick shows nothing about the other choice. The first choice for a kick stands, so a retried request cannot change it.
- **Outcomes.** The top corners go wide 18 % of the time, the bottom corners 7 %, the middle 3–6 %, and any shot can hit the post (4 %); a keeper who dives to the shooter's zone saves it, to the right side but wrong height saves 35 %, to the neighbouring zone at the same height 10 %.
- **Timeouts.** Every kick schedules a Serverpod **future call** at its deadline, so a duel finishes even if both browsers close. Duels no one has touched for a long time are voided by the nightly job.
- **Leaving** a duel forfeits it (`friendMatch/leave`): the match ends `abandoned`, no rating changes, the opponent sees "left the duel".
- **UI.** `src/client/screens/match/DuelStage.tsx`: a goal with six buttons (arrows or D-pad + Enter/A, or tap), a countdown bar, a reveal of each kick (ball and keeper), kick dots for both sides, a result panel with the rating change, rematch and share.

## Live updates

Rooms, chat, friends, duels and the queue used to be polled every one to six seconds. A Serverpod web-server route, `/live`, now pushes "this changed" events instead: the browser opens one WebSocket, authenticates with its JWT, and receives `{"t": "lobby" | "chat" | "friends" | "match" | "duel" | "queue", "id": "…"}` after the server changes something relevant to that player. The app then refetches just that thing. Events carry no game data, so a missed one costs nothing: every screen keeps a slow poll and refetches on reconnect. Details: [SERVERPOD.md §9](SERVERPOD.md#9-live-push-the-live-websocket).

## Ratings

Every player starts at 1000. A finished online match or duel moves ratings by Elo (K = 24 for a match, 16 for a duel, a draw is half a win, a floor of 100): beating a stronger player is worth more. The change is computed inside the transaction that finishes the match, so it is applied exactly once, and shown on the result panel, the profile and the leaderboard (rank by rating or by points). Two friends cannot farm each other: after five finished matches between the same pair in 24 hours, further ones change nothing.

## Testing the netcode

| Script | What it proves |
| --- | --- |
| `scripts/e2e-friend.mjs` | Two real Chrome browsers sign in, create and join a room, chat, pick nations, ready up, play over the direct transport, move the guest's player with the guest's keyboard, finish, sign the same score, see stats, and start a rematch |
| `e2e-friend.mjs --relay` | The same through the Serverpod WebSocket relay |
| `e2e-friend.mjs --leave` | The guest quits from the menu; the host sees it in under a second and the server marks the match `abandoned` with the right leaver |
| `e2e-friend.mjs --abandon` | The guest's tab disappears; the host ends up with an abandoned match |
| `e2e-friend.mjs --invite` | Joining through a friend invite toast instead of the link |
| `scripts/e2e-loopback.mjs` | Host and guest in one page (`/dev/loopback`): fuzzed streams, fouls, penalties, red cards, hidden-tab ticks |
| `scripts/smoke-friend.mjs`, `smoke-relay.mjs` | HTTP and relay protocol checks, including that strangers are refused |
| `scripts/e2e-duel.mjs` | Two real browsers find each other through matchmaking and play a whole penalty duel through the UI: exactly one wins, ratings move, the leaderboard shows it |
| `scripts/smoke-duel.mjs` | The same over HTTP, plus the `/live` socket (a bad token is refused, a pairing is pushed), the daily challenge and the `/r/<id>` share page |
| `dart test` | Claim resolution, shootout/Elo/challenge rules, and the `serverpod_test` integration test that plays a duel through the endpoints |
