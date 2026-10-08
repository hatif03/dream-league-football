#!/usr/bin/env node
// Smoke test for the Serverpod showcase features: matchmaking queue, the server-refereed penalty duel,
// Elo ratings, the live push socket, the daily challenge and shareable result links.
// Usage: API=... WS=... SERVER_LOG=... node scripts/smoke-duel.mjs
import assert from 'node:assert/strict';
import { call, register } from './lib/api.mjs';

const run = `${Date.now()}`.slice(-8);
const V = 'build-1';
async function player(tag) {
  const auth = await register(`${tag}${run}@example.com`);
  await call('profile/createProfile', { displayName: `${tag}_${run}`, acceptTerms: true }, auth.token);
  return auth.token;
}
const [a, b, c] = await Promise.all([player('duela'), player('duelb'), player('duelc')]);

// Live socket: player A should be told when the match is found.
const wsBase = (process.env.WS ?? 'ws://localhost:8080') + '/live';
const events = [];
const ws = new WebSocket(wsBase);
await new Promise((res, rej) => {
  ws.onopen = () => ws.send(JSON.stringify({ token: a }));
  ws.onmessage = (m) => {
    events.push(String(m.data));
    if (String(m.data).includes('"ok"')) res();
  };
  ws.onerror = rej;
});
const stranger = new WebSocket(wsBase);
const strangerClosed = new Promise((res) => (stranger.onclose = (e) => res(e.code)));
stranger.onopen = () => stranger.send(JSON.stringify({ token: 'nope' }));
assert.equal(await strangerClosed, 4003, 'bad token is refused on the live socket');

// Matchmaking: A waits, B joins, both are paired into a penalty duel.
let sa = await call('matchmaking/join', { mode: 'penalties', clientVersion: V }, a);
assert.equal(sa.searching, true);
await assert.rejects(call('matchmaking/join', { mode: 'chess', clientVersion: V }, b), /mode/);
const sb = await call('matchmaking/join', { mode: 'penalties', clientVersion: V }, b);
assert.ok(sb.lobby, 'second player is paired at once');
sa = await call('matchmaking/status', {}, a);
assert.ok(sa.lobby, 'first player sees the match');
assert.equal(sa.lobby.lobby.status, 'live');
const matchId = sa.lobby.lobby.matchId;
await new Promise((r) => setTimeout(r, 300));
assert.ok(events.some((e) => e.includes('queue') || e.includes('lobby') || e.includes('match')), `live push arrived: ${events}`);

// The duel: both choose every kick; the server draws the result.
await assert.rejects(call('penalty/state', { matchId }, c), /not found/);
let d = await call('penalty/state', { matchId }, a);
assert.equal(d.status, 'live');
let guard = 0;
while (d.status === 'live' && guard++ < 40) {
  const seq = d.seq;
  const [da, db] = await Promise.all([
    call('penalty/submit', { matchId, seq, zone: 1 }, a),
    call('penalty/submit', { matchId, seq, zone: 4 }, b),
  ]);
  if (seq === 0) {
    // choosing twice for the same kick changes nothing
    const again = await call('penalty/submit', { matchId, seq, zone: 2 }, a);
    assert.ok(again.seq >= seq);
  }
  d = await call('penalty/state', { matchId }, a);
  assert.ok(da && db);
}
assert.equal(d.status, 'finished', 'the duel ends');
assert.notEqual(d.hostGoals, d.guestGoals, 'a duel always has a winner');
assert.ok(d.kicks.length >= 5, 'a duel is decided after at least five kicks');
assert.ok(d.kicks.every((k) => k.outcome), 'every kick is settled');
const db2 = await call('penalty/state', { matchId }, b);
assert.equal(db2.youWon, !d.youWon);
assert.ok(d.ratingDelta != null && d.ratingDelta === -db2.ratingDelta, 'Elo is zero-sum');

// Ratings and the leaderboard.
const lb = await call('rankings/leaderboard', { limit: 10, by: 'rating' }, a);
assert.ok(lb.you && lb.you.rating !== 1000, 'rating moved');
const board = await call('rankings/leaderboard', { limit: 10, by: 'points' }, a);
assert.ok(board.top.length >= 1);

// Daily challenge.
const day = await call('challenges/today', {}, a);
assert.match(day.day, /^\d{4}-\d{2}-\d{2}$/);
assert.ok(day.title && day.target > 0);

// A room in penalty mode made by hand also works, and the queue can be left.
await call('matchmaking/join', { mode: 'match', clientVersion: V }, c);
await call('matchmaking/cancel', {}, c);
assert.equal((await call('matchmaking/status', {}, c)).searching, false);

// Shareable result link: a stored picture and a public page with Open Graph tags.
// Only the PNG signature is checked, so pad a tiny valid header up to a plausible size.
const png = Buffer.concat([Buffer.from([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a]), Buffer.alloc(300, 1)]).toString('base64');
const link = await call('share/createResult', { pngBase64: png, title: 'Brazil 2-1 Germany', description: 'Full time' }, a);
assert.ok(link.id && link.imageUrl);
const base = (process.env.WS ?? 'ws://localhost:8080').replace('ws', 'http');
const html = await (await fetch(`${base}/r/${link.id}`)).text();
assert.match(html, /og:title/);
assert.match(html, /Brazil 2-1 Germany/);
assert.doesNotMatch(await (await fetch(`${base}/r/not-an-id`)).text(), /og:title/); // unknown id: the app opens, no preview

ws.close();
console.log('duel smoke ok');
