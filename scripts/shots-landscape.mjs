#!/usr/bin/env node
// Phone-landscape screenshots of the match flow. SERVER_LOG=... node scripts/shots-landscape.mjs
import { chromium } from 'playwright-core';
import { existsSync, mkdirSync } from 'node:fs';
import { call, register } from './lib/api.mjs';
const APP = process.env.APP ?? 'http://localhost:5173';
const OUT = '.e2e-shots/ui';
mkdirSync(OUT, { recursive: true });
const exe = ['C:/Program Files/Google/Chrome/Application/chrome.exe', 'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe'].find(existsSync);
const browser = await chromium.launch({ executablePath: exe, headless: true });
const run = `${Date.now()}`.slice(-8);
const auth = await register(`land${run}@example.com`);
await call('profile/createProfile', { displayName: `Land_${run}`, acceptTerms: true }, auth.token);
const ctx = await browser.newContext({ viewport: { width: 844, height: 390 }, isMobile: true, hasTouch: true, deviceScaleFactor: 2 });
await ctx.addInitScript((a) => localStorage.setItem('wc2026.auth', JSON.stringify({ token: a.token, refreshToken: a.refreshToken, expiresAt: Date.parse(a.tokenExpiresAt) })), auth);
const page = await ctx.newPage();
const shot = async (n) => { await page.waitForTimeout(700); await page.screenshot({ path: `${OUT}/land-${n}.png` }); };
await page.goto(APP); await shot('1-home');
await page.goto(`${APP}/practice`); await shot('2-practice');
await page.getByRole('button', { name: /Start practice/ }).click(); await page.getByRole('button', { name: /Kick off/ }).waitFor(); await shot('3-intro');
await page.getByRole('button', { name: /Kick off/ }).click().catch(() => {});
await page.waitForTimeout(2500); await shot('4-playing');
await page.getByRole('button', { name: 'Pause menu' }).click(); await shot('5-pause');
await browser.close();
