#!/usr/bin/env node
// Social smoke test: friends, invites, lobby chat, blocks, reports, record, account deletion.
// Usage: SERVER_LOG=/path/to/server.log node scripts/smoke-social.mjs
import assert from 'node:assert/strict';
import { call, register } from './lib/api.mjs';

const run = `${Date.now()}`.slice(-8);
async function player(tag) {
  const auth = await register(`${tag}${run}@example.com`);
  const name = `${tag}_${run}`;
  await call('profile/createProfile', { displayName: name, acceptTerms: true }, auth.token);
  const me = await call('profile/me', {}, auth.token);
  return { jwt: auth.token, refresh: auth.refreshToken, name, id: me.userId };
}
const [a, b, c] = await Promise.all([player('anna'), player('ben'), player('cleo')]);
const V = 'v1';
const ask = (p, path, body = {}) => call(path, body, p.jwt);

// Public live status.
const live = await call('liveOps/get', {});
assert.equal(live.maintenance, false);

// Friend requests are by exact name; the other side accepts.
await assert.rejects(ask(a, 'friends/request', { name: 'nobody_here_x' }), /exact name/);
await assert.rejects(ask(a, 'friends/request', { name: a.name }), /That is you/);
let fa = await ask(a, 'friends/request', { name: b.name.toUpperCase() });
assert.equal(fa.outgoing.length, 1);
let fb = await ask(b, 'friends/list');
assert.equal(fb.incoming[0].name, a.name);
await assert.rejects(ask(c, 'friends/accept', { userId: a.id }), /no request/);
fb = await ask(b, 'friends/accept', { userId: a.id });
assert.equal(fb.friends[0].name, a.name);
fa = await ask(a, 'friends/list');
assert.equal(fa.friends[0].name, b.name);
assert.equal(fa.friends[0].online, true, 'b checked in by listing, so a sees b online');

// Invites: only friends, only from the host of an open room; joining clears the invite.
let room = await ask(a, 'lobby/create', { clientVersion: V });
await assert.rejects(ask(a, 'friends/invite', { userId: c.id, lobbyId: room.lobby.id }), /only invite friends/);
await ask(a, 'friends/invite', { userId: b.id, lobbyId: room.lobby.id });
await assert.rejects(ask(b, 'friends/invite', { userId: a.id, lobbyId: room.lobby.id }), /host/);
fb = await ask(b, 'friends/list');
assert.equal(fb.invites.length, 1);
assert.equal(fb.invites[0].code, room.lobby.code);
assert.equal(fb.invites[0].fromName, a.name);
await ask(b, 'lobby/join', { code: fb.invites[0].code, clientVersion: V });
assert.equal((await ask(b, 'friends/list')).invites.length, 0);

// Chat: members only, profanity masked, newest 50 in order.
await ask(a, 'chat/send', { lobbyId: room.lobby.id, text: 'hello there' });
await ask(b, 'chat/send', { lobbyId: room.lobby.id, text: 'you are a f u c k i n g legend' });
let lines = await ask(a, 'chat/list', { lobbyId: room.lobby.id });
assert.deepEqual(lines.map((l) => l.name), [a.name, b.name]);
assert.ok(!/fuck|f u c k/i.test(lines[1].text), `masked: ${lines[1].text}`);
await assert.rejects(ask(c, 'chat/list', { lobbyId: room.lobby.id }), /not found/);
await assert.rejects(ask(c, 'chat/send', { lobbyId: room.lobby.id, text: 'hi' }), /not found/);
await assert.rejects(ask(a, 'chat/send', { lobbyId: room.lobby.id, text: 'x'.repeat(201) }), /200/);

// Record: play a match, finished 2-1 to the host, then a draw.
async function play(host, guest, hostGoals, guestGoals) {
  const l = await ask(host, 'lobby/create', { clientVersion: V });
  await ask(guest, 'lobby/join', { code: l.lobby.code, clientVersion: V });
  await ask(host, 'lobby/setNation', { lobbyId: l.lobby.id, nationId: 'brazil' });
  await ask(guest, 'lobby/setNation', { lobbyId: l.lobby.id, nationId: 'france' });
  await ask(host, 'lobby/setReady', { lobbyId: l.lobby.id, ready: true });
  const live = await ask(guest, 'lobby/setReady', { lobbyId: l.lobby.id, ready: true });
  const matchId = live.lobby.matchId;
  const claim = (p) => ask(p, 'friendMatch/claim', { matchId, hostGoals, guestGoals, reason: 'fulltime' });
  await Promise.all([claim(host), claim(guest)]);
  return matchId;
}
const m1 = await play(a, b, 2, 1);
await play(b, a, 0, 0);
const ra = await ask(a, 'profile/record');
assert.deepEqual([ra.wins, ra.draws, ra.losses], [1, 1, 0]);
assert.equal(ra.headToHead[0].opponentName, b.name);
assert.deepEqual([ra.headToHead[0].wins, ra.headToHead[0].draws, ra.headToHead[0].losses], [1, 1, 0]);
const rb = await ask(b, 'profile/record');
assert.deepEqual([rb.wins, rb.draws, rb.losses], [0, 1, 1]);

// Reports carry real context: you can only cite a match you were in with that player.
await ask(a, 'report/create', { targetUserId: b.id, matchId: m1, reason: 'Left the match early' });
await assert.rejects(ask(c, 'report/create', { targetUserId: b.id, matchId: m1, reason: 'not my match' }), /not in that match/);
await assert.rejects(ask(a, 'report/create', { targetUserId: b.id, reason: 'x' }), /3 to 500/);
await assert.rejects(ask(a, 'report/create', { targetUserId: a.id, reason: 'myself' }), /yourself/);

// Operator tools are closed to everyone else.
await assert.rejects(ask(a, 'admin/setMaintenance', { on: true, message: null }), /Not allowed/);
await assert.rejects(ask(a, 'admin/stats'), /Not allowed/);

// Blocking ends the friendship and shuts the door both ways.
await ask(b, 'friends/block', { userId: a.id });
assert.equal((await ask(a, 'friends/list')).friends.length, 0);
const room2 = await ask(a, 'lobby/create', { clientVersion: V });
await assert.rejects(ask(a, 'friends/invite', { userId: b.id, lobbyId: room2.lobby.id }), /only invite friends|cannot invite/);
await assert.rejects(ask(b, 'lobby/join', { code: room2.lobby.code, clientVersion: V }), /No open room/);
await assert.rejects(ask(a, 'friends/request', { name: b.name }), /exact name/);
lines = await ask(b, 'chat/list', { lobbyId: room.lobby.id });
assert.ok(!lines.some((l) => l.userId === a.id), 'a blocked player\'s lines are hidden');
assert.equal((await ask(b, 'friends/unblock', { userId: a.id })).blocked.length, 0);

// Account deletion removes the login and the name; matches stay for the other player.
await ask(c, 'tournament/start', { nationId: 'spain' });
await ask(c, 'friends/request', { name: a.name });
await ask(c, 'profile/deleteAccount');
// The access token is a stateless JWT that lives out its 10 minutes, but it is useless
// without a profile, and the refresh token is revoked with the account.
assert.equal(await ask(c, 'profile/me'), null);
await assert.rejects(ask(c, 'tournament/start', { nationId: 'spain' }), /display name/);
await assert.rejects(call('jwtRefresh/refreshAccessToken', { refreshToken: c.refresh }), /./);
assert.equal(await ask(a, 'profile/me').then((p) => p.displayName), a.name);
const rc = await ask(a, 'friends/list');
assert.ok(!rc.incoming.some((p) => p.userId === c.id), 'pending requests from a deleted user are gone');
const re = await call('emailIdp/login', { email: `cleo${run}@example.com`, password: 'Passw0rd!x' }).catch((e) => e);
assert.ok(re instanceof Error, 'a deleted account cannot sign in');
// The freed name can be taken again.
const again = await register(`cleo2${run}@example.com`);
await call('profile/createProfile', { displayName: c.name, acceptTerms: true }, again.token);

console.log('social smoke ok');
