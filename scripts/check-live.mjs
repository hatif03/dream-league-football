#!/usr/bin/env node
// Checks the deployed site in a real browser: the app loads from the web host, the
// front page renders, World Cup bounces a signed-out visitor to sign-in, and the
// page can reach the API across origins (a wrong password must come back as an error).
//   APP=https://football.serverpod.space node scripts/check-live.mjs
import { chromium } from 'playwright-core';
import { existsSync, mkdirSync } from 'node:fs';
import assert from 'node:assert/strict';

const APP = process.env.APP ?? 'https://football.serverpod.space';
mkdirSync('.e2e-shots', { recursive: true });
const exe = ['C:/Program Files/Google/Chrome/Application/chrome.exe', 'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe'].find(existsSync);
const browser = await chromium.launch({ executablePath: exe, headless: true });
const page = await browser.newPage({ viewport: { width: 1400, height: 900 } });
const errors = [];
page.on('pageerror', (e) => errors.push(e.message));
page.on('console', (m) => m.type() === 'error' && errors.push(m.text()));

await page.goto(APP);
await page.getByRole('heading', { level: 1 }).first().waitFor();
console.log('title:', await page.title());
await page.getByRole('link', { name: 'Sign in' }).first().waitFor();

// Deep links work on the web host (single-page fallback) and a signed-out visitor is sent to sign-in.
await page.goto(APP + '/world-cup');
await page.waitForURL(/\/login/);
await page.goto(APP + '/online?join=ABCDE');
await page.waitForURL(/\/login/);

await page.getByLabel('Email').fill('nobody@example.com');
await page.locator('input[autocomplete=current-password]').fill('wrongwrong1');
await page.getByRole('button', { name: 'Sign in', exact: true }).click();
await page.getByRole('alert').first().waitFor({ timeout: 15000 });
const msg = (await page.getByRole('alert').allInnerTexts()).join(' | ');
console.log('error shown:', msg);
assert.ok(!/Cannot reach/i.test(msg), 'the page must reach the API');
await page.screenshot({ path: '.e2e-shots/live-login.png' });
assert.deepEqual(errors.filter((e) => !/favicon|401|403|400|Failed to load resource/.test(e)), []);
await browser.close();
console.log('live check ok');
