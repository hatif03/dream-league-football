#!/usr/bin/env node
// Screenshots of every screen at desktop and phone sizes, for design review.
//   SERVER_LOG=... node scripts/shots.mjs [outdir]
import { chromium } from 'playwright-core';
import { existsSync, mkdirSync } from 'node:fs';
import { join } from 'node:path';
import { call, register } from './lib/api.mjs';

const APP = process.env.APP ?? 'http://localhost:5173';
const OUT = process.argv[2] ?? '.e2e-shots/ui';
mkdirSync(OUT, { recursive: true });
const exe = ['C:/Program Files/Google/Chrome/Application/chrome.exe', 'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe'].find(existsSync);
const browser = await chromium.launch({ executablePath: exe, headless: true });

const run = `${Date.now()}`.slice(-8);
const auth = await register(`shots${run}@example.com`);
await call('profile/createProfile', { displayName: `Shots_${run}`, acceptTerms: true }, auth.token);
await call('profile/updateProfile', { favouriteNation: 'brazil' }, auth.token);

await call('tournament/start', { nationId: 'brazil' }, auth.token);

const sizes = { desktop: { width: 1440, height: 900 }, phone: { width: 390, height: 844, isMobile: true, hasTouch: true, deviceScaleFactor: 2 } };
const errors = [];

for (const [name, vp] of Object.entries(sizes)) {
  const ctx = await browser.newContext({ viewport: { width: vp.width, height: vp.height }, isMobile: vp.isMobile, hasTouch: vp.hasTouch, deviceScaleFactor: vp.deviceScaleFactor });
  const page = await ctx.newPage();
  page.on('pageerror', (e) => errors.push(`${name}: ${e.message}`));
  page.on('console', (m) => m.type() === 'error' && errors.push(`${name}: ${m.text()}`));
  const shot = async (n) => {
    await page.waitForTimeout(700);
    await page.screenshot({ path: join(OUT, `${name}-${n}.png`) });
  };

  // signed out
  await page.goto(APP);
  await shot('01-home-out');
  await page.goto(`${APP}/login`);
  await shot('02-login');
  await page.goto(`${APP}/signup`);
  await shot('03-signup');
  await page.goto(`${APP}/practice`);
  await shot('04-practice');
  await page.goto(`${APP}/settings`);
  await shot('05-settings');

  // sign in
  await page.addInitScript((a) => localStorage.setItem('wc2026.auth', JSON.stringify({ token: a.token, refreshToken: a.refreshToken, expiresAt: Date.parse(a.tokenExpiresAt) })), auth);
  await page.goto(APP);
  await shot('10-home-in');
  await page.goto(`${APP}/world-cup`);
  await shot('11-wc-select');
  await page.goto(`${APP}/online`);
  await shot('12-online');
  await page.goto(`${APP}/profile`);
  await shot('13-profile');
  await page.goto(`${APP}/world-cup`);
  await shot('14-wc-hub');
  await page.getByRole('button', { name: /Play match/ }).click();
  await page.getByRole('button', { name: /Kick off/ }).waitFor();
  await shot('15-intro');
  await page.getByRole('button', { name: /Kick off/ }).click();
  await page.waitForTimeout(2500);
  await shot('16-playing');
  const anyway = page.getByRole('button', { name: 'Play anyway' });
  if (await anyway.isVisible()) await anyway.click();
  await page.getByRole('button', { name: 'Pause menu' }).click();
  await shot('17-pause');
  await ctx.close();
}
await browser.close();
console.log('errors:', errors.filter((e) => !/favicon|Failed to load resource/.test(e)).slice(0, 8));
