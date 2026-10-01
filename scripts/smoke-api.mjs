#!/usr/bin/env node
// Account + World Cup smoke test. Usage: SERVER_LOG=/path/to/server.log node scripts/smoke-api.mjs
import assert from 'node:assert/strict';
import { call, register } from './lib/api.mjs';

const run = `${Date.now()}`.slice(-8);
const auth = await register(`smoke${run}@example.com`);
const jwt = auth.token;
assert.ok(auth.refreshToken, 'refresh token expected');

const refreshed = await call('jwtRefresh/refreshAccessToken', { refreshToken: auth.refreshToken });
assert.ok(refreshed.token, 'refresh works');

assert.equal(await call('profile/me', {}, jwt), null);
const me = await call('profile/createProfile', { displayName: `Smoke_${run}`, acceptTerms: true }, jwt);
assert.equal(me.displayNameLower, `smoke_${run}`);

let v = await call('tournament/start', { nationId: 'brazil' }, jwt);
assert.equal(v.fixtures.length, 72);
assert.equal(v.standings.length, 48);
await assert.rejects(call('tournament/start', { nationId: 'france' }, jwt), /already in progress/);

for (let md = 1; md <= 3; md++) {
  const f = v.fixtures.find((x) => x.id === v.nextFixtureId);
  assert.equal(f.matchday, md);
  v = await call(
    'tournament/submitResult',
    { tournamentId: v.tournament.id, fixtureId: f.id, nonce: `n${md}`, homeScore: f.homeNation === 'brazil' ? 2 : 1, awayScore: f.homeNation === 'brazil' ? 1 : 2 },
    jwt,
  );
  const done = v.fixtures.filter((x) => x.homeScore != null);
  assert.equal(done.length, md * 24, `after matchday ${md} exactly ${md * 24} games are filled`);
  assert.ok(done.every((x) => x.matchday <= md), 'no later matchday was simulated early');
  if (md === 1) {
    // idempotent resend, and a forged second post is rejected
    const again = await call(
      'tournament/submitResult',
      { tournamentId: v.tournament.id, fixtureId: f.id, nonce: 'n1', homeScore: f.homeNation === 'brazil' ? 2 : 1, awayScore: f.homeNation === 'brazil' ? 1 : 2 },
      jwt,
    );
    assert.equal(again.fixtures.filter((x) => x.homeScore != null).length, 24);
    await assert.rejects(
      call('tournament/submitResult', { tournamentId: v.tournament.id, fixtureId: f.id, nonce: 'other', homeScore: 9, awayScore: 0 }, jwt),
      /already played|order/,
    );
  }
}
// Group stage over: nine points puts Brazil through to the Round of 32.
assert.equal(v.tournament.status, 'r32');
assert.equal(v.standings.filter((s) => s.qualified).length, 32);
assert.equal(v.fixtures.filter((f) => f.round === 'r32').length, 16);
const mine = v.tournament.nationId;

// Knockouts: a level game needs a shootout winner, and groups never have one.
const rounds = [['r32', 16], ['r16', 8], ['qf', 4], ['sf', 2], ['final', 1]];
for (const [round, count] of rounds) {
  assert.equal(v.tournament.status, round);
  assert.equal(v.fixtures.filter((f) => f.round === round).length, count);
  const f = v.fixtures.find((x) => x.id === v.nextFixtureId);
  assert.equal(f.round, round);
  const body = (extra) => ({ tournamentId: v.tournament.id, fixtureId: f.id, nonce: `ko-${round}`, homeScore: 1, awayScore: 1, ...extra });
  await assert.rejects(call('tournament/submitResult', body(), jwt), /needs a winner/);
  await assert.rejects(call('tournament/submitResult', body({ homePens: 4, awayPens: 4 }), jwt), /needs a winner/);
  // The player wins on penalties, whichever side of the draw they are on.
  const userHome = f.homeNation === mine;
  v = await call('tournament/submitResult', body({ homePens: userHome ? 5 : 3, awayPens: userHome ? 3 : 5, decidedBy: 'pens' }), jwt);
  const played = v.fixtures.filter((x) => x.round === round);
  assert.ok(played.every((x) => x.homeScore != null), `${round}: every tie of the round is settled`);
  assert.ok(played.every((x) => x.homeScore !== x.awayScore || (x.homePens != null && x.homePens !== x.awayPens)), `${round}: no tie without a winner`);
}
assert.equal(v.tournament.status, 'champion');
assert.equal(v.nextFixtureId ?? null, null);
// A finished run may be replaced by a new one.
assert.equal((await call('tournament/start', { nationId: 'spain' }, jwt)).tournament.status, 'group');
console.log('smoke ok:', v.tournament.status);
