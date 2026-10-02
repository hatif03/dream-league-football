import { createContext, useContext, useEffect, useMemo, useState, type ReactNode } from 'react';
import { useLastDevice } from '@/client/game/inputDevices';

export interface Hint {
  /** Keyboard key(s) and controller button, e.g. "Enter" / "A". */
  kb: string;
  pad: string;
  label: string;
}

export const DEFAULT_HINTS: Hint[] = [
  { kb: '← ↑ ↓ →', pad: 'D-pad', label: 'Move' },
  { kb: 'Enter', pad: 'A', label: 'Select' },
  { kb: 'Esc', pad: 'B', label: 'Back' },
  { kb: 'Q  E', pad: 'LB  RB', label: 'Tabs' },
];

const Ctx = createContext<{ hints: Hint[]; setHints: (h: Hint[]) => void }>({ hints: DEFAULT_HINTS, setHints: () => {} });

export function HintsProvider({ children }: { children: ReactNode }) {
  const [hints, setHints] = useState<Hint[]>(DEFAULT_HINTS);
  const value = useMemo(() => ({ hints, setHints }), [hints]);
  return <Ctx.Provider value={value}>{children}</Ctx.Provider>;
}

/** Screens call this to say what the buttons do right now (extra prompts go before the defaults). */
export function useHints(extra: Hint[] = [], deps: unknown[] = []) {
  const { setHints } = useContext(Ctx);
  useEffect(() => {
    setHints([...extra, ...DEFAULT_HINTS.filter((d) => !extra.some((x) => x.label === d.label || x.kb === d.kb))]);
    return () => setHints(DEFAULT_HINTS);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, deps);
}

/** The persistent footer: prompts shown with the glyphs of the device used last. */
export function HintBar() {
  const { hints } = useContext(Ctx);
  const device = useLastDevice();
  if (device === 'touch') return null;
  return (
    <footer className="safe-x hidden shrink-0 items-center justify-end gap-6 border-t border-white/10 bg-ink-950/60 py-2 desk:flex" aria-label="Controls">
      {hints.map((h) => (
        <span key={h.label} className="flex items-center gap-2 font-display text-sm font-semibold uppercase tracking-wider text-mist-300">
          <kbd className={`min-w-7 px-2 py-0.5 text-center text-xs text-white ${device === 'controller' ? 'rounded-full bg-neon-500/80' : 'rounded bg-white/15 ring-1 ring-white/30'}`}>
            {device === 'controller' ? h.pad : h.kb}
          </kbd>
          {h.label}
        </span>
      ))}
    </footer>
  );
}
