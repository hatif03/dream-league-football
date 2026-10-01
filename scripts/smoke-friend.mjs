#!/usr/bin/env node
// Friend-match smoke test: rooms, the build check, readiness, the handshake, and
// the two-signature result. Usage: SERVER_LOG=/path/to/server.log node scripts/smoke-friend.mjs
import assert from 'node:assert/strict';
import { call, register } from './lib/api.mjs';

const run = `${Date.now()}`.slice(-8);
async function player(tag) {
  const auth = await register(`${tag}${run}@example.com`);
  const jwt = auth.token;
  await call('profile/createProfile', { displayName: `${tag}_${run}`, acceptTerms: true }, jwt);
  return jwt;
}
const [host, guest, stranger] = await Promise.all([player('host'), player('guest'), player('other')]);
const V = 'build-1';

// Room: create, join (build must match), pick nations, ready up.
let lobby = await call('lobby/create', { clientVersion: V }, host);
assert.equal(lobby.lobby.code.length, 5);
assert.equal(lobby.youAreHost, true);
const id = lobby.lobby.id;

await assert.rejects(call('lobby/join', { code: lobby.lobby.code, clientVersion: 'other' }, guest), /version/);
lobby = await call('lobby/join', { code: lobby.lobby.code.toLowerCase(), clientVersion: V }, guest);
assert.equal(lobby.youAreHost, false);
assert.match(lobby.hostName, /^host_/);
await assert.rejects(call('lobby/join', { code: lobby.lobby.code, clientVersion: V }, stranger), /full/);
await assert.rejects(call('lobby/get', { lobbyId: id }, stranger), /not found/);

await call('lobby/setNation', { lobbyId: id, nationId: 'brazil' }, host);
await assert.rejects(call('lobby/setNation', { lobbyId: id, nationId: 'brazil' }, guest), /different/);
await assert.rejects(call('lobby/setReady', { lobbyId: id, ready: true }, guest), /nation first/);
await call('lobby/setNation', { lobbyId: id, nationId: 'germany' }, guest);
await call('lobby/setReady', { lobbyId: id, ready: true }, host);
lobby = await call('lobby/setReady', { lobbyId: id, ready: true }, guest);
assert.equal(lobby.lobby.status, 'live');
const matchId = lobby.lobby.matchId;
assert.ok(matchId);

// Handshake: only the right peer may post each half; a stranger sees nothing.
await assert.rejects(call('friendMatch/postOffer', { matchId, sdp: 'x' }, guest), /host/);
await call('friendMatch/postOffer', { matchId, sdp: 'OFFER' }, host);
await assert.rejects(call('friendMatch/postAnswer', { matchId, sdp: 'x' }, host), /guest/);
assert.equal((await call('friendMatch/getSignal', { matchId }, guest)).offer, 'OFFER');
await call('friendMatch/postAnswer', { matchId, sdp: 'ANSWER' }, guest);
assert.equal((await call('friendMatch/getSignal', { matchId }, host)).answer, 'ANSWER');
await assert.rejects(call('friendMatch/getSignal', { matchId }, stranger), /not found/);
await call('friendMatch/connected', { matchId, transport: 'direct' }, host);
assert.equal((await call('friendMatch/getSignal', { matchId }, guest)).offer ?? null, null);

// Result: one claim is not enough; matching claims are stored.
let m = await call('friendMatch/claim', { matchId, hostGoals: 3, guestGoals: 1, reason: 'fulltime' }, host);
assert.equal(m.match.status, 'live');
await assert.rejects(call('friendMatch/claim', { matchId, hostGoals: 9, guestGoals: 0, reason: 'fulltime' }, host), /different/);
m = await call('friendMatch/claim', { matchId, hostGoals: 3, guestGoals: 1, reason: 'fulltime' }, guest);
assert.equal(m.match.status, 'finished');
assert.equal(m.match.winnerUserId, m.match.hostUserId);
assert.equal(m.hostName, `host_${run}`);

// Rematch: a new room with host and guest swapped and nations kept.
const re = await call('lobby/rematch', { lobbyId: id, clientVersion: V }, guest);
assert.equal(re.youAreHost, true);
assert.equal(re.lobby.hostNation, 'germany');
assert.equal(re.lobby.guestNation, 'brazil');
const seen = await call('lobby/get', { lobbyId: id }, host);
assert.equal(seen.lobby.rematchLobbyId, re.lobby.id);

// A second match where the claims disagree is void and nobody wins.
await call('lobby/setReady', { lobbyId: re.lobby.id, ready: true }, guest);
const l2 = await call('lobby/setReady', { lobbyId: re.lobby.id, ready: true }, host);
const m2 = l2.lobby.matchId;
await call('friendMatch/claim', { matchId: m2, hostGoals: 10, guestGoals: 0, reason: 'fulltime' }, guest);
const v = await call('friendMatch/claim', { matchId: m2, hostGoals: 0, guestGoals: 10, reason: 'fulltime' }, host);
assert.equal(v.match.status, 'void');
assert.equal(v.match.winnerUserId ?? null, null);

const hist = await call('friendMatch/history', { limit: 10 }, host);
assert.equal(hist.length, 2);
assert.deepEqual(hist.map((h) => h.match.status).sort(), ['finished', 'void']);

// Both players sign at the same instant, repeatedly: no claim may be lost.
async function liveMatch() {
  const l = await call('lobby/create', { clientVersion: V }, host);
  await call('lobby/join', { code: l.lobby.code, clientVersion: V }, guest);
  await Promise.all([
    call('lobby/setNation', { lobbyId: l.lobby.id, nationId: 'spain' }, host),
    call('lobby/setNation', { lobbyId: l.lobby.id, nationId: 'japan' }, guest),
  ]);
  const [, done] = await Promise.all([
    call('lobby/setReady', { lobbyId: l.lobby.id, ready: true }, host).catch(() => null),
    call('lobby/setReady', { lobbyId: l.lobby.id, ready: true }, guest).catch(() => null),
  ]);
  const view = await call('lobby/get', { lobbyId: l.lobby.id }, host);
  assert.equal(view.lobby.hostReady && view.lobby.guestReady, true, 'both ready flags survive simultaneous writes');
  assert.ok(view.lobby.matchId, 'the match is created exactly when both are ready');
  return view.lobby.matchId;
}
for (let i = 0; i < 4; i++) {
  const id2 = await liveMatch();
  const claim = (jwt) => call('friendMatch/claim', { matchId: id2, hostGoals: 2, guestGoals: i % 3, reason: 'fulltime' }, jwt);
  await Promise.all([claim(host), claim(guest)]);
  const r = await call('friendMatch/get', { matchId: id2 }, host);
  assert.equal(r.match.status, 'finished', 'simultaneous claims must both be kept (round ' + i + ')');
}

// Leaving a live match ends it at once, as abandoned, naming the leaver; the other player sees it
// on their next poll. Leaving after full time changes nothing.
{
  const matchId3 = await liveMatch();
  let g = await call('friendMatch/get', { matchId: matchId3 }, guest);
  assert.equal(g.match.status, 'live');
  const left = await call('friendMatch/leave', { matchId: matchId3 }, host);
  assert.equal(left.match.status, 'abandoned');
  assert.equal(left.match.endReason, 'left');
  g = await call('friendMatch/get', { matchId: matchId3 }, guest);
  assert.equal(g.match.status, 'abandoned');
  assert.equal(g.match.leaverUserId, g.match.hostUserId, 'the host is named as the one who left');
  assert.equal(g.match.winnerUserId ?? null, null);
  await call('friendMatch/leave', { matchId: matchId3 }, guest); // idempotent
  const done = await call('friendMatch/get', { matchId }, host); // the finished match from earlier
  const after = await call('friendMatch/leave', { matchId }, host);
  assert.equal(after.match.status, done.match.status, 'leaving a finished match changes nothing');
}

console.log('friend smoke ok');
