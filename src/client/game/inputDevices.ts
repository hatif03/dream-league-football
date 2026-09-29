// Controller and touch input. Both turn into the same canonical key codes the
// engine already reads (see keybindings.ts), so the engine never knows which device
// was used. Maps are stored per browser in localStorage; nothing goes to the server.

import { useSyncExternalStore } from 'react';
import { DEFAULT_BINDINGS, type GameAction } from './keybindings';

export interface KeySink {
  pressKey(code: string): void;
  releaseKey(code: string): void;
}

export type Device = 'keyboard' | 'controller' | 'touch';

// ---- last device used -------------------------------------------------------

let lastDevice: Device = typeof window !== 'undefined' && window.matchMedia?.('(pointer: coarse)').matches ? 'touch' : 'keyboard';
const deviceSubs = new Set<() => void>();
export function noteDevice(d: Device) {
  if (d === lastDevice) return;
  lastDevice = d;
  deviceSubs.forEach((s) => s());
}
/** The device the player touched last, so the legend can show the right controls. */
export function useLastDevice(): Device {
  return useSyncExternalStore(
    (cb) => {
      deviceSubs.add(cb);
      return () => deviceSubs.delete(cb);
    },
    () => lastDevice,
  );
}
if (typeof window !== 'undefined') {
  window.addEventListener('keydown', () => noteDevice('keyboard'), true);
  window.addEventListener('touchstart', () => noteDevice('touch'), { capture: true, passive: true });
}

// ---- controller ---------------------------------------------------------------

/** Actions a controller button can trigger (movement comes from the stick and D-pad). */
export type PadAction = Exclude<GameAction, 'moveUp' | 'moveDown' | 'moveLeft' | 'moveRight'>;
export type PadBindings = Record<PadAction, number>;

export const PAD_ACTIONS: { action: PadAction; label: string }[] = [
  { action: 'shot', label: 'Shot / Tackle' },
  { action: 'shortPass', label: 'Short pass' },
  { action: 'longPass', label: 'Long pass / Slide' },
  { action: 'throughPass', label: 'Through pass' },
  { action: 'sprint', label: 'Sprint' },
  { action: 'switchPlayer', label: 'Switch player / lob' },
  { action: 'contain', label: 'Contain (hold)' },
];

/** FIFA-style layout on a standard (Xbox-like) pad: A pass, B shot, X long, Y through, RB sprint, LB switch, LT contain. */
export const DEFAULT_PAD: PadBindings = {
  shortPass: 0,
  shot: 1,
  longPass: 2,
  throughPass: 3,
  switchPlayer: 4,
  sprint: 5,
  contain: 6,
};

const PAD_KEY = 'wc2026.padbindings';
const BUTTON_NAMES = ['A', 'B', 'X', 'Y', 'LB', 'RB', 'LT', 'RT', 'Back', 'Start', 'L3', 'R3', '↑', '↓', '←', '→'];
export const padLabel = (i: number) => BUTTON_NAMES[i] ?? `Btn ${i}`;

export function loadPad(): PadBindings {
  try {
    const raw = localStorage.getItem(PAD_KEY);
    if (raw) return { ...DEFAULT_PAD, ...JSON.parse(raw) };
  } catch {
    /* fall back to the defaults */
  }
  return { ...DEFAULT_PAD };
}
export function savePad(p: PadBindings) {
  try {
    localStorage.setItem(PAD_KEY, JSON.stringify(p));
  } catch {
    /* storage unavailable */
  }
}
/** Rebinds one action to a button and moves any action that held it onto the old button. */
export function assignPad(p: PadBindings, action: PadAction, button: number): PadBindings {
  const next = { ...p };
  const old = next[action];
  for (const a of Object.keys(next) as PadAction[]) if (next[a] === button) next[a] = old;
  next[action] = button;
  return next;
}

const STICK_DEADZONE = 0.4;

function activePad(): Gamepad | null {
  for (const g of navigator.getGamepads?.() ?? []) if (g && g.connected) return g;
  return null;
}

/** Polls the first connected pad every frame and feeds it to the sink as key presses. */
export class GamepadInput {
  private raf = 0;
  private running = false;
  private down = new Set<string>();
  private suspended = false;
  constructor(
    private sink: () => KeySink | null,
    private pad: () => PadBindings,
  ) {}

  start() {
    if (this.running) return;
    this.running = true;
    this.raf = requestAnimationFrame(this.tick);
  }
  stop() {
    this.running = false;
    cancelAnimationFrame(this.raf);
    this.apply(new Set());
  }
  suspend(on: boolean) {
    this.suspended = on;
    if (on) this.apply(new Set());
  }

  private tick = () => {
    if (!this.running) return;
    const want = new Set<string>();
    const g = this.suspended ? null : activePad();
    if (g) {
      const x = g.axes[0] ?? 0;
      const y = g.axes[1] ?? 0;
      const b = (i: number) => !!g.buttons[i]?.pressed;
      if (y < -STICK_DEADZONE || b(12)) want.add(DEFAULT_BINDINGS.moveUp);
      if (y > STICK_DEADZONE || b(13)) want.add(DEFAULT_BINDINGS.moveDown);
      if (x < -STICK_DEADZONE || b(14)) want.add(DEFAULT_BINDINGS.moveLeft);
      if (x > STICK_DEADZONE || b(15)) want.add(DEFAULT_BINDINGS.moveRight);
      const pad = this.pad();
      for (const { action } of PAD_ACTIONS) if (b(pad[action])) want.add(DEFAULT_BINDINGS[action]);
      if (want.size) noteDevice('controller');
    }
    this.apply(want);
    this.raf = requestAnimationFrame(this.tick);
  };

  private apply(want: Set<string>) {
    const sink = this.sink();
    if (!sink) {
      this.down = new Set();
      return;
    }
    for (const c of want) if (!this.down.has(c)) sink.pressKey(c);
    for (const c of this.down) if (!want.has(c)) sink.releaseKey(c);
    this.down = want;
  }
}

/** Resolves with the next controller button pressed, for the rebinding screen. */
export function captureNextPadButton(signal: AbortSignal): Promise<number> {
  return new Promise((resolve, reject) => {
    const was = new Set<number>();
    const g0 = activePad();
    g0?.buttons.forEach((b, i) => b.pressed && was.add(i));
    const poll = () => {
      if (signal.aborted) return reject(new Error('cancelled'));
      const g = activePad();
      if (g) {
        for (let i = 0; i < g.buttons.length; i++) {
          if (g.buttons[i].pressed && !was.has(i)) return resolve(i);
          if (!g.buttons[i].pressed) was.delete(i);
        }
      }
      requestAnimationFrame(poll);
    };
    poll();
  });
}

export function useGamepadConnected(): boolean {
  return useSyncExternalStore(
    (cb) => {
      window.addEventListener('gamepadconnected', cb);
      window.addEventListener('gamepaddisconnected', cb);
      return () => {
        window.removeEventListener('gamepadconnected', cb);
        window.removeEventListener('gamepaddisconnected', cb);
      };
    },
    () => !!activePad(),
  );
}

// ---- touch --------------------------------------------------------------------

export type TouchMode = 'auto' | 'on' | 'off';
/** The on-screen buttons, in order, and which action each one triggers. */
export type TouchLayout = [GameAction, GameAction, GameAction, GameAction, GameAction, GameAction, GameAction];
export const DEFAULT_TOUCH: TouchLayout = ['shot', 'shortPass', 'longPass', 'throughPass', 'sprint', 'switchPlayer', 'contain'];
export const TOUCH_ACTIONS: { action: GameAction; label: string }[] = [
  { action: 'shot', label: 'Shot' },
  { action: 'shortPass', label: 'Pass' },
  { action: 'longPass', label: 'Long' },
  { action: 'throughPass', label: 'Through' },
  { action: 'sprint', label: 'Sprint' },
  { action: 'switchPlayer', label: 'Switch' },
  { action: 'contain', label: 'Contain' },
];

const TOUCH_KEY = 'wc2026.touch';

export function loadTouch(): { mode: TouchMode; layout: TouchLayout } {
  try {
    const raw = localStorage.getItem(TOUCH_KEY);
    if (raw) {
      const v = JSON.parse(raw);
      return { mode: v.mode ?? 'auto', layout: Array.isArray(v.layout) && v.layout.length === 7 ? v.layout : [...DEFAULT_TOUCH] };
    }
  } catch {
    /* defaults */
  }
  return { mode: 'auto', layout: [...DEFAULT_TOUCH] as TouchLayout };
}
export function saveTouch(t: { mode: TouchMode; layout: TouchLayout }) {
  try {
    localStorage.setItem(TOUCH_KEY, JSON.stringify(t));
  } catch {
    /* storage unavailable */
  }
}

/** Show the on-screen controls on touch screens, or when the player chose them. */
export function touchEnabled(mode: TouchMode): boolean {
  if (mode === 'on') return true;
  if (mode === 'off') return false;
  return typeof matchMedia !== 'undefined' && matchMedia('(pointer: coarse)').matches;
}
