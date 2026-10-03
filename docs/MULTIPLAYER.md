# Online matches

How two people play one match against each other in Dream League Football, and the part Serverpod plays in it.

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
- The cost is trust: the host could cheat. The design answers that with **two-signature results** and a **plausibility check** (below), and the stakes are deliberately low (there is no ranked ladder).

## Lifecycle of a friend match

1. **Room.** `lobby/create` (host) → a 5-character code. The guest joins by code, link (`/online?join=CODE`), QR code or an invite from `friends/invite`. Both players pick different nations and press ready; when both are ready the server creates the `FriendMatch` row and returns its id. Everyone sees joins, leaves, nation picks and readiness through a one-second poll of `lobby/get`, with toasts. The build id must match (the lobby stores `clientVersion`).
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
| both | heartbeat | 1/s | Keeps silence detection honest |

A player row is `[x, y, vx, vy, facingX, facingY, anim, kick, dive, diveDir, slide, slideX, slideY, flags, squadIndex, team]` (`src/client/game/snapshot.ts`). Rows carry their squad index and team, so when a player is sent off the rows simply disappear and the guest matches the rest by identity, not position.

**Mirroring.** The host's world has the host attacking right. The guest's view mirrors x so that the guest also attacks right, and the guest's keys go through the same code path as the host's own player (`flipWorld`, `runGuestSeat`, `SeatState`) inside the host's engine. The guest's controls therefore feel identical to the host's.

## Feel across latency

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

Writes happen in a transaction with a row lock, so two near-simultaneous claims can never overwrite each other (see [SERVERPOD.md §6](SERVERPOD.md#6-concurrency-transactions-and-row-locks)). The rules are unit-tested in `football_server/test/claims_test.dart`.

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
| `dart test` | Claim resolution |
