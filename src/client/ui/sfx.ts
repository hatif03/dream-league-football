// Tiny synthesised sound effects (Web Audio): no files to download. Browsers only start
// audio after a user gesture, so the context is created lazily on the first sound.

const KEY = 'wc2026.sound';
let ctx: AudioContext | null = null;
let muted = (() => {
  try {
    return localStorage.getItem(KEY) === 'off';
  } catch {
    return false;
  }
})();

export const isMuted = () => muted;
export function setMuted(m: boolean) {
  muted = m;
  try {
    localStorage.setItem(KEY, m ? 'off' : 'on');
  } catch {
    /* storage unavailable */
  }
}

function audio(): AudioContext | null {
  if (muted || typeof AudioContext === 'undefined') return null;
  ctx ??= new AudioContext();
  if (ctx.state === 'suspended') void ctx.resume();
  return ctx;
}

function tone(freq: number, dur: number, type: OscillatorType = 'sine', gain = 0.06, when = 0, slideTo?: number) {
  const c = audio();
  if (!c) return;
  const t0 = c.currentTime + when;
  const o = c.createOscillator();
  const g = c.createGain();
  o.type = type;
  o.frequency.setValueAtTime(freq, t0);
  if (slideTo) o.frequency.exponentialRampToValueAtTime(slideTo, t0 + dur);
  g.gain.setValueAtTime(0.0001, t0);
  g.gain.exponentialRampToValueAtTime(gain, t0 + 0.01);
  g.gain.exponentialRampToValueAtTime(0.0001, t0 + dur);
  o.connect(g).connect(c.destination);
  o.start(t0);
  o.stop(t0 + dur + 0.02);
}

export const sfx = {
  /** Focus moved. */
  move: () => tone(620, 0.05, 'triangle', 0.035),
  /** Confirmed. */
  select: () => {
    tone(520, 0.07, 'square', 0.04);
    tone(780, 0.1, 'square', 0.04, 0.06);
  },
  back: () => tone(420, 0.09, 'triangle', 0.045, 0, 300),
  error: () => tone(180, 0.18, 'sawtooth', 0.05),
  /** A friend joined, an invite arrived. */
  notify: () => {
    tone(880, 0.09, 'sine', 0.05);
    tone(1175, 0.14, 'sine', 0.05, 0.09);
  },
  tick: () => tone(700, 0.06, 'square', 0.04),
  /** Referee whistle: a warbling high tone. */
  whistle: () => {
    tone(2900, 0.5, 'sine', 0.05, 0, 3100);
    tone(3050, 0.5, 'sine', 0.03, 0.02, 2800);
  },
  goal: () => {
    [523, 659, 784, 1046].forEach((f, i) => tone(f, 0.22, 'triangle', 0.06, i * 0.09));
  },
};
