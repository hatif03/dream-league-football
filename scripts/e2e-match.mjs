#!/usr/bin/env node
// Match upgrades in a friendly against the CPU: commentary captions, the goal replay (and skipping it),
// added time at 90 minutes, and the settings that switch replays and commentary off.
// Needs Vite on :5173, Serverpod and API / WS / SERVER_LOG set like the other e2e tests.
import { chromium } from 'playwright-core';
import { existsSync, mkdirSync } from 'node:fs';
import assert from 'node:assert/strict';
import { call, register } from './lib/api.mjs';

const APP = process.env.APP ?? 'http://localhost:5173';
mkdirSync('.e2e-shots', { recursive: true });
const run = `${Date.now()}`.slice(-8);
const exe = ['C:/Program Files/Google/Chrome/Application/chrome.exe', 'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe'].find(existsSync);
const browser = await chromium.launch({ executablePath: exe, headless: true });
const auth = await register(`match${run}@example.com`);
await call('profile/createProfile', { displayName: `Match_${run}`, acceptTerms: true }, auth.token);
const errors = [];
const ctx = await browser.newContext({ viewport: { width: 1400, height: 900 } });
await ctx.addInitScript((a) => {
  localStorage.setItem('wc2026.auth', JSON.stringify({ token: a.token, refreshToken: a.refreshToken, expiresAt: Date.parse(a.tokenExpiresAt) }));
  localStorage.setItem('wc2026.tutorialDone', '1');
}, auth);
const page = await ctx.newPage();
page.on('pageerror', (e) => errors.push(e.message));
page.on('console', (m) => m.type() === 'error' && errors.push(m.text()));

async function startFriendly() {
  await page.goto(`${APP}/practice`);
  await page.getByRole('radio', { name: '11 v 11 friendly' }).click();
  await page.getByLabel(/If it is level after 90/).uncheck();
  await page.getByRole('button', { name: /Start friendly/ }).click();
  await page.getByRole('button', { name: /Kick off/ }).click();
  await page.waitForFunction(() => window.__game?.current);
  await page.waitForTimeout(2500); // a couple of seconds of play for the replay to record
}

// ---- a goal: commentary, celebration, then the replay ------------------------------------------
await startFriendly();
await page.evaluate(() => {
  const g = window.__game.current;
  g.owner = null;
  g.awayPlayers[0].x = 1000; // the keeper is out of the way
  g.awayPlayers[0].y = 300;
  g.ball.x = 2200 + 3; // FIELD_W + 3: over the line, in the right-hand goal
  g.ball.y = 1425 / 2;
  g.ball.vx = 0;
  g.ball.vy = 0;
  g.ball.z = 0;
  g.lastKicker = g.controlled;
  g.kickerLock = 1;
});
await page.getByRole('status').filter({ hasText: /GOAL|scores|It's in/i }).first().waitFor({ timeout: 8000 });
console.log('commentary shows the goal');
await page.getByText('Replay', { exact: true }).waitFor({ timeout: 10000 });
await page.screenshot({ path: '.e2e-shots/replay.png' });
const scoreBefore = await page.evaluate(() => window.__game.current.homeScore);
assert.equal(scoreBefore, 1, 'the goal counted once');
await page.keyboard.press('Space'); // any key skips
await page.getByText('Replay', { exact: true }).waitFor({ state: 'detached', timeout: 3000 });
const afterSkip = await page.evaluate(() => ({ replay: !!window.__game.current.replay, score: window.__game.current.homeScore, owner: window.__game.current.owner?.team }));
assert.equal(afterSkip.replay, false);
assert.equal(afterSkip.score, 1, 'skipping does not change the score');
console.log('replay played and skipped');

// ---- added time at 90 minutes -----------------------------------------------------------------
await page.evaluate(() => { window.__game.current.elapsed = 179.8; });
await page.getByText(/ADDED TIME/).first().waitFor({ timeout: 5000 });
const added = await page.evaluate(() => window.__game.current.addedMins);
assert.ok(added >= 2, `a goal adds time (got ${added})`);
await page.screenshot({ path: '.e2e-shots/added-time.png' });
await page.getByRole('button', { name: 'Play again' }).waitFor({ timeout: 30000 });
console.log('added time ok');

// ---- settings: replays and commentary can be switched off -------------------------------------
await page.goto(`${APP}/settings`);
await page.getByRole('tab', { name: /Gameplay/ }).click().catch(() => page.getByText('Gameplay', { exact: true }).first().click());
const replaySwitch = page.getByRole('switch').nth(0);
const captionSwitch = page.getByRole('switch').nth(1);
await replaySwitch.click();
await captionSwitch.click();
assert.equal(await page.evaluate(() => [localStorage.getItem('wc2026.replays'), localStorage.getItem('wc2026.commentary')].join()), '0,0');
await startFriendly();
await page.evaluate(() => {
  const g = window.__game.current;
  g.owner = null;
  g.awayPlayers[0].x = 1000; // the keeper is out of the way
  g.awayPlayers[0].y = 300;
  g.ball.x = 2200 + 3;
  g.ball.y = 1425 / 2;
  g.ball.vx = 0;
  g.ball.z = 0;
  g.lastKicker = g.controlled;
  g.kickerLock = 1;
});
await page.waitForTimeout(6500);
assert.equal(await page.getByText('Replay', { exact: true }).count(), 0, 'no replay when switched off');
console.log('settings ok');

assert.deepEqual(errors, [], 'no page errors');
await browser.close();
console.log('match e2e ok');
