#!/usr/bin/env node
// Plays a Round-of-32 game through the real UI: extra time, then a penalty shootout, then the
// saved result. Needs Vite on :5173, Serverpod on :8080 (dev) and SERVER_LOG.
import { chromium } from 'playwright-core';
import { existsSync, mkdirSync } from 'node:fs';
import assert from 'node:assert/strict';
import { call, register } from './lib/api.mjs';

const APP = process.env.APP ?? 'http://localhost:5173';
mkdirSync('.e2e-shots', { recursive: true });
const run = `${Date.now()}`.slice(-8);

// A player who already finished the group stage, through the API.
const auth = await register(`ko${run}@example.com`);
await call('profile/createProfile', { displayName: `KO_${run}`, acceptTerms: true }, auth.token);
let v = await call('tournament/start', { nationId: 'brazil' }, auth.token);
for (let i = 0; i < 3; i++) {
  const f = v.fixtures.find((x) => x.id === v.nextFixtureId);
  const home = f.homeNation === 'brazil';
  v = await call('tournament/submitResult', { tournamentId: v.tournament.id, fixtureId: f.id, nonce: `g${i}`, homeScore: home ? 2 : 0, awayScore: home ? 0 : 2 }, auth.token);
}
assert.equal(v.tournament.status, 'r32');

const exe = ['C:/Program Files/Google/Chrome/Application/chrome.exe', 'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe'].find(existsSync);
const browser = await chromium.launch({ executablePath: exe, headless: true });
const ctx = await browser.newContext({ viewport: { width: 1400, height: 900 } });
await ctx.addInitScript((a) => localStorage.setItem('wc2026.auth', JSON.stringify({ token: a.token, refreshToken: a.refreshToken, expiresAt: Date.parse(a.tokenExpiresAt) })), auth);
const page = await ctx.newPage();
const errors = [];
page.on('pageerror', (e) => errors.push(e.message));
page.on('console', (m) => m.type() === 'error' && errors.push(m.text()));

await page.goto(`${APP}/world-cup`);
await page.getByText(/Round of 32 · Match \d+/i).first().waitFor();
await page.waitForTimeout(800);
await page.screenshot({ path: '.e2e-shots/ko-hub.png' });
await page.getByRole('button', { name: /Play match/ }).click();
// Formation: pick 3-5-2 on the intro card and the engine lines the team up that way.
await page.getByRole('radio', { name: '3-5-2' }).click();
await page.getByRole('button', { name: /Kick off/ }).click();
await page.waitForFunction(() => window.__game?.current);
await page.waitForTimeout(1500);


// The CPU takes its own penalties and free kicks: award them and it must shoot.
const cpu = await page.evaluate(async () => {
  const h = window.__game.current;
  const out = {};
  for (const kind of ['penalty', 'freekick']) {
    h.resetKickoff('home');
    await new Promise((r) => setTimeout(r, 1100));
    const before = h.tally.away.shots;
    if (kind === 'penalty') h.awardPenalty('away', 0, 1);
    else {
      const v = h.awayPlayers[9];
      v.x = 700; v.y = 560;
      h.awardRestart('away', 700, 560, 'FOUL', false, false);
      h.buildWall('home', 700, 560, 0);
      h.beginSetPiece();
    }
    await new Promise((r) => setTimeout(r, 4500));
    out[kind] = h.tally.away.shots - before;
  }
  return out;
});
assert.ok(cpu.penalty >= 1, 'the CPU took the penalty (' + JSON.stringify(cpu) + ')');
console.log('cpu set pieces:', JSON.stringify(cpu));

// Half-time: crossing 45 minutes pauses play with a banner and a fresh kick-off.
assert.equal(await page.evaluate(() => window.__game.current.homeTeam.formation), '3-5-2');
await page.evaluate(() => { window.__game.current.elapsed = 89.5; });
await page.getByText(/half time/i).first().waitFor({ timeout: 8000 });
await page.waitForTimeout(3000);

// Make it 0-0 with a minute to go: the game must go to extra time, not end.
await page.evaluate(() => { const g = window.__game.current; g.homeScore = 0; g.awayScore = 0; g.elapsed = 179; });
await page.getByText(/extra time/i).first().waitFor({ timeout: 15000 });
await page.waitForTimeout(3500);
const clock = await page.evaluate(() => window.__game.current.elapsed);
assert.ok(clock > 179, 'the clock keeps running into extra time');
await page.evaluate(() => { window.__game.current.elapsed = 239; });

// Still level: penalties.
await page.getByText(/penalty shootout/i).first().waitFor({ timeout: 20000 });
await page.screenshot({ path: '.e2e-shots/ko-shootout.png' });
// The shootout screen unmounts the moment it is done, so a missing state means it finished.
const state = () => page.evaluate(() => window.__shoot?.current?.snapshotState() ?? null);
const t0 = Date.now();
let last = null;
while (Date.now() - t0 < 120000) {
  const s = await state();
  if (!s) { if (last) break; await page.waitForTimeout(150); continue; }
  last = s;
  if (s.phase === 'done') break;
  if (s.phase === 'aim' && s.turn === 'home') {
    await page.keyboard.down('ArrowUp'); await page.waitForTimeout(250); await page.keyboard.up('ArrowUp');
    await page.keyboard.down('KeyD'); await page.waitForTimeout(220); await page.keyboard.up('KeyD');
  } else if (s.phase === 'aim' && s.turn === 'away') {
    await page.keyboard.down('ArrowDown'); await page.waitForTimeout(2600); await page.keyboard.up('ArrowDown');
  }
  await page.waitForTimeout(150);
}
assert.ok(last, 'the shootout ran');
console.log('shootout last state:', last.phase, last.homeGoals, '-', last.awayGoals);

await page.getByText(/Result saved/).waitFor({ timeout: 20000 });
await page.screenshot({ path: '.e2e-shots/ko-saved.png' });
const cur0 = await call('tournament/current', {}, auth.token);
const m0 = cur0.fixtures.find((f) => f.round === 'r32' && f.playedByUser);
const userWon = (m0.homeNation === 'brazil') === (m0.homePens > m0.awayPens);
await page.getByRole('button', { name: /Continue/ }).click();
await page.getByText(userWon ? /Round of 16/i : /out in the round of 32/i).first().waitFor({ timeout: 10000 });

// The server has the shootout recorded and the rest of the round settled.
const cur = await call('tournament/current', {}, auth.token);
const played = cur.fixtures.filter((f) => f.round === 'r32');
assert.equal(played.length, 16);
assert.ok(played.every((f) => f.homeScore != null));
const mine = played.find((f) => f.playedByUser);
assert.equal(mine.homeScore, mine.awayScore, 'level after extra time');
assert.ok(mine.homePens != null && mine.homePens !== mine.awayPens, 'with a shootout winner');
assert.equal(cur.tournament.status, userWon ? 'r16' : 'eliminated');
assert.deepEqual(errors.filter((e) => !/favicon|Failed to load resource/.test(e)), []);
await browser.close();
console.log('knockout e2e ok');
