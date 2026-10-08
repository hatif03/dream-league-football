#!/usr/bin/env node
// The "extras": 11 v 11 friendly with a share card, the tutorial, the club editor and its kit,
// settings that follow the account, the app manifest and the leaderboard page.
// Needs Vite on :5173, Serverpod on :8080 (dev) and SERVER_LOG.
import { chromium } from 'playwright-core';
import { existsSync, mkdirSync } from 'node:fs';
import assert from 'node:assert/strict';
import { call, register } from './lib/api.mjs';

const APP = process.env.APP ?? 'http://localhost:5173';
mkdirSync('.e2e-shots', { recursive: true });
const run = `${Date.now()}`.slice(-8);
const exe = ['C:/Program Files/Google/Chrome/Application/chrome.exe', 'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe'].find(existsSync);
const browser = await chromium.launch({ executablePath: exe, headless: true });

const auth = await register(`extra${run}@example.com`);
await call('profile/createProfile', { displayName: `Extra_${run}`, acceptTerms: true }, auth.token);
const errors = [];
const open = async (tag = '') => {
  const ctx = await browser.newContext({ viewport: { width: 1400, height: 900 }, acceptDownloads: true });
  await ctx.addInitScript(
    (a) => {
      localStorage.setItem('wc2026.auth', JSON.stringify({ token: a.token, refreshToken: a.refreshToken, expiresAt: Date.parse(a.tokenExpiresAt) }));
    },
    auth,
  );
  const page = await ctx.newPage();
  page.on('pageerror', (e) => errors.push(`${tag}${e.message}`));
  page.on('console', (m) => m.type() === 'error' && errors.push(`${tag}${m.text()}`));
  return { ctx, page };
};

// ---- the app manifest and icons are served ------------------------------------------------
{
  const man = await (await fetch(`${APP}/manifest.json`)).json();
  assert.equal(man.name, 'Dream League Football');
  for (const i of man.icons) assert.equal((await fetch(APP + i.src)).status, 200, `${i.src} is served`);
  console.log('manifest ok');
}

// ---- a friendly: full teams, half-time, full time, share card --------------------------------
const { ctx, page } = await open();
await page.goto(`${APP}/practice`);
await page.getByRole('radio', { name: '11 v 11 friendly' }).click();
await page.getByLabel(/If it is level after 90/).uncheck(); // this run wants a plain full time
await page.getByRole('button', { name: /Start friendly/ }).click();
await page.getByRole('button', { name: /Kick off/ }).click();
await page.waitForFunction(() => window.__game?.current);
const sizes = await page.evaluate(() => [window.__game.current.homePlayers.length, window.__game.current.awayPlayers.length]);
assert.deepEqual(sizes, [11, 11], 'a friendly is 11 v 11');
await page.evaluate(() => { window.__game.current.elapsed = 89.5; });
await page.getByText(/half time/i).first().waitFor({ timeout: 8000 });
await page.waitForTimeout(3000);
await page.evaluate(() => { window.__game.current.elapsed = 179.7; });
await page.getByRole('button', { name: 'Play again' }).waitFor({ timeout: 20000 });
// Signed in on a computer: the card is stored with Serverpod and a link to its preview page is copied.
await ctx.grantPermissions(['clipboard-read', 'clipboard-write']);
await page.getByRole('button', { name: 'Share result' }).click();
await page.getByText(/Link copied/).waitFor({ timeout: 15000 });
const link = await page.evaluate(() => navigator.clipboard.readText());
assert.match(link, /\/r\/[0-9a-f-]{36}$/);
const preview = await (await fetch(link)).text();
assert.match(preview, /og:title/);
const img = preview.match(/og:image" content="([^"]+)"/)[1].replace(/&amp;/g, '&');
const imgRes = await fetch(img);
assert.equal(imgRes.status, 200, 'the stored picture is public');
assert.equal(imgRes.headers.get('content-type'), 'image/png');
console.log('friendly + share link ok');
await page.getByRole('button', { name: 'Back' }).click();

// ---- a standalone penalty shootout, played to the end --------------------------------------------
await page.goto(`${APP}/practice`);
await page.getByRole('radio', { name: 'Penalty shootout' }).click();
await page.getByRole('button', { name: /Start shootout/ }).click();
await page.getByRole('button', { name: /Kick off/ }).click();
await page.waitForFunction(() => window.__shoot?.current);
{
  const t0 = Date.now();
  let last = null;
  while (Date.now() - t0 < 150000) {
    const st = await page.evaluate(() => window.__shoot?.current?.snapshotState() ?? null);
    if (!st) { if (last) break; await page.waitForTimeout(150); continue; }
    last = st;
    if (st.phase === 'done') break;
    if (st.phase === 'aim' && st.turn === 'home') {
      await page.keyboard.down('ArrowUp'); await page.waitForTimeout(250); await page.keyboard.up('ArrowUp');
      await page.keyboard.down('KeyD'); await page.waitForTimeout(220); await page.keyboard.up('KeyD');
    } else if (st.phase === 'aim' && st.turn === 'away') {
      await page.keyboard.down('ArrowDown'); await page.waitForTimeout(2600); await page.keyboard.up('ArrowDown');
    }
    await page.waitForTimeout(150);
  }
  assert.ok(last, 'the shootout ran');
}
await page.getByRole('button', { name: 'Play again' }).waitFor({ timeout: 20000 });
console.log('penalty mode ok');
await page.getByRole('button', { name: 'Back' }).click();

// ---- the tutorial moves on as you do each thing ------------------------------------------------
await page.goto(`${APP}/practice`);
await page.getByRole('button', { name: 'Learn the basics' }).click();
await page.getByRole('button', { name: /Kick off/ }).click();
await page.getByText('Step 1 of 7').waitFor();
await page.keyboard.down('ArrowRight');
await page.getByText('Step 2 of 7').waitFor({ timeout: 15000 });
await page.keyboard.up('ArrowRight');
await page.getByRole('button', { name: 'Skip tutorial' }).click();
await page.getByRole('region', { name: 'Tutorial' }).waitFor({ state: 'detached' });
console.log('tutorial ok');

// ---- the club editor saves, shows up, and the kit is worn ----------------------------------------
await page.goto(`${APP}/club`);
await page.getByLabel('Club name').fill('Test FC');
await page.getByRole('radio', { name: 'hex' }).click();
await page.getByRole('button', { name: 'Shirt #e63946' }).click();
await page.getByLabel(/Wear this kit/).check();
await page.getByRole('button', { name: 'Save club' }).click();
await page.getByText('Club saved').waitFor();
await page.goto(`${APP}/profile`);
await page.getByText('Test FC').first().waitFor();
await page.getByRole('heading', { name: /^Achievements/ }).waitFor();
await page.goto(`${APP}/practice`);
await page.getByRole('radio', { name: '11 v 11 friendly' }).click();
await page.getByRole('button', { name: /Start friendly/ }).click();
await page.waitForFunction(() => window.__game?.current);
const shirt = await page.evaluate(() => window.__game.current.homeTeam.kit.shirt);
assert.equal(shirt.toLowerCase(), '#e63946', 'the club kit is worn');
console.log('club ok');

// ---- settings follow the account ---------------------------------------------------------------------
await call('profile/saveSettings', { json: JSON.stringify({ 'wc2026.difficulty': 'hard', 'wc2026.matchSecs': '300' }) }, auth.token);
const { ctx: ctx2, page: page2 } = await open('second device: ');
await page2.goto(`${APP}/settings`);
await page2.waitForFunction(() => localStorage.getItem('wc2026.difficulty') === 'hard', null, { timeout: 15000 });
await page2.getByRole('tab', { name: 'gameplay' }).click();
assert.equal(await page2.getByRole('radio', { name: 'hard' }).getAttribute('aria-checked'), 'true', 'the new device shows the account difficulty');
// ... and a change made here is saved back
await page2.getByRole('radio', { name: 'easy' }).click();
await page2.waitForTimeout(2500);
const me = await call('profile/me', {}, auth.token);
assert.equal(JSON.parse(me.settings)['wc2026.difficulty'], 'easy', 'a change is saved to the account');
console.log('settings sync ok');
await ctx2.close();

// ---- leaderboard page ---------------------------------------------------------------------------------
await page.goto(`${APP}/leaderboard`);
await page.getByRole('heading', { name: 'Leaderboard' }).waitFor();
await page.screenshot({ path: '.e2e-shots/leaderboard.png' });
await ctx.close();

assert.deepEqual(errors.filter((e) => !/favicon|Failed to load resource/.test(e)), []);
await browser.close();
console.log('extras e2e ok');
