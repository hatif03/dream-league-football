import { createContext, useCallback, useContext, useMemo, useState, type ReactNode } from 'react';
import { DEFAULT_BINDINGS, loadBindings, saveBindings, type KeyBindings } from '@/client/game/keybindings';
import { loadPad, loadTouch, savePad, saveTouch, type PadBindings, type TouchLayout, type TouchMode } from '@/client/game/inputDevices';
import { isMuted, setMuted } from './sfx';

export type Difficulty = 'easy' | 'normal' | 'hard';
const DIFF_KEY = 'wc2026.difficulty';

interface Value {
  bindings: KeyBindings;
  setBindings: (b: KeyBindings) => void;
  resetBindings: () => void;
  pad: PadBindings;
  setPad: (p: PadBindings) => void;
  touch: { mode: TouchMode; layout: TouchLayout };
  setTouch: (t: { mode: TouchMode; layout: TouchLayout }) => void;
  difficulty: Difficulty;
  setDifficulty: (d: Difficulty) => void;
  muted: boolean;
  setSoundMuted: (m: boolean) => void;
}

const Ctx = createContext<Value | null>(null);

export function useSettings(): Value {
  const v = useContext(Ctx);
  if (!v) throw new Error('SettingsProvider missing');
  return v;
}

/** Everything a player can change, kept in this browser (localStorage), never on the server. */
export function SettingsProvider({ children }: { children: ReactNode }) {
  const [bindings, setB] = useState<KeyBindings>(() => loadBindings());
  const [pad, setP] = useState<PadBindings>(() => loadPad());
  const [touch, setT] = useState(() => loadTouch());
  const [muted, setMu] = useState(() => isMuted());
  const [difficulty, setD] = useState<Difficulty>(() => {
    try {
      const v = localStorage.getItem(DIFF_KEY);
      return v === 'easy' || v === 'hard' ? v : 'normal';
    } catch {
      return 'normal';
    }
  });

  const setBindings = useCallback((b: KeyBindings) => {
    setB(b);
    saveBindings(b);
  }, []);
  const value = useMemo<Value>(
    () => ({
      bindings,
      setBindings,
      resetBindings: () => setBindings({ ...DEFAULT_BINDINGS }),
      pad,
      setPad: (p) => {
        setP(p);
        savePad(p);
      },
      touch,
      setTouch: (t) => {
        setT(t);
        saveTouch(t);
      },
      difficulty,
      setDifficulty: (d) => {
        setD(d);
        try {
          localStorage.setItem(DIFF_KEY, d);
        } catch {
          /* storage unavailable */
        }
      },
      muted,
      setSoundMuted: (m) => {
        setMuted(m);
        setMu(m);
      },
    }),
    [bindings, setBindings, pad, touch, difficulty, muted],
  );
  return <Ctx.Provider value={value}>{children}</Ctx.Provider>;
}
