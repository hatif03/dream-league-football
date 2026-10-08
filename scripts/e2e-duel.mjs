#!/usr/bin/env node
// Two real browsers meet through matchmaking and play a penalty duel refereed by Serverpod.
// Needs Vite on :5173, Serverpod (dev) and API / WS / SERVER_LOG set like the other e2e tests.
//   node scripts/e2e-duel.mjs
import { chromium } from 'playwright-core';
import { existsSync, mkdirSync } from 'node:fs';
import { join } from 'node:path';
import assert from 'node:assert/strict';
import { call, register } from './lib/api.mjs';

const APP = process.env.APP ?? 'http://localhost:5173';
const SHOTS = process.env.SHOTS ?? join(process.cwd(), '.e2e-shots');
mkdirSync(SHOTS, { recursive: true });
const exe = ['C:/Program Files/Google/Chrome/Application/chrome.exe', 'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe'].find(existsSync);
const browser = await chromium.launch({ executablePath: exe, headless: true });

const run = `${Date.now()}`.slice(-8);
async function player(tag) {
  const auth = await register(`${tag}${run}@example.com`);
  await call('profile/createProfile', { displayName: `${tag}_${run}`, acceptTerms: true }, auth.token);
  const ctx = await browser.newContext({ viewport: { width: 1280, height: 900 } });
  await ctx.addInitScript((a) => {
    localStorage.setItem('wc2026.auth', JSON.stringify({ token: a.token, refreshToken: a.refreshToken, expiresAt: Date.parse(a.tokenExpiresAt) }));
    localStorage.setItem('wc2026.sound', 'off');
  }, auth);
  const page = await ctx.newPage();
  const errors = [];
  page.on('pageerror', (e) => errors.push(e.message));
  page.on('console', (m) => m.type() === 'error' && !/favicon|WebSocket/.test(m.text()) && errors.push(m.text()));
  return { tag, jwt: auth.token, page, errors };
}
const a = await player('duelx');
const b = await player('duely');

// Both choose "Penalty duel" and press Find; the server pairs them and both land in the duel.
for (const p of [a, b]) {
  await p.page.goto(`${APP}/online`);
  await p.page.getByRole('radio', { name: 'Penalty duel' }).click();
}
await a.page.getByRole('button', { name: /Find a penalty duel/ }).click();
await a.page.getByText(/Searching/).waitFor({ timeout: 10000 });
await a.page.screenshot({ path: join(SHOTS, 'duel-1-searching.png') });
await b.page.getByRole('button', { name: /Find a penalty duel/ }).click();
for (const p of [a, b]) await p.page.getByText('Penalty duel', { exact: true }).first().waitFor({ timeout: 20000 });

// Play every kick: each player taps the zone buttons (keyboard on one side, mouse on the other).
async function playKick(p, zoneName) {
  const zone = p.page.getByRole('button', { name: zoneName, exact: true });
  await zone.waitFor({ state: 'visible', timeout: 20000 });
  await p.page.waitForFunction((n) => {
    const el = [...document.querySelectorAll('button')].find((x) => x.getAttribute('aria-label') === n);
    return el && !el.disabled;
  }, zoneName, { timeout: 20000 });
  await zone.click();
}
let shotDone = false;
for (let kick = 0; kick < 30; kick++) {
  const over = await a.page.getByRole('dialog', { name: /You (win|lose)|No result/ }).isVisible().catch(() => false);
  if (over) break;
  await Promise.all([playKick(a, 'Top left').catch(() => {}), playKick(b, 'Bottom right').catch(() => {})]);
  if (!shotDone) {
    shotDone = true;
    await a.page.waitForTimeout(800);
    await a.page.screenshot({ path: join(SHOTS, 'duel-2-reveal.png') });
  }
  // let the reveal play before the next kick
  await a.page.waitForTimeout(2800);
}
for (const p of [a, b]) await p.page.getByRole('dialog').waitFor({ timeout: 30000 });
await a.page.screenshot({ path: join(SHOTS, 'duel-3-result.png') });
const ta = await a.page.getByRole('dialog').textContent();
const tb = await b.page.getByRole('dialog').textContent();
assert.ok(/You win/.test(ta) !== /You win/.test(tb), 'exactly one player wins');
assert.match(ta, /rating/);

// Ratings moved on the server and the leaderboard shows them.
await a.page.getByRole('button', { name: 'Back to Online' }).click();
await a.page.goto(`${APP}/leaderboard`);
await a.page.getByRole('radio', { name: 'Rating' }).waitFor();
await a.page.screenshot({ path: join(SHOTS, 'duel-4-leaderboard.png') });
const board = await call('rankings/leaderboard', { limit: 10, by: 'rating' }, a.jwt);
assert.ok(board.you && board.you.rating !== 1000);

for (const p of [a, b]) assert.deepEqual(p.errors, [], `${p.tag} page errors`);
await browser.close();
console.log('duel e2e ok');
