// The guest's side of an online friend match: no simulation here. It draws the
// snapshots the host streams (mirrored, so the guest attacks right like the host
// does), and turns the guest's keyboard into canonical key codes for the host.

import type { TeamData } from './teams/types';
import type { HudState, PlayerEntity, StateListener } from './types';
import { FIELD_W, BALL_R } from './constants';
import { renderScene } from './render';
import { makePlayerEntity } from './entities';
import { P, type InputMsg, type Snapshot } from './snapshot';
import { ACTION_KEYS, KICK_KEYS, MOVE_KEYS } from './engine';
import { ACTION_ORDER, DEFAULT_BINDINGS, type KeyBindings } from './keybindings';

const INTERP_DELAY_MS = 110;
/** A jump bigger than this between snapshots is a teleport (restart), not a run. */
const TELEPORT_PX = 260;
const HEARTBEAT_MS = 250;
/** Faster than any legitimate run, slide or lunge (px/s; a sprint is ~250). */
const MAX_PLAYER_SPEED = 700;
/** Anomalies tolerated before the guest refuses to sign the result. */
const MAX_ANOMALIES = 3;

const lerp = (a: number, b: number, k: number) => a + (b - a) * k;

export class GuestView {
  private ctx: CanvasRenderingContext2D;
  private raf = 0;
  private running = false;
  private snaps: { at: number; s: Snapshot }[] = [];
  /** Smallest observed (local receive time - host time): the baseline network offset. */
  private offset = Infinity;
  private lastSnapshotAt = 0;
  private anomalies = 0;

  /** The host's team, drawn as the "away" side in the mirrored view. */
  private hostEnts: PlayerEntity[];
  /** The guest's own team, drawn as "home" attacking right. */
  private guestEnts: PlayerEntity[];

  private keyRemap = new Map<string, string>();
  private held = new Set<string>();
  private pressed: string[] = [];
  private released: string[] = [];
  private suspended = false;
  private heartbeat = 0;

  constructor(
    canvas: HTMLCanvasElement,
    private listener: StateListener,
    private hostTeam: TeamData,
    private guestTeam: TeamData,
    private send: (m: InputMsg) => void,
    bindings?: KeyBindings,
  ) {
    const ctx = canvas.getContext('2d');
    if (!ctx) throw new Error('Canvas 2D context unavailable');
    this.ctx = ctx;
    this.hostEnts = hostTeam.players.map((p, i) =>
      makePlayerEntity('away', { x: 1 - p.pos.x, y: p.pos.y }, i, p),
    );
    this.guestEnts = guestTeam.players.map((p, i) => makePlayerEntity('home', p.pos, i, p));
    if (bindings) this.setBindings(bindings);
  }

  // ---- lifecycle ----------------------------------------------------------

  start() {
    if (this.running) return;
    this.running = true;
    window.addEventListener('keydown', this.onKeyDown);
    window.addEventListener('keyup', this.onKeyUp);
    window.addEventListener('blur', this.onBlur);
    this.heartbeat = window.setInterval(() => this.flush(), HEARTBEAT_MS);
    this.raf = requestAnimationFrame(this.loop);
  }

  stop() {
    this.running = false;
    cancelAnimationFrame(this.raf);
    window.clearInterval(this.heartbeat);
    window.removeEventListener('keydown', this.onKeyDown);
    window.removeEventListener('keyup', this.onKeyUp);
    window.removeEventListener('blur', this.onBlur);
  }

  /** Milliseconds since the last snapshot arrived (Infinity before the first). */
  msSinceSnapshot() {
    return this.lastSnapshotAt ? performance.now() - this.lastSnapshotAt : Infinity;
  }

  pushSnapshot(s: Snapshot) {
    const now = performance.now();
    this.lastSnapshotAt = now;
    this.offset = Math.min(this.offset, now - s.t);
    const last = this.snaps[this.snaps.length - 1];
    if (last && s.seq <= last.s.seq) return; // out of order or duplicate
    if (last) this.check(last.s, s);
    this.snaps.push({ at: now, s });
    if (this.snaps.length > 12) this.snaps.shift();
  }

  /** Rows are matched by team and squad slot: a sent-off player's row simply stops arriving. */
  private static key(row: number[]) {
    return row[P.TEAM] * 16 + row[P.IDX];
  }
  private entFor(row: number[]): PlayerEntity | undefined {
    return (row[P.TEAM] === 0 ? this.hostEnts : this.guestEnts)[row[P.IDX]];
  }

  /** Does the host's stream look like a real match? A clumsy cheat (players teleporting or
   *  sprinting at impossible speed) is counted here; the guest then refuses to sign. This does
   *  not stop a careful cheat, or two friends who agree to lie. */
  private check(a: Snapshot, b: Snapshot) {
    const dt = (b.t - a.t) / 1000;
    if (dt <= 0.005) return;
    // A restart (kickoff, throw-in, offside) legitimately teleports the ball and moves players.
    if (Math.hypot(b.ball[0] - a.ball[0], b.ball[1] - a.ball[1]) > TELEPORT_PX) return;
    const before = new Map(a.p.map((r) => [GuestView.key(r), r]));
    for (const pb of b.p) {
      const pa = before.get(GuestView.key(pb));
      if (!pa) continue;
      // Restarts (throw-in, offside, corner) place players and zero their momentum at once.
      if (pb[P.VX] === 0 && pb[P.VY] === 0) continue;
      if (Math.hypot(pb[P.X] - pa[P.X], pb[P.Y] - pa[P.Y]) / dt > MAX_PLAYER_SPEED) {
        this.anomalies++;
        return;
      }
    }
  }

  /** False once the stream has looked impossible too often. */
  trusted() {
    return this.anomalies <= MAX_ANOMALIES;
  }

  // ---- input --------------------------------------------------------------

  setBindings(bindings: KeyBindings) {
    this.keyRemap.clear();
    for (const action of ACTION_ORDER) {
      const physical = bindings[action];
      const canonical = DEFAULT_BINDINGS[action];
      if (physical && physical !== canonical) this.keyRemap.set(physical, canonical);
    }
  }

  /** Ignore the keyboard (settings open) without pausing the shared match. */
  suspendInput(suspended: boolean) {
    this.suspended = suspended;
    if (suspended) this.releaseAll();
  }

  /** Press or release a canonical key from a non-keyboard device (controller, touch). */
  pressKey(code: string) {
    if (this.suspended || this.held.has(code)) return;
    if (ACTION_KEYS.has(code)) this.pressed.push(code);
    this.held.add(code);
    this.flush();
  }

  releaseKey(code: string) {
    if (this.suspended || !this.held.has(code)) return;
    if (KICK_KEYS.has(code)) this.released.push(code);
    this.held.delete(code);
    this.flush();
  }

  private onKeyDown = (e: KeyboardEvent) => {
    if (this.suspended) return;
    const code = this.keyRemap.get(e.code) ?? e.code;
    if (!MOVE_KEYS.has(code) && !ACTION_KEYS.has(code)) return;
    e.preventDefault();
    if (e.repeat) return;
    if (ACTION_KEYS.has(code)) this.pressed.push(code);
    this.held.add(code);
    this.flush();
  };

  private onKeyUp = (e: KeyboardEvent) => {
    if (this.suspended) return;
    const code = this.keyRemap.get(e.code) ?? e.code;
    if (!this.held.has(code)) return;
    if (KICK_KEYS.has(code)) this.released.push(code);
    this.held.delete(code);
    this.flush();
  };

  private onBlur = () => this.releaseAll();

  private releaseAll() {
    for (const c of this.held) if (KICK_KEYS.has(c)) this.released.push(c);
    this.held.clear();
    this.flush();
  }

  private flush() {
    this.send({ type: 'in', held: [...this.held], pressed: this.pressed, released: this.released });
    this.pressed = [];
    this.released = [];
  }

  // ---- drawing ------------------------------------------------------------

  private loop = () => {
    if (!this.running) return;
    this.draw();
    this.raf = requestAnimationFrame(this.loop);
  };

  /** The pair of snapshots around the render time, and how far between them. */
  private bracket(): { a: Snapshot; b: Snapshot; k: number } | null {
    const n = this.snaps.length;
    if (!n) return null;
    if (n === 1 || !isFinite(this.offset)) {
      const s = this.snaps[n - 1].s;
      return { a: s, b: s, k: 0 };
    }
    const hostNow = performance.now() - this.offset - INTERP_DELAY_MS;
    for (let i = n - 1; i > 0; i--) {
      const a = this.snaps[i - 1].s;
      const b = this.snaps[i].s;
      if (hostNow >= a.t) {
        const span = b.t - a.t || 1;
        return { a, b, k: Math.min(1, Math.max(0, (hostNow - a.t) / span)) };
      }
    }
    const first = this.snaps[0].s;
    return { a: first, b: first, k: 0 };
  }

  private draw() {
    const br = this.bracket();
    if (!br) return;
    const { a, b, k } = br;
    const near = k < 0.5 ? a : b;

    // Mirror into the guest's frame while copying onto the entities.
    const later = new Map(b.p.map((r) => [GuestView.key(r), r]));
    const onPitch: PlayerEntity[] = [];
    for (const pn of near.p) {
      const e = this.entFor(pn);
      if (!e) continue;
      const pa = a.p.find((r) => GuestView.key(r) === GuestView.key(pn)) ?? pn;
      const pb = later.get(GuestView.key(pn)) ?? pa;
      onPitch.push(e);
      const jump = Math.hypot(pb[P.X] - pa[P.X], pb[P.Y] - pa[P.Y]) > TELEPORT_PX;
      const kk = jump ? 1 : k;
      e.x = FIELD_W - lerp(pa[P.X], pb[P.X], kk);
      e.y = lerp(pa[P.Y], pb[P.Y], kk);
      e.vx = -lerp(pa[P.VX], pb[P.VX], kk);
      e.vy = lerp(pa[P.VY], pb[P.VY], kk);
      e.facing = { x: -pn[P.FX], y: pn[P.FY] };
      e.animPhase = lerp(pa[P.ANIM], pb[P.ANIM], kk);
      e.kickTimer = pn[P.KICK];
      e.diveTimer = pn[P.DIVE];
      e.diveDir = pn[P.DIVE_DIR];
      e.slideTimer = pn[P.SLIDE];
      e.slideDir = { x: -pn[P.SLIDE_X], y: pn[P.SLIDE_Y] };
      e.celebrating = (pn[P.FLAGS] & 1) !== 0;
      e.throwing = (pn[P.FLAGS] & 2) !== 0;
    }
    const ballJump = Math.hypot(b.ball[0] - a.ball[0], b.ball[1] - a.ball[1]) > TELEPORT_PX * 2;
    const bk = ballJump ? 1 : k;
    const ball = {
      x: FIELD_W - lerp(a.ball[0], b.ball[0], bk),
      y: lerp(a.ball[1], b.ball[1], bk),
      z: lerp(a.ball[2], b.ball[2], bk),
      r: BALL_R,
    };

    const sel = (i: number) => (i >= 0 && near.p[i] ? (this.entFor(near.p[i]) ?? null) : null);
    renderScene(this.ctx, {
      camX: FIELD_W - lerp(a.cam[0], b.cam[0], k),
      camY: lerp(a.cam[1], b.cam[1], k),
      ball,
      players: onPitch.map((p) =>
        p.team === 'away'
          ? { p, kit: p.isGK ? this.hostTeam.gkKit : this.hostTeam.kit }
          : { p, kit: p.isGK ? this.guestTeam.gkKit : this.guestTeam.awayKit },
      ),
      controlled: sel(near.sel[2]),
      switchHint: sel(near.sel[3]),
      // The host's left goal is the guest's right goal.
      netRipple: { left: near.ripple[1], right: near.ripple[0] },
    });

    this.listener(this.hud(near));
  }

  private hud(s: Snapshot): HudState {
    const mine = s.sel[2] >= 0 && s.p[s.sel[2]] ? (this.entFor(s.p[s.sel[2]]) ?? null) : null;
    const theirs = s.sel[0] >= 0 && s.p[s.sel[0]] ? (this.entFor(s.p[s.sel[0]]) ?? null) : null;
    return {
      homeScore: s.score[1],
      awayScore: s.score[0],
      clock: s.clock,
      message: s.msg,
      possession: s.poss === 0 ? 'none' : s.poss === 2 ? 'home' : 'away',
      homePlayer: mine ? { num: mine.num, name: mine.name } : null,
      awayPlayer: theirs ? { num: theirs.num, name: theirs.name } : null,
      charge: s.charge[1] >= 0 ? s.charge[1] : null,
      finished: s.fin,
      // The host sends [host, guest]; this view has the guest on the left.
      stats: s.stats
        ? {
            possession: [s.stats.poss[1], s.stats.poss[0]],
            shots: [s.stats.shots[1], s.stats.shots[0]],
            onTarget: [s.stats.onTarget[1], s.stats.onTarget[0]],
            saves: [s.stats.saves[1], s.stats.saves[0]],
            yellow: [s.stats.yellow[1], s.stats.yellow[0]],
            red: [s.stats.red[1], s.stats.red[0]],
          }
        : undefined,
    };
  }
}
