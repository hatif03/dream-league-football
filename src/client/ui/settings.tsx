import { createContext, useCallback, useContext, useEffect, useMemo, useRef, useState, type ReactNode } from 'react';
import { DEFAULT_BINDINGS, loadBindings, saveBindings, type KeyBindings } from '@/client/game/keybindings';
import { loadPad, loadTouch, savePad, saveTouch, type PadBindings, type TouchLayout, type TouchMode } from '@/client/game/inputDevices';
import { isMuted, setMuted } from './sfx';
import { SETTINGS_CHANGED, SETTINGS_REMOTE } from '@/client/api/settingsSync';

export type Difficulty = 'easy' | 'normal' | 'hard';
const DIFF_KEY = 'wc2026.difficulty';
const LEN_KEY = 'wc2026.matchSecs';
const REPLAYS_KEY = 'wc2026.replays';
const COMMENTARY_KEY = 'wc2026.commentary';

/** On unless the player switched it off. */
const readFlag = (key: string): boolean => {
  try {
    return localStorage.getItem(key) !== '0';
  } catch {
    return true;
  }
};
const writeFlag = (key: string, on: boolean) => {
  try {
    localStorage.setItem(key, on ? '1' : '0');
  } catch {
    /* storage unavailable */
  }
};
export const MATCH_LENGTHS = [180, 300, 480] as const;

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
  /** Real seconds a World Cup match lasts (90 football minutes). */
  matchSecs: number;
  setMatchSecs: (s: number) => void;
  /** Replay the lead-up to a goal after the celebration (World Cup and friendlies). */
  replays: boolean;
  setReplays: (on: boolean) => void;
  /** Text commentary lines during a match. */
  commentary: boolean;
  setCommentary: (on: boolean) => void;
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
  const [replays, setRep] = useState(() => readFlag(REPLAYS_KEY));
  const [commentary, setCom] = useState(() => readFlag(COMMENTARY_KEY));
  const [matchSecs, setLen] = useState<number>(() => {
    try {
      const v = Number(localStorage.getItem(LEN_KEY));
      return (MATCH_LENGTHS as readonly number[]).includes(v) ? v : 180;
    } catch {
      return 180;
    }
  });
  const readDifficulty = (): Difficulty => {
    try {
      const v = localStorage.getItem(DIFF_KEY);
      return v === 'easy' || v === 'hard' ? v : 'normal';
    } catch {
      return 'normal';
    }
  };
  const [difficulty, setD] = useState<Difficulty>(readDifficulty);

  // Settings from the account arrive after sign-in: reload everything from storage, and do not echo them back.
  const fromRemote = useRef(false);
  useEffect(() => {
    const reload = () => {
      fromRemote.current = true;
      setB(loadBindings());
      setP(loadPad());
      setT(loadTouch());
      setMu(isMuted());
      setRep(readFlag(REPLAYS_KEY));
      setCom(readFlag(COMMENTARY_KEY));
      setD(readDifficulty());
      try {
        const v = Number(localStorage.getItem(LEN_KEY));
        setLen((MATCH_LENGTHS as readonly number[]).includes(v) ? v : 180);
      } catch {
        /* storage unavailable */
      }
    };
    window.addEventListener(SETTINGS_REMOTE, reload);
    return () => window.removeEventListener(SETTINGS_REMOTE, reload);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

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
      matchSecs,
      setMatchSecs: (s) => {
        setLen(s);
        try {
          localStorage.setItem(LEN_KEY, String(s));
        } catch {
          /* storage unavailable */
        }
      },
      replays,
      setReplays: (on) => {
        setRep(on);
        writeFlag(REPLAYS_KEY, on);
      },
      commentary,
      setCommentary: (on) => {
        setCom(on);
        writeFlag(COMMENTARY_KEY, on);
      },
      muted,
      setSoundMuted: (m) => {
        setMuted(m);
        setMu(m);
      },
    }),
    [bindings, setBindings, pad, touch, difficulty, matchSecs, replays, commentary, muted],
  );
  // Any change the player makes is copied to their account (skipped on the first render and for remote loads).
  const first = useRef(true);
  useEffect(() => {
    if (first.current) {
      first.current = false;
      return;
    }
    if (fromRemote.current) {
      fromRemote.current = false;
      return;
    }
    window.dispatchEvent(new Event(SETTINGS_CHANGED));
  }, [bindings, pad, touch, difficulty, matchSecs, replays, commentary, muted]);

  return <Ctx.Provider value={value}>{children}</Ctx.Provider>;
}
