// Penalty shootout for a knockout game that is still level after extra time.
// Alternating kicks, five each, then sudden death. You take your team's kicks (aim with
// the arrows, hold the shot key for power) and dive the keeper for the other team's.

import type { TeamData } from './teams/types';
import type { PlayerEntity } from './types';
import {
  CHARGE_FULL,
  FIELD_H,
  FIELD_W,
  GOAL_HEIGHT,
  M,
  goalBottom,
  goalTop,
} from './constants';
import { clamp } from './math';
import { proj } from './projection';
import { renderScene } from './render';
import { makePlayerEntity } from './entities';
import { DEFAULT_BINDINGS, ACTION_ORDER, type KeyBindings } from './keybindings';

type Side = 'home' | 'away';

export interface ShootoutState {
  kicks: { team: Side; scored: boolean }[];
  homeGoals: number;
  awayGoals: number;
  /** Whose kick it is: 'home' means you are the taker, 'away' means you are the keeper. */
  turn: Side;
  phase: 'intro' | 'aim' | 'run' | 'flight' | 'result' | 'done';
  prompt: string;
  /** Power gauge while you charge a kick, 0-1, else null. */
  charge: number | null;
  /** Last kick: GOAL, SAVED, WIDE or OVER. */
  outcome: string;
  winner: Side | null;
}

const KICKS_EACH = 5;
const SPOT_X = FIELD_W - M(11);
const RUNUP = 0.55;
const FLIGHT = 0.5;
const RESULT = 1.4;
const KEEPER_X = FIELD_W - M(0.9);
const BAR = M(2.44);

const rnd = (a: number, b: number) => a + Math.random() * (b - a);

/** Who has won, or null while it can still change (first to be out of reach, as in the real rules). */
export function shootoutWinner(kicks: { team: Side; scored: boolean }[]): Side | null {
  const goals = { home: 0, away: 0 };
  const taken = { home: 0, away: 0 };
  for (const k of kicks) {
    taken[k.team]++;
    if (k.scored) goals[k.team]++;
  }
  if (taken.home <= KICKS_EACH && taken.away <= KICKS_EACH && (taken.home < KICKS_EACH || taken.away < KICKS_EACH)) {
    const left = { home: KICKS_EACH - taken.home, away: KICKS_EACH - taken.away };
    if (goals.home > goals.away + left.away) return 'home';
    if (goals.away > goals.home + left.home) return 'away';
    return null;
  }
  // Five each taken, or sudden death: decided once both have kicked the same number.
  if (taken.home === taken.away && goals.home !== goals.away) return goals.home > goals.away ? 'home' : 'away';
  return null;
}

export class PenaltyShootout {
  private ctx: CanvasRenderingContext2D;
  private raf = 0;
  private last = 0;
  private running = false;
  private state: ShootoutState;
  private kicker!: PlayerEntity;
  private keeper!: PlayerEntity;
  private kickerTeam!: TeamData;
  private keeperTeam!: TeamData;
  private ball = { x: SPOT_X, y: FIELD_H / 2, z: 0, r: 2.3 };
  private t = 0;
  private aimY = 0; // -1..1 across the goal mouth
  private aimHigh = false;
  private chargeTime = 0;
  private charging = false;
  private diveIntent = 0; // your keeper: -1 up the screen, 0 stay, 1 down
  private ripple = 0;
  private held = new Set<string>();
  private keyRemap = new Map<string, string>();
  // The kick being played out.
  private plan: { y: number; z: number; power: number; scored: boolean; outcome: string; dive: number } | null = null;
  private fromY = FIELD_H / 2;

  constructor(
    canvas: HTMLCanvasElement,
    private listener: (s: ShootoutState) => void,
    private home: TeamData,
    private away: TeamData,
    bindings?: KeyBindings,
  ) {
    const ctx = canvas.getContext('2d');
    if (!ctx) throw new Error('Canvas 2D context unavailable');
    this.ctx = ctx;
    if (bindings) {
      for (const a of ACTION_ORDER) {
        if (bindings[a] && bindings[a] !== DEFAULT_BINDINGS[a]) this.keyRemap.set(bindings[a], DEFAULT_BINDINGS[a]);
      }
    }
    this.state = {
      kicks: [],
      homeGoals: 0,
      awayGoals: 0,
      turn: 'home',
      phase: 'intro',
      prompt: '',
      charge: null,
      outcome: '',
      winner: null,
    };
    this.beginKick('home', 1.4);
  }

  start() {
    if (this.running) return;
    this.running = true;
    window.addEventListener('keydown', this.onKeyDown);
    window.addEventListener('keyup', this.onKeyUp);
    this.last = performance.now();
    this.raf = requestAnimationFrame(this.loop);
    this.emit();
  }
  stop() {
    this.running = false;
    cancelAnimationFrame(this.raf);
    window.removeEventListener('keydown', this.onKeyDown);
    window.removeEventListener('keyup', this.onKeyUp);
  }
  /** Settings open: ignore the keyboard. */
  suspend(on: boolean) {
    if (on) {
      this.held.clear();
      this.charging = false;
    }
    this.suspended = on;
  }
  private suspended = false;

  pressKey(code: string) {
    this.down(code);
  }
  releaseKey(code: string) {
    this.up(code);
  }

  // ---- input ---------------------------------------------------------------

  private onKeyDown = (e: KeyboardEvent) => {
    const code = this.keyRemap.get(e.code) ?? e.code;
    if (code.startsWith('Arrow') || code === 'KeyD' || code === 'KeyS') e.preventDefault();
    if (!e.repeat) this.down(code);
  };
  private onKeyUp = (e: KeyboardEvent) => this.up(this.keyRemap.get(e.code) ?? e.code);

  private down(code: string) {
    if (this.suspended) return;
    this.held.add(code);
    if ((code === 'KeyD' || code === 'KeyS') && this.state.phase === 'aim' && this.state.turn === 'home') {
      this.charging = true;
      this.chargeTime = 0;
    }
  }
  private up(code: string) {
    if (this.suspended) return;
    this.held.delete(code);
    if ((code === 'KeyD' || code === 'KeyS') && this.charging && this.state.phase === 'aim') {
      this.charging = false;
      this.userShoots(clamp(this.chargeTime / CHARGE_FULL, 0, 1));
    }
  }

  // ---- the kicks ------------------------------------------------------------

  private beginKick(team: Side, delay = 0) {
    this.kickerTeam = team === 'home' ? this.home : this.away;
    this.keeperTeam = team === 'home' ? this.away : this.home;
    // The shootout is always taken at the right-hand goal, so both sides use the same layout.
    const kIdx = [9, 10, 8, 7, 6, 5, 4, 3, 2, 1][this.state.kicks.filter((k) => k.team === team).length % 10];
    const kSquad = this.kickerTeam.players[kIdx];
    this.kicker = makePlayerEntity('home', { x: 0, y: 0.5 }, kIdx, kSquad);
    this.kicker.x = SPOT_X - M(3);
    this.kicker.y = FIELD_H / 2 + M(0.8);
    this.kicker.facing = { x: 1, y: 0 };
    this.keeper = makePlayerEntity('away', { x: 1, y: 0.5 }, 0, this.keeperTeam.players[0]);
    this.keeper.x = KEEPER_X;
    this.keeper.y = FIELD_H / 2;
    this.keeper.facing = { x: -1, y: 0 };
    this.ball = { x: SPOT_X, y: FIELD_H / 2, z: 0, r: 2.3 };
    this.aimY = 0;
    this.aimHigh = false;
    this.charging = false;
    this.chargeTime = 0;
    this.diveIntent = 0;
    this.plan = null;
    this.t = -delay;
    this.set({
      turn: team,
      phase: delay > 0 ? 'intro' : 'aim',
      outcome: '',
      charge: null,
      prompt:
        team === 'home'
          ? '↑ ↓ aim · ← low · → high · hold D to charge, release to shoot'
          : 'You are the keeper: hold ↑ or ↓ to pick your dive (nothing = stand), then they shoot',
    });
  }

  /** Probability a keeper stops a shot that goes to the side he picked. */
  private saveChance(power: number, high: boolean, corner: boolean) {
    const skill = this.keeper.ratings.def; // a keeper's rating is carried in `def`
    let p = 0.5 + (skill - 75) / 140;
    p -= (power - 0.5) * 0.35;
    if (high) p -= 0.1;
    if (corner) p -= 0.15;
    return clamp(p, 0.15, 0.85);
  }

  private third(y: number) {
    return y < -0.34 ? -1 : y > 0.34 ? 1 : 0;
  }

  private userShoots(power: number) {
    const sho = this.kicker.ratings.sho;
    // Hard shots sail wide or over more often; a better finisher is steadier.
    const wobble = (0.06 + Math.max(0, power - 0.7) * 0.9) * (1.15 - sho / 150);
    const y = this.aimY + rnd(-wobble, wobble);
    const high = this.aimHigh;
    const overBar = high && power > 0.85 && Math.random() < (power - 0.85) * 3;
    const dive = [-1, 0, 1][Math.random() < 0.14 ? 1 : Math.random() < 0.5 ? 0 : 2];
    this.resolveKick({ aimY: y, high, power, over: overBar, dive });
  }

  private cpuShoots() {
    const sho = this.kicker.ratings.sho;
    const side = [-1, 0, 1][Math.floor(Math.random() * 3)];
    const power = rnd(0.45, 0.95);
    const wobble = (0.06 + Math.max(0, power - 0.7) * 0.9) * (1.15 - sho / 150);
    const aimY = side * rnd(0.55, 0.95) + (side === 0 ? rnd(-0.2, 0.2) : 0) + rnd(-wobble, wobble);
    const high = Math.random() < 0.4;
    const over = high && power > 0.85 && Math.random() < (power - 0.85) * 3;
    this.resolveKick({ aimY, high, power, over, dive: this.diveIntent });
  }

  private resolveKick(k: { aimY: number; high: boolean; power: number; over: boolean; dive: number }) {
    const yWorld = FIELD_H / 2 + (k.aimY * GOAL_HEIGHT) / 2;
    const wide = Math.abs(k.aimY) > 1.02;
    const z = k.over ? BAR + M(0.6) : k.high ? M(1.8) : M(0.35);
    let scored = false;
    let outcome = 'GOAL!';
    if (wide) outcome = 'WIDE!';
    else if (k.over) outcome = 'OVER!';
    else {
      const shotSide = this.third(k.aimY);
      const corner = Math.abs(k.aimY) > 0.75;
      // The side he guesses, or (standing still) the middle, is the one he can reach.
      const reached = k.dive === shotSide;
      scored = !(reached && Math.random() < this.saveChance(k.power, k.high, corner));
      if (!scored) outcome = 'SAVED!';
    }
    this.plan = { y: yWorld, z, power: k.power, scored, outcome, dive: k.dive };
    this.fromY = this.ball.y;
    this.t = 0;
    this.kicker.kickTimer = 0.35;
    this.set({ phase: 'run', charge: null, prompt: '' });
  }

  private finishKick() {
    const p = this.plan!;
    const kicks = [...this.state.kicks, { team: this.state.turn, scored: p.scored }];
    const winner = shootoutWinner(kicks);
    const homeGoals = kicks.filter((x) => x.team === 'home' && x.scored).length;
    const awayGoals = kicks.filter((x) => x.team === 'away' && x.scored).length;
    if (p.scored) this.ripple = 1;
    this.t = 0;
    this.set({ kicks, homeGoals, awayGoals, phase: winner ? 'done' : 'result', outcome: p.outcome, winner, prompt: '' });
  }

  // ---- loop -----------------------------------------------------------------

  private set(patch: Partial<ShootoutState>) {
    this.state = { ...this.state, ...patch };
    this.emit();
  }
  private emit() {
    this.listener(this.state);
  }

  private loop = (now: number) => {
    if (!this.running) return;
    const dt = Math.min(0.05, (now - this.last) / 1000);
    this.last = now;
    this.update(dt);
    this.draw();
    this.raf = requestAnimationFrame(this.loop);
  };

  private update(dt: number) {
    if (this.ripple > 0) this.ripple = Math.max(0, this.ripple - dt * 0.6);
    const s = this.state;
    this.t += dt;
    if (s.phase === 'intro') {
      if (this.t >= 0) this.set({ phase: 'aim' });
      return;
    }
    if (s.phase === 'aim') {
      if (s.turn === 'home') {
        if (this.suspended) return;
        if (this.held.has('ArrowUp')) this.aimY = clamp(this.aimY - dt * 1.4, -1.15, 1.15);
        if (this.held.has('ArrowDown')) this.aimY = clamp(this.aimY + dt * 1.4, -1.15, 1.15);
        if (this.held.has('ArrowLeft')) this.aimHigh = false;
        if (this.held.has('ArrowRight')) this.aimHigh = true;
        if (this.charging) {
          this.chargeTime += dt;
          // Holding too long is a mistake: the strike goes off on its own at full power.
          if (this.chargeTime >= CHARGE_FULL * 1.25) {
            this.charging = false;
            this.userShoots(1);
          } else this.set({ charge: clamp(this.chargeTime / CHARGE_FULL, 0, 1) });
        }
      } else {
        // You are the keeper: the dive you hold when the taker strikes is the one you make.
        this.diveIntent = this.held.has('ArrowUp') ? -1 : this.held.has('ArrowDown') ? 1 : 0;
        if (this.t >= 2.2) this.cpuShoots();
      }
      return;
    }
    const plan = this.plan;
    if (s.phase === 'run' && plan) {
      // Run-up, strike.
      this.kicker.x += (SPOT_X - M(1.2) - this.kicker.x) * Math.min(1, dt * 7);
      if (this.t >= RUNUP) {
        this.t = 0;
        this.keeper.diveTimer = plan.dive !== 0 ? 0.7 : 0;
        this.keeper.diveDir = plan.dive;
        this.set({ phase: 'flight' });
      }
      return;
    }
    if (s.phase === 'flight' && plan) {
      const k = clamp(this.t / FLIGHT, 0, 1);
      this.ball.x = SPOT_X + (FIELD_W - SPOT_X + M(1)) * k;
      this.ball.y = this.fromY + (plan.y - this.fromY) * k;
      this.ball.z = plan.z * Math.sin(k * Math.PI * 0.5) + Math.sin(k * Math.PI) * M(0.25);
      // The keeper slides toward his dive.
      this.keeper.y = FIELD_H / 2 + plan.dive * M(2.4) * Math.min(1, k * 1.6);
      if (this.keeper.diveTimer! > 0) this.keeper.diveTimer! -= dt;
      if (k >= 1) {
        if (!plan.scored) {
          // Saved or missed: the ball drops where it stopped.
          this.ball.z = 0;
        }
        this.finishKick();
      }
      return;
    }
    if ((s.phase === 'result' || s.phase === 'done') && plan) {
      if (this.keeper.diveTimer! > 0) this.keeper.diveTimer! -= dt;
      this.ball.z = Math.max(0, this.ball.z - dt * M(3));
      if (s.phase === 'result' && this.t >= RESULT) this.beginKick(s.turn === 'home' ? 'away' : 'home', 0.6);
    }
  }

  // ---- drawing -------------------------------------------------------------

  private draw() {
    const kit = (p: PlayerEntity, team: TeamData, isHome: boolean) =>
      p.isGK ? team.gkKit : isHome ? team.kit : team.awayKit;
    const kickerIsHome = this.kickerTeam === this.home;
    renderScene(this.ctx, {
      camX: FIELD_W - 150,
      camY: FIELD_H / 2,
      ball: this.ball,
      players: [
        { p: this.keeper, kit: kit(this.keeper, this.keeperTeam, !kickerIsHome) },
        { p: this.kicker, kit: kit(this.kicker, this.kickerTeam, kickerIsHome) },
      ],
      controlled: this.state.turn === 'home' && this.state.phase === 'aim' ? this.kicker : null,
      switchHint: null,
      netRipple: { left: 0, right: this.ripple },
    });
    if (this.state.phase === 'aim' && this.state.turn === 'home') this.drawReticle();
  }

  /** For tests. */
  snapshotState() {
    return this.state;
  }

  /** The aim marker on the goal, in screen space. */
  private drawReticle() {
    const y = FIELD_H / 2 + (this.aimY * GOAL_HEIGHT) / 2;
    const z = this.aimHigh ? M(1.8) : M(0.35);
    const p = proj(FIELD_W, clamp(y, goalTop - 30, goalBottom + 30));
    const sy = p.y - z * p.s * 1.35;
    const c = this.ctx;
    c.save();
    c.lineWidth = 3;
    c.strokeStyle = '#c6ff2e';
    c.beginPath();
    c.arc(p.x, sy, 16 * p.s * 1.3, 0, Math.PI * 2);
    c.moveTo(p.x - 24 * p.s, sy);
    c.lineTo(p.x + 24 * p.s, sy);
    c.moveTo(p.x, sy - 24 * p.s);
    c.lineTo(p.x, sy + 24 * p.s);
    c.stroke();
    c.restore();
  }
}
