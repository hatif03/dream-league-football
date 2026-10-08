import type { GameEventKind } from '@/client/game/types';
import { audioContext, isMuted } from './sfx';

// Stadium crowd, made from filtered noise (no audio files): a murmur that swells for a goal, gasps at a
// shot or a save, and groans at a foul. Stays quiet while sound is off. Started from the kickoff button so
// the browser lets it play.

interface Nodes {
  src: AudioBufferSourceNode;
  gain: GainNode;
  filter: BiquadFilterNode;
}
let nodes: Nodes | null = null;
const BASE = 0.03;

function noise(ctx: AudioContext): AudioBuffer {
  const len = ctx.sampleRate * 3;
  const buf = ctx.createBuffer(1, len, ctx.sampleRate);
  const d = buf.getChannelData(0);
  let last = 0;
  for (let i = 0; i < len; i++) {
    // Brown-ish noise: a low rumble with some hiss, like a distant crowd.
    last = (last + 0.04 * (Math.random() * 2 - 1)) / 1.04;
    d[i] = last * 6;
  }
  return buf;
}

function swell(peak: number, up: number, down: number, freq?: number) {
  const ctx = audioContext();
  if (!nodes || !ctx || isMuted()) return;
  const t = ctx.currentTime;
  const g = nodes.gain.gain;
  g.cancelScheduledValues(t);
  g.setValueAtTime(Math.max(g.value, 0.0001), t);
  g.linearRampToValueAtTime(peak, t + up);
  g.exponentialRampToValueAtTime(BASE, t + up + down);
  if (freq) {
    const f = nodes.filter.frequency;
    f.cancelScheduledValues(t);
    f.setValueAtTime(f.value, t);
    f.linearRampToValueAtTime(freq, t + up);
    f.linearRampToValueAtTime(500, t + up + down);
  }
}

export const crowd = {
  start() {
    const ctx = audioContext();
    if (nodes || !ctx) return;
    const src = ctx.createBufferSource();
    src.buffer = noise(ctx);
    src.loop = true;
    const filter = ctx.createBiquadFilter();
    filter.type = 'bandpass';
    filter.frequency.value = 500;
    filter.Q.value = 0.6;
    const gain = ctx.createGain();
    gain.gain.value = BASE;
    src.connect(filter).connect(gain).connect(ctx.destination);
    src.start();
    nodes = { src, gain, filter };
  },
  stop() {
    if (!nodes) return;
    try {
      nodes.src.stop();
      nodes.src.disconnect();
      nodes.gain.disconnect();
    } catch {
      /* already stopped */
    }
    nodes = null;
  },
  /** React to something that happened in the match. */
  react(kind: GameEventKind, forMe: boolean) {
    switch (kind) {
      case 'goal':
        swell(forMe ? 0.2 : 0.09, 0.3, 3.8, forMe ? 1100 : 600);
        break;
      case 'save':
      case 'shot':
        swell(0.1, 0.15, 1.4, 900);
        break;
      case 'penalty':
        swell(0.09, 0.4, 2.4, 800);
        break;
      case 'foul':
      case 'yellow':
      case 'red':
      case 'offside':
        swell(0.07, 0.1, 1.2, 380);
        break;
      case 'halftime':
      case 'fulltime':
        swell(0.14, 0.5, 3.5, 900);
        break;
      default:
        break;
    }
  },
};
