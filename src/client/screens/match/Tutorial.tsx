import { useEffect, useRef, useState } from 'react';
import { codeLabel } from '@/client/game/keybindings';
import { padLabel, useLastDevice } from '@/client/game/inputDevices';
import type { HudState } from '@/client/game/types';
import { Btn } from '@/client/ui/controls';
import { useSettings } from '@/client/ui/settings';
import { sfx } from '@/client/ui/sfx';
import type { PitchKickGame } from '@/client/game/engine';

const DONE_KEY = 'wc2026.tutorialDone';
export const tutorialDone = (): boolean => {
  try {
    return localStorage.getItem(DONE_KEY) === '1';
  } catch {
    return false;
  }
};
const markDone = () => {
  try {
    localStorage.setItem(DONE_KEY, '1');
    window.dispatchEvent(new Event('wc2026:settings'));
  } catch {
    /* storage unavailable */
  }
};

type Probe = ReturnType<PitchKickGame['tutorialProbe']>;
interface Step {
  title: string;
  /** What to do, worded for the device in use. */
  text: (k: (action: Action) => string, device: 'keyboard' | 'controller' | 'touch') => string;
  done: (p: Probe, hud: HudState) => boolean;
  /** An information step the player confirms with a button. */
  manual?: boolean;
}
type Action = 'move' | 'sprint' | 'shortPass' | 'longPass' | 'throughPass' | 'shot' | 'contain' | 'switchPlayer';

const STEPS: Step[] = [
  { title: 'Move', text: (k, d) => (d === 'touch' ? 'Drag the stick on the left to run around.' : d === 'controller' ? 'Push the left stick to run around.' : `Use ${k('move')} to run around the pitch.`), done: (p) => p.moved > 320 },
  { title: 'Sprint', text: (k, d) => (d === 'touch' ? `Run while holding ${k('sprint')}.` : `Hold ${k('sprint')} while you run.`), done: (p) => p.sprint > 1.2 },
  { title: 'Short pass', text: (k) => `Tap ${k('shortPass')} to pass to a team-mate. Hold it longer for a firmer pass. Do it twice.`, done: (p) => (p.kicks.KeyS ?? 0) >= 2 },
  { title: 'Through or long ball', text: (k) => `Play a through pass into space with ${k('throughPass')}, or a high long pass with ${k('longPass')}.`, done: (p) => (p.kicks.KeyW ?? 0) + (p.kicks.KeyA ?? 0) >= 1 },
  { title: 'Shoot', text: (k) => `Hold ${k('shot')} to charge the power bar, then release to shoot. Hold up or down first to aim at a corner.`, done: (p) => (p.kicks.KeyD ?? 0) >= 1 },
  { title: 'Score a goal', text: () => 'Get the ball past the keeper. Take your time and pick your spot.', done: (_p, hud) => hud.homeScore >= 1 },
  { title: 'Defending', text: (k) => `Without the ball: ${k('shot')} tackles, ${k('longPass')} slides (risky), hold ${k('contain')} to jockey, ${k('switchPlayer')} switches player.`, done: () => false, manual: true },
];

/** A coach on the pitch: shows one thing to try at a time and moves on when the player does it. */
export function Tutorial({ engine, hud, onClose }: { engine: () => PitchKickGame | null; hud: HudState; onClose: () => void }) {
  const { bindings, pad } = useSettings();
  const device = useLastDevice();
  const [step, setStep] = useState(0);
  const [flash, setFlash] = useState(false);
  const hudRef = useRef(hud);
  hudRef.current = hud;
  const engineFn = useRef(engine);
  engineFn.current = engine;

  const label = (a: Action): string => {
    if (a === 'move') return '← ↑ ↓ →';
    if (device === 'touch') return ({ sprint: 'SPRINT', shortPass: 'PASS', longPass: 'LONG', throughPass: 'THROUGH', shot: 'SHOT', contain: 'CONTAIN', switchPlayer: 'SWITCH' } as Record<string, string>)[a];
    if (device === 'controller') return padLabel(pad[a as Exclude<Action, 'move'>]);
    return codeLabel(bindings[a as Exclude<Action, 'move'>]);
  };

  const s = STEPS[step];
  useEffect(() => {
    if (!s || s.manual || flash) return;
    const t = window.setInterval(() => {
      const probe = engineFn.current()?.tutorialProbe();
      if (probe && s.done(probe, hudRef.current)) {
        window.clearInterval(t);
        sfx.select();
        setFlash(true);
        window.setTimeout(() => {
          setFlash(false);
          setStep((n) => n + 1);
        }, 900);
      }
    }, 250);
    return () => window.clearInterval(t);
  }, [s, flash]);

  const finished = step >= STEPS.length;
  useEffect(() => {
    if (finished) markDone();
  }, [finished]);

  return (
    <div className="pointer-events-none absolute inset-x-0 top-[max(0.75rem,env(safe-area-inset-top))] z-20 flex justify-center px-3" role="region" aria-label="Tutorial">
      <div className="glass-solid pointer-events-auto w-full max-w-xl p-3 shadow-2xl animate-pop sm:p-4">
        {finished ? (
          <div className="flex flex-wrap items-center gap-3">
            <div className="min-w-0 flex-1">
              <div className="t-label text-win">Tutorial complete</div>
              <div className="font-body text-sm text-mist-200">You know the basics. Keep practising, or go and play a match.</div>
            </div>
            <Btn size="sm" variant="primary" onClick={onClose}>Done</Btn>
          </div>
        ) : (
          <>
            <div className="mb-1 flex items-center justify-between gap-3">
              <div className="t-label">Step {step + 1} of {STEPS.length}</div>
              <button className="font-body text-xs text-mist-400 underline hover:text-white" onClick={onClose}>Skip tutorial</button>
            </div>
            <div className="flex items-center gap-3">
              <div className="min-w-0 flex-1">
                <div className={`t-display text-2xl ${flash ? 'text-win' : 'text-white'}`}>{flash ? 'Nice!' : s.title}</div>
                <p className="font-body text-sm text-mist-200">{s.text(label, device)}</p>
              </div>
              {s.manual && <Btn size="sm" variant="primary" onClick={() => setStep((n) => n + 1)}>Got it</Btn>}
            </div>
            <div className="mt-2 flex gap-1" aria-hidden="true">
              {STEPS.map((_, i) => <span key={i} className={`h-1 flex-1 rounded-full ${i < step ? 'bg-win' : i === step ? 'bg-neon-400' : 'bg-white/15'}`} />)}
            </div>
          </>
        )}
      </div>
    </div>
  );
}
