#!/usr/bin/env node
// Exercises the two-human engine in one page (host engine + guest view wired in
// memory, see /dev/loopback). Needs Vite on :5173. No server required.
import { chromium } from 'playwright-core';
import { existsSync, mkdirSync } from 'node:fs';
import { join } from 'node:path';
import assert from 'node:assert/strict';

const APP = process.env.APP ?? 'http://localhost:5173';
const SHOTS = process.env.SHOTS ?? join(process.cwd(), '.e2e-shots');
mkdirSync(SHOTS, { recursive: true });
const exe = ['C:/Program Files/Google/Chrome/Application/chrome.exe', 'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe'].find(existsSync);
const browser = await chromium.launch({ executablePath: exe, headless: true });
const page = await browser.newPage({ viewport: { width: 1000, height: 1500 } });
const errors = [];
page.on('pageerror', (e) => errors.push(e.message));
page.on('console', (m) => m.type() === 'error' && errors.push(m.text()));

await page.goto(`${APP}/dev/loopback?latency=40`);
await page.waitForFunction(() => window.__loop?.host && window.__loop.guest.msSinceSnapshot() < 500, null, { timeout: 15000 });
await page.waitForTimeout(3500);

// 1. Flipping the world twice is the identity (so the guest step cannot corrupt the host's world).
const flip = await page.evaluate(() => {
  const { host } = window.__loop;
  const before = JSON.stringify(host.getSnapshot().p);
  host.flipWorld();
  const mid = JSON.stringify(host.getSnapshot().p);
  host.flipWorld();
  const after = JSON.stringify(host.getSnapshot().p);
  return { same: before === after, changed: before !== mid };
});
assert.ok(flip.same, 'flip twice must restore the world');
assert.ok(flip.changed, 'a single flip must change it');

// 2. The guest's keyboard moves THEIR player, in their own frame: holding "right" runs
//    toward the opponent's goal, which is LEFT in the host's frame.
const probe = (row) =>
  page.evaluate((row) => {
    const { host } = window.__loop;
    const s = host.getSnapshot();
    const g = row ?? s.sel[2];
    return { g, x: s.p[g][0], vx: s.p[g][2], hostSel: s.sel[0] };
  }, row);
await page.evaluate(() => window.__loop.host.suspendInput(true));
// Restart so the guest's striker is selected and nobody has won the ball yet.
await page.evaluate(() => window.__loop.host.resetKickoff('home'));
await page.waitForTimeout(1100); // the restart freeze
const a = await probe();
await page.keyboard.down('ArrowRight');
await page.keyboard.down('KeyE');
await page.waitForTimeout(700);
const b = await probe(a.g);
await page.keyboard.up('ArrowRight');
await page.keyboard.up('KeyE');
assert.ok(b.x < a.x - 40, `guest "right" should run toward x=0 in the host frame (${a.x} -> ${b.x})`);
assert.ok(b.vx < 0, 'and be moving that way');

// 3. The guest's view agrees with the host's score and clock (mirrored).
const hud = await page.evaluate(() => {
  const el = document.querySelector('div.text-white');
  return el.textContent;
});
console.log('hud:', hud);
await page.screenshot({ path: join(SHOTS, 'loopback.png'), fullPage: true });

// 4. Fuzz: both seats get random buttons for ~45 s; the world must stay valid.
await page.evaluate(() => window.__loop.host.suspendInput(false));
const keys = ['ArrowUp', 'ArrowDown', 'ArrowLeft', 'ArrowRight', 'KeyE', 'KeyD', 'KeyS', 'KeyA', 'KeyW', 'KeyQ', 'KeyC'];
const held = new Set();
const t0 = Date.now();
let checks = 0;
while (Date.now() - t0 < 45000) {
  const k = keys[Math.floor(Math.random() * keys.length)];
  if (held.has(k)) {
    await page.keyboard.up(k);
    held.delete(k);
  } else if (held.size < 4) {
    await page.keyboard.down(k);
    held.add(k);
  }
  await page.waitForTimeout(60 + Math.random() * 120);
  if (checks++ % 15 === 0) {
    const bad = await page.evaluate(() => {
      const { host } = window.__loop;
      const W = 2200;
      const issues = [];
      const all = [...host.homePlayers, ...host.awayPlayers];
      if (host.homePlayers.length > 11 || host.awayPlayers.length > 11 || host.homePlayers.length < 8 || host.awayPlayers.length < 8) issues.push('team size');
      if (!host.homePlayers.every((p) => p.team === 'home')) issues.push('home labels');
      if (!host.awayPlayers.every((p) => p.team === 'away')) issues.push('away labels');
      for (const p of all) {
        if (![p.x, p.y, p.vx, p.vy].every(Number.isFinite)) issues.push('NaN player');
        if (p.x < -50 || p.x > W + 50) issues.push(`x out of field ${p.x}`);
      }
      const b = host.ball;
      if (![b.x, b.y, b.z].every(Number.isFinite)) issues.push('NaN ball');
      return issues;
    });
    assert.deepEqual(bad, [], 'world invariants');
  }
}
for (const k of held) await page.keyboard.up(k);
const final = await page.evaluate(() => {
  const s = window.__loop.host.getSnapshot();
  return { score: s.score, clock: s.clock, poss: s.poss, sinceSnap: window.__loop.guest.msSinceSnapshot() };
});
console.log('after fuzz:', JSON.stringify(final));
assert.ok(final.sinceSnap < 1000, 'snapshots keep flowing to the guest');
await page.screenshot({ path: join(SHOTS, 'loopback-after.png'), fullPage: true });

// 5. Stats are counted by the simulation: a shot by each seat is a shot for the right team,
//    and the keeper stopping it is a save plus a shot on target.
const shots = await page.evaluate(async () => {
  const h = window.__loop.host;
  const out = {};
  h.resetKickoff('home');
  await new Promise((r) => setTimeout(r, 1200));
  out.base = JSON.parse(JSON.stringify(h.tally));
  const p = h.controlled;
  p.x = 1700; p.y = 700; h.ball.x = 1714; h.ball.y = 700; h.owner = p;
  h.doHomeKick('KeyD', 0.3);
  out.afterHome = JSON.parse(JSON.stringify(h.tally));
  out.shotBy = h.shotBy;
  await new Promise((r) => setTimeout(r, 2500));
  out.later = JSON.parse(JSON.stringify(h.tally));
  return out;
});
assert.equal(shots.afterHome.home.shots, shots.base.home.shots + 1, 'the home shot is counted for home');
assert.equal(shots.afterHome.away.shots, shots.base.away.shots, 'and not for away');
assert.equal(shots.shotBy, 'home');
for (const side of ['home', 'away']) {
  assert.ok(shots.later[side].onTarget <= shots.later[side].shots, `${side}: shots on target (${shots.later[side].onTarget}) cannot exceed shots (${shots.later[side].shots})`);
}
console.log('tally:', JSON.stringify(shots.later));


// 6. Fouls: a slide that takes the man instead of the ball gives the other side a free kick,
//    a wall near goal, or a penalty inside the box.
async function foul(victimX, victimY) {
  return page.evaluate(
    async ([vx, vy]) => {
      const h = window.__loop.host;
      for (let attempt = 0; attempt < 8; attempt++) {
        h.resetKickoff('home');
        await new Promise((r) => setTimeout(r, 1100));
        const victim = h.awayPlayers[9];
        const slider = h.homePlayers[5];
        h.controlled = slider;
        victim.x = vx; victim.y = vy; victim.vx = victim.vy = 0;
        slider.x = vx - 24; slider.y = vy; slider.vx = 160; slider.vy = 0; slider.facing = { x: 1, y: 0 };
        h.ball.x = vx + 4; h.ball.y = vy; h.ball.vx = h.ball.vy = 0; h.ball.z = 0;
        h.owner = victim; h.stealProtect = 5; h.lastKicker = null;
        h.justPressed.push('KeyA'); // slide
        await new Promise((r) => setTimeout(r, 1200));
        if (h.message === 'FOUL' || h.message === 'PENALTY') {
          const taker = h.owner;
          return {
            message: h.message,
            ownerTeam: taker && taker.team,
            ballX: Math.round(h.ball.x),
            ballY: Math.round(h.ball.y),
            wall: h.wall ? h.wall.players.length : 0,
            wallDist: h.wall ? Math.round(Math.hypot(h.wall.slots[0].x - h.ball.x, h.wall.slots[0].y - h.ball.y)) : 0,
            insideBox: h.homePlayers.concat(h.awayPlayers).filter((q) => q !== taker && !q.isGK && q.x < 345 && Math.abs(q.y - 712) < 420).length,
          };
        }
      }
      return null;
    },
    [victimX, victimY],
  );
}
await page.evaluate(() => window.__loop.host.suspendInput(true));
const fk = await foul(1100, 700);
assert.ok(fk, 'a missed slide on the carrier is a foul');
assert.equal(fk.message, 'FOUL');
assert.equal(fk.ownerTeam, 'away', 'the fouled side takes the free kick');
assert.equal(fk.wall, 0, 'no wall from midfield');
console.log('free kick at', fk.ballX, fk.ballY);

const nearFk = await foul(560, 540);
assert.ok(nearFk && nearFk.message === 'FOUL', 'a foul just outside the box');
assert.equal(nearFk.wall, 4, 'a four-man wall');
assert.ok(Math.abs(nearFk.wallDist - 197) < 40, 'about 9.15 m from the ball (' + nearFk.wallDist + ')');

const pen = await foul(250, 712);
assert.ok(pen && pen.message === 'PENALTY', 'a foul inside the box is a penalty');
assert.equal(pen.ownerTeam, 'away');
assert.equal(pen.wall, 0, 'no wall for a penalty');
assert.equal(pen.insideBox, 0, 'everyone else waits outside the box');
assert.ok(pen.ballX > 200 && pen.ballX < 260, 'the ball is on the spot (' + pen.ballX + ')');
console.log('penalty ok');



// 6b. Cards: a second yellow is a red. The player leaves the pitch, his side plays with ten,
//     snapshots carry one row fewer, and the guest keeps drawing a consistent match.
const red = await page.evaluate(async () => {
  const h = window.__loop.host;
  h.resetKickoff('home');
  await new Promise((r) => setTimeout(r, 1100));
  const off = h.homePlayers[6];
  off.yellows = 1;
  const before = h.homePlayers.length;
  const rowsBefore = h.getSnapshot().p.length;
  const redsBefore = h.cards.home.r;
  const realRandom = Math.random;
  Math.random = () => 0.2; // the referee is certain: a booking, not a straight red
  const label = h.bookOffender(off);
  Math.random = realRandom;
  await new Promise((r) => setTimeout(r, 400));
  h.resetKickoff('away');
  await new Promise((r) => setTimeout(r, 2500));
  return {
    label,
    before,
    after: h.homePlayers.length,
    rows: h.getSnapshot().p.length,
    rowsBefore,
    redsBefore,
    stillThere: h.homePlayers.includes(off),
    kickoffTaker: h.kickoffOf('home').idx,
    reds: h.cards.home.r,
    anomalies: window.__loop.guest.anomalies,
    guestSeesNine: undefined,
  };
});
assert.match(red.label, /RED CARD/);
assert.equal(red.after, red.before - 1, 'the offender left the pitch');
assert.equal(red.rows, red.rowsBefore - 1, 'snapshot has one row fewer');
assert.equal(red.stillThere, false);
assert.equal(red.reds, red.redsBefore + 1);
assert.ok(red.anomalies <= 3, 'the guest view is not confused by a missing row');
console.log('red card ok');

// 7. A hidden host tab keeps the match running (a Web Worker clock replaces the paused
//    animation frames), and the guest keeps receiving snapshots.
await page.evaluate(() => {
  window.__loop.host.resetKickoff('home');
});
await page.waitForTimeout(1200);
const bg0 = await page.evaluate(() => ({ el: window.__loop.host.elapsed, snaps: window.__loop.guest.snaps.length }));
await page.evaluate(() => {
  Object.defineProperty(document, 'hidden', { configurable: true, get: () => true });
});
await page.waitForTimeout(3000);
const bg1 = await page.evaluate(() => ({ el: window.__loop.host.elapsed, since: window.__loop.guest.msSinceSnapshot() }));
await page.evaluate(() => {
  delete document.hidden;
});
const advanced = bg1.el - bg0.el;
assert.ok(advanced > 2.4 && advanced < 3.6, 'the hidden host advanced about 3 s of match time (' + advanced.toFixed(2) + ')');
assert.ok(bg1.since < 500, 'the guest kept receiving snapshots while the host tab was hidden');
console.log('background ticks ok, advanced', advanced.toFixed(2));

assert.deepEqual(errors.filter((e) => !/favicon|Failed to load resource/.test(e)), []);
await browser.close();
console.log('loopback ok');
