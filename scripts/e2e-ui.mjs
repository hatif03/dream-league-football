#!/usr/bin/env node
// Browser end-to-end test: sign up, pick a nation, play a World Cup match to full
// time, and check the result is saved. Needs Vite on :5173, Serverpod on :8080
// (dev mode) and SERVER_LOG pointing at the server's stdout log.
//   SERVER_LOG=... node scripts/e2e-ui.mjs [--quick]    (--quick skips the 3-minute match)
import { chromium } from 'playwright-core';
import { readFileSync, mkdirSync } from 'node:fs';
import { join } from 'node:path';
import assert from 'node:assert/strict';

const APP = process.env.APP ?? 'http://localhost:5173';
const LOG = process.env.SERVER_LOG;
const SHOTS = process.env.SHOTS ?? join(process.cwd(), '.e2e-shots');
const quick = process.argv.includes('--quick');
mkdirSync(SHOTS, { recursive: true });

const chromePath = ['C:/Program Files/Google/Chrome/Application/chrome.exe', 'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe'];
const { existsSync } = await import('node:fs');
const browser = await chromium.launch({ executablePath: chromePath.find(existsSync), headless: true });
const page = await browser.newPage({ viewport: { width: 1500, height: 900 } });
const errors = [];
page.on('pageerror', (e) => errors.push(e.message));
page.on('console', (m) => m.type() === 'error' && errors.push(m.text()));
const shot = async (n) => {
  await page.waitForTimeout(800); // let fade-in animations finish
  await page.screenshot({ path: join(SHOTS, `${n}.png`) });
};

const email = `e2e${Date.now()}@example.com`;
const name = `E2E_${String(Date.now()).slice(-7)}`;

// 1. Front page, World Cup bounces a signed-out user to login.
await page.goto(APP);
await page.getByRole('heading', { level: 1 }).first().waitFor();
await shot('1-front');
await page.goto(`${APP}/world-cup`);
await page.waitForURL(/\/login/);

// 2. Sign up with the emailed code (dev prints it in the server log).
await page.goto(`${APP}/signup`);
await page.getByLabel('Email').fill(email);
await page.getByRole('button', { name: 'Send me a code' }).click();
await page.getByLabel('Verification code').waitFor();
await page.waitForTimeout(500);
const code = [...readFileSync(LOG, 'utf8').matchAll(new RegExp(`Registration code for ${email}: <(\\d+)>`, 'g'))].at(-1)?.[1];
assert.ok(code, 'code not in server log');
await page.getByLabel('Verification code').fill(code);
await page.locator('input[autocomplete=new-password]').nth(0).fill('Passw0rd!x');
await page.locator('input[autocomplete=new-password]').nth(1).fill('Passw0rd!x');
await page.getByRole('button', { name: 'Create account' }).click();
await page.waitForURL(/\/welcome/);
await page.getByLabel('Display name').fill(name);
await page.getByText('✓ Available').waitFor();
await page.locator('input[type=checkbox]').check();
await page.getByRole('button', { name: "Let's play" }).click();
await page.waitForURL(`${APP}/`);
await page.getByRole('link', { name: 'Your profile' }).waitFor();

// 3. World Cup: pick a nation, see the hub.
await page.goto(`${APP}/world-cup`);
await page.getByRole('button', { name: /^Play as / }).waitFor();
await shot('2-pick');
await page.getByRole('button', { name: /^Play as / }).click();
await page.getByText(/Matchday 1 · Group/).waitFor();
await shot('3-hub');

// 4. A reload keeps the session and resumes the run.
await page.reload();
await page.getByText(/Matchday 1 · Group/).waitFor();

if (!quick) {
  // 5. Play the match to full time and check the result is saved.
  await page.getByRole('button', { name: /Play match/ }).click();
  await page.getByRole('button', { name: /Kick off/ }).click();
  await page.waitForTimeout(3000);
  await shot('4-playing');
  await page.getByText('Full time').waitFor({ timeout: 240_000 });
  await page.getByText(/Result saved/).waitFor({ timeout: 15_000 });
  await shot('5-fulltime');
  await page.getByRole('button', { name: /Continue/ }).click();
  await page.getByText(/Matchday 2 · Group/).waitFor();
  await shot('6-hub-after');
}

assert.deepEqual(errors.filter((e) => !/favicon|Failed to load resource/.test(e)), []);
await browser.close();
console.log('e2e ok');
