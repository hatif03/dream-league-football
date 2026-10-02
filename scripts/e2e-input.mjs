#!/usr/bin/env node
// Controller (simulated gamepad) and touch controls in practice mode. Needs Vite on :5173.
import { chromium } from 'playwright-core';
import { existsSync, mkdirSync } from 'node:fs';
import assert from 'node:assert/strict';

const APP = process.env.APP ?? 'http://localhost:5173';
mkdirSync('.e2e-shots', { recursive: true });
const exe = ['C:/Program Files/Google/Chrome/Application/chrome.exe', 'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe'].find(existsSync);
const browser = await chromium.launch({ executablePath: exe, headless: true });
const errors = [];
const watch = (p) => {
  p.on('pageerror', (e) => errors.push(e.message));
  p.on('console', (m) => m.type() === 'error' && errors.push(m.text()));
};
const playerX = (page) => page.evaluate(() => window.__game.current.controlled.x);

// ---- controller -------------------------------------------------------------
{
  const ctx = await browser.newContext({ viewport: { width: 1400, height: 900 } });
  await ctx.addInitScript(() => {
    window.__pad = { id: 'Fake pad', index: 0, connected: true, mapping: 'standard', axes: [0, 0, 0, 0], buttons: Array.from({ length: 17 }, () => ({ pressed: false, value: 0 })) };
    navigator.getGamepads = () => [window.__pad];
  });
  const page = await ctx.newPage();
  watch(page);
  await page.goto(`${APP}/practice`);
  await page.getByRole('button', { name: /Start practice/ }).click();
  // The pad speaks first: the intro card switches to controller prompts.
  await page.getByRole('button', { name: /Kick off/ }).waitFor();
  await page.evaluate(() => (window.__pad.axes[0] = 1));
  await page.getByText('L-Stick').waitFor({ timeout: 3000 });
  await page.evaluate(() => (window.__pad.axes[0] = 0));
  await page.getByRole('button', { name: /Kick off/ }).click();
  await page.waitForFunction(() => window.__game?.current);
  await page.waitForTimeout(1500);

  const x0 = await playerX(page);
  await page.evaluate(() => (window.__pad.axes[0] = 1)); // left stick right
  await page.waitForTimeout(900);
  const x1 = await playerX(page);
  assert.ok(x1 > x0 + 30, `stick right moves the player right (${x0} -> ${x1})`);
  await page.evaluate(() => (window.__pad.axes[0] = 0));

  // D-pad left moves back.
  await page.evaluate(() => (window.__pad.buttons[14].pressed = true));
  await page.waitForTimeout(900);
  await page.evaluate(() => (window.__pad.buttons[14].pressed = false));
  const x2 = await playerX(page);
  assert.ok(x2 < x1 - 20, `D-pad left moves the player left (${x1} -> ${x2})`);

  // A held kick button charges the power gauge (the carrier has the ball in practice).
  await page.evaluate(() => (window.__pad.buttons[1].pressed = true)); // B = shot
  await page.waitForTimeout(350);
  const charging = await page.evaluate(() => window.__game.current.chargeLevel());
  await page.evaluate(() => (window.__pad.buttons[1].pressed = false));
  console.log('charge while holding B:', charging);

  // Settings has a controller tab that shows the connected pad and rebinds a button.
  await page.getByRole('button', { name: 'Pause menu' }).click();
  await page.getByRole('button', { name: /Controls & settings/ }).click();
  await page.getByRole('tab', { name: 'controller' }).click();
  await page.getByText('Controller connected.').waitFor();
  const before = await page.getByRole('button', { name: 'B', exact: true }).count();
  await page.getByRole('button', { name: 'A', exact: true }).first().click(); // rebind Short pass
  await page.getByText(/^Press a button/).waitFor();
  await page.evaluate(() => (window.__pad.buttons[7].pressed = true)); // press RT
  await page.getByRole('button', { name: 'RT', exact: true }).waitFor({ timeout: 3000 });
  await page.evaluate(() => (window.__pad.buttons[7].pressed = false));
  console.log('rebind ok, B buttons before:', before);
  await page.screenshot({ path: '.e2e-shots/input-controller-settings.png' });
  await ctx.close();
}

// ---- touch ------------------------------------------------------------------
{
  const ctx = await browser.newContext({ viewport: { width: 900, height: 480 }, hasTouch: true, isMobile: true });
  const page = await ctx.newPage();
  watch(page);
  await page.goto(`${APP}/practice`);
  await page.getByRole('button', { name: /Start practice/ }).click();
  await page.getByRole('button', { name: /Kick off/ }).click();
  await page.waitForFunction(() => window.__game?.current);
  const stick = page.getByLabel('Move', { exact: true });
  await stick.waitFor({ timeout: 5000 });
  const box = await stick.boundingBox();
  await page.waitForTimeout(1500);
  const x0 = await playerX(page);
  const cx = box.x + box.width / 2;
  const cy = box.y + box.height / 2;
  await page.mouse.move(cx, cy);
  await page.mouse.down();
  await page.mouse.move(cx + 50, cy, { steps: 4 });
  await page.waitForTimeout(900);
  const x1 = await playerX(page);
  await page.mouse.up();
  assert.ok(x1 > x0 + 30, `thumb stick right moves the player (${x0} -> ${x1})`);

  const shot = page.getByRole('button', { name: 'Shot', exact: true });
  await shot.dispatchEvent('pointerdown', { pointerId: 7, isPrimary: true });
  await page.waitForTimeout(300);
  const charging = await page.evaluate(() => window.__game.current.chargeLevel());
  await shot.dispatchEvent('pointerup', { pointerId: 7, isPrimary: true });
  console.log('touch shot charge:', charging);
  await page.screenshot({ path: '.e2e-shots/input-touch.png' });

  // The touch layout can be swapped in settings.
  await page.getByRole('button', { name: 'Pause menu' }).click();
  await page.getByRole('button', { name: /Controls & settings/ }).click();
  await page.getByRole('tab', { name: 'touch' }).click();
  await page.getByLabel('Button 1 action').selectOption('shortPass');
  assert.equal(await page.getByLabel('Button 2 action').inputValue(), 'shot', 'swapping keeps every action on exactly one button');
  await ctx.close();
}

assert.deepEqual(errors.filter((e) => !/favicon|Failed to load resource/.test(e)), []);
await browser.close();
console.log('input e2e ok');
