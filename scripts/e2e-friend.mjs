#!/usr/bin/env node
// Two real browsers play a friend match against each other through Serverpod.
// Needs Vite on :5173, Serverpod on :8080/:8082 (dev) and SERVER_LOG.
//   node scripts/e2e-friend.mjs [--relay] [--abandon] [--leave] [--invite]
//   --relay    skip WebRTC and use the WebSocket relay
//   --abandon  the guest's tab vanishes mid-match; the host must end up with an abandoned match
//   --leave    the guest quits from the menu; the host is told straight away
//   --invite   the guest joins through a friend invite instead of the shared link
import { chromium } from 'playwright-core';
import { existsSync, mkdirSync } from 'node:fs';
import { join } from 'node:path';
import assert from 'node:assert/strict';
import { call, register } from './lib/api.mjs';

const APP = process.env.APP ?? 'http://localhost:5173';
const SHOTS = process.env.SHOTS ?? join(process.cwd(), '.e2e-shots');
const relay = process.argv.includes('--relay');
const abandon = process.argv.includes('--abandon');
const leave = process.argv.includes('--leave');
const invite = process.argv.includes('--invite');
mkdirSync(SHOTS, { recursive: true });
const exe = ['C:/Program Files/Google/Chrome/Application/chrome.exe', 'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe'].find(existsSync);
const browser = await chromium.launch({ executablePath: exe, headless: true, args: ['--disable-features=WebRtcHideLocalIpsWithMdns'] });

const run = `${Date.now()}`.slice(-8);
async function player(tag) {
  const auth = await register(`${tag}${run}@example.com`);
  await call('profile/createProfile', { displayName: `${tag}_${run}`, acceptTerms: true }, auth.token);
  const me = await call('profile/me', {}, auth.token);
  const ctx = await browser.newContext({ viewport: { width: 1400, height: 900 } });
  await ctx.addInitScript(
    ([a, force]) => {
      localStorage.setItem('wc2026.auth', JSON.stringify({ token: a.token, refreshToken: a.refreshToken, expiresAt: Date.parse(a.tokenExpiresAt) }));
      if (force) localStorage.setItem('wc2026.forceRelay', '1');
      localStorage.setItem('wc2026.sound', 'off');
    },
    [auth, relay],
  );
  const page = await ctx.newPage();
  const errors = [];
  page.on('pageerror', (e) => errors.push(e.message));
  page.on('console', (m) => m.type() === 'error' && errors.push(m.text()));
  return { tag, jwt: auth.token, userId: me.userId, ctx, page, errors };
}
const host = await player('hostp');
const guest = await player('guestp');
const shot = async (p, n) => {
  await p.page.waitForTimeout(700);
  await p.page.screenshot({ path: join(SHOTS, `friend-${p.tag}-${n}.png`) });
};
const pickNation = async (p, name) => {
  await p.page.getByRole('button', { name: /Pick your nation|Change nation/ }).first().click();
  await p.page.getByRole('dialog', { name: 'Choose a nation' }).getByRole('button', { name: new RegExp(`^${name}$`, 'i') }).click();
};

// Lobby: the host creates a room with one tap; the guest opens the link (or accepts an invite).
await host.page.goto(`${APP}/online`);
if (invite) {
  await call('friends/request', { name: `guestp_${run}` }, host.jwt);
  await call('friends/accept', { userId: host.userId }, guest.jwt);
}
await host.page.getByRole('button', { name: /Create a room/ }).click();
const code = (await host.page.getByRole('heading', { name: /^Room [A-Z2-9]{5}$/ }).textContent()).replace('Room ', '').trim();
assert.match(code, /^[A-Z2-9]{5}$/);
await shot(host, '1-waiting');
await host.page.getByRole('button', { name: 'Show QR code' }).click();
await host.page.getByAltText(/QR code/).waitFor();

if (invite) {
  // The guest is already on the Online screen, the case where the Join button used to do nothing.
  await guest.page.goto(`${APP}/online`);
  await host.page.getByRole('button', { name: 'Invite', exact: true }).click({ timeout: 15000 });
  await guest.page.getByText(/wants to play/).waitFor({ timeout: 20000 });
  await shot(guest, '0-invite-toast');
  await guest.page.getByRole('button', { name: 'Join', exact: true }).click();
} else {
  await guest.page.goto(`${APP}/online?join=${code}`);
}
await guest.page.getByRole('heading', { name: `Room ${code}` }).waitFor();
await host.page.getByText(`guestp_${run} joined the room`).waitFor({ timeout: 10000 });
// Toasts close themselves after a few seconds.
await host.page.getByText(`guestp_${run} joined the room`).waitFor({ state: 'hidden', timeout: 9000 });

// Chat: a line from the host reaches the guest.
await host.page.getByLabel('Chat message').fill('good luck, mate');
await host.page.getByRole('button', { name: 'Send' }).click();
await guest.page.getByText('good luck, mate').waitFor({ timeout: 10000 });

await pickNation(host, 'Brazil');
await pickNation(guest, 'Germany');
await shot(host, '2-lobby');
await host.page.getByRole('button', { name: /I'm ready/ }).click();
await guest.page.getByRole('button', { name: /I'm ready/ }).click();

// Count-in, then both reach the match and agree on a transport.
await host.page.getByText('Kick off in').waitFor({ timeout: 10000 });
for (const p of [host, guest]) {
  try {
    await p.page.waitForFunction(() => window.__fm?.linkRef?.current, null, { timeout: 45000 });
  } catch (e) {
    await shot(p, 'connect-failed');
    console.log(p.tag, 'page text:', (await p.page.locator('body').innerText()).replace(/\s+/g, ' ').slice(0, 400));
    throw e;
  }
}
const transport = await host.page.evaluate(() => window.__fm.linkRef.current.transport);
const gTransport = await guest.page.evaluate(() => window.__fm.linkRef.current.transport);
console.log('transport: host', transport, '/ guest', gTransport);
assert.equal(transport, gTransport, 'both sides use the same transport');
if (relay) assert.equal(transport, 'relay');
await host.page.waitForTimeout(2500);
// Both sides measure the connection; the host holds their own presses back by half the round trip.
for (const p of [host, guest]) await p.page.getByLabel(/^Ping [0-9]+ milliseconds/).waitFor({ timeout: 8000 });
const delay = await host.page.evaluate(() => window.__fm.engineRef.current.hostInputDelayMs);
assert.ok(delay >= 0 && delay <= 100, `host input delay is bounded (${delay})`);
console.log('ping/delay ok, host input delay', delay.toFixed(1), 'ms');
await shot(host, '3-playing');
await shot(guest, '3-playing');

// The guest's keyboard moves the guest's player on the host's simulation.
const probe = (page, row) =>
  page.evaluate((row) => {
    const s = window.__fm.engineRef.current.getSnapshot();
    const g = row ?? s.sel[2];
    return { g, x: s.p[g][0] };
  }, row);
const a = await probe(host.page);
await guest.page.keyboard.down('ArrowRight');
await guest.page.keyboard.down('KeyE');
await host.page.waitForTimeout(900);
const b = await probe(host.page, a.g);
await guest.page.keyboard.up('ArrowRight');
await guest.page.keyboard.up('KeyE');
assert.ok(b.x < a.x - 25, `guest input reached the host (${a.x} -> ${b.x})`);
// Quick chat: the host says "GG", the guest sees it.
await host.page.getByRole('button', { name: 'Chat' }).click();
await host.page.getByRole('menuitem', { name: 'GG' }).click();
await guest.page.getByRole('status').filter({ hasText: 'GG' }).waitFor({ timeout: 8000 });
const clocks = await Promise.all([host.page, guest.page].map((p) => p.evaluate(() => window.__fm.hudRef.current.clock)));
assert.ok(Math.abs(clocks[0] - clocks[1]) < 400, `clocks agree (${clocks})`);

if (leave) {
  // The guest quits from the pause menu: the host hears about it at once, no 25 s wait.
  await guest.page.getByRole('button', { name: 'Pause menu' }).click();
  await guest.page.getByRole('button', { name: 'Quit match' }).click();
  await guest.page.getByRole('dialog', { name: 'Quit the match?' }).getByRole('button', { name: 'Quit match' }).click();
  const t0 = Date.now();
  await host.page.getByRole('heading', { name: new RegExp(`guestp_${run} left`, 'i') }).waitFor({ timeout: 8000 });
  console.log('host told after', Date.now() - t0, 'ms');
  await shot(host, '4-opponent-left');
  const hist = await call('friendMatch/history', { limit: 5 }, host.jwt);
  assert.equal(hist[0].match.status, 'abandoned');
  assert.equal(hist[0].match.endReason, 'left');
  assert.equal(hist[0].match.leaverUserId, hist[0].match.guestUserId);
  assert.equal(hist[0].match.winnerUserId ?? null, null);
  console.log('leave ok');
} else if (abandon) {
  // The guest vanishes. The host should be told (a closing tab reports a leave) or time out, and
  // the match ends abandoned with the guest as the one who left.
  await guest.ctx.close();
  await host.page.getByRole('heading', { name: /left$/i }).waitFor({ timeout: 150000 });
  await shot(host, '4-abandoned');
  const hist = await call('friendMatch/history', { limit: 5 }, host.jwt);
  assert.equal(hist[0].match.status, 'abandoned');
  assert.equal(hist[0].match.leaverUserId, hist[0].match.guestUserId);
  assert.equal(hist[0].match.winnerUserId ?? null, null);
  console.log('abandon ok');
} else {
  // Skip to the end of the match: both sign the same score.
  await host.page.evaluate(() => { window.__fm.engineRef.current.elapsed = 176; });
  const verdict = /^(Victory|Defeat|Draw)$/;
  for (const p of [host, guest]) {
    try {
      await p.page.getByRole('heading', { name: verdict }).waitFor({ timeout: 60000 });
    } catch (e) {
      await shot(p, 'result-failed');
      console.log(p.tag, 'text:', (await p.page.locator('body').innerText()).replace(/\s+/g, ' ').slice(0, 300));
      throw e;
    }
  }
  await shot(host, '4-result');
  await shot(guest, '4-result');
  const hh = await call('friendMatch/history', { limit: 5 }, host.jwt);
  const gh = await call('friendMatch/history', { limit: 5 }, guest.jwt);
  assert.equal(hh[0].match.status, 'finished');
  // The finished match shows up in the rankings and unlocks the first achievement.
  const lb = await call('rankings/leaderboard', { limit: 10 }, host.jwt);
  assert.ok(lb.you && lb.you.played >= 1, 'the host is on the leaderboard');
  const ach = await call('rankings/achievements', {}, host.jwt);
  assert.equal(ach.find((x) => x.id === 'first_match').done, true);
  assert.equal(gh[0].match.id, hh[0].match.id);
  assert.equal(hh[0].match.hostGoals, gh[0].match.hostGoals);
  assert.equal(hh[0].match.transport, transport);
  const stats = JSON.parse(hh[0].match.stats ?? 'null');
  assert.ok(stats, 'the host reported the match numbers');
  assert.equal(stats.possession[0] + stats.possession[1], 100);
  await host.page.getByRole('group', { name: 'Match stats' }).waitFor();
  await guest.page.getByRole('group', { name: 'Match stats' }).waitFor();
  console.log(`result stored: ${hh[0].hostName} ${hh[0].match.hostGoals}-${hh[0].match.guestGoals} ${hh[0].guestName}`);

  // Rematch: either player starts it, the other joins, hosts are swapped, nations kept.
  await guest.page.getByRole('button', { name: 'Rematch' }).click();
  await guest.page.getByRole('heading', { name: /^Room / }).waitFor();
  await host.page.getByRole('button', { name: 'Rematch' }).click();
  await host.page.getByRole('heading', { name: /^Room / }).waitFor();
  await guest.page.getByText('Germany', { exact: true }).first().waitFor();
  console.log('rematch ok');
}

for (const p of [host, guest]) {
  const errs = p.errors.filter((e) => !/favicon|Failed to load resource|WebSocket|ERR_|net::/.test(e));
  assert.deepEqual(errs, [], `${p.tag} page errors`);
}
await browser.close();
console.log('friend e2e ok');
