import { useEffect, useState, type ReactNode } from 'react';
import { RotateCcw } from 'lucide-react';
import { BINDING_GROUPS, DEFAULT_BINDINGS, assignKey, codeLabel, type GameAction } from '@/client/game/keybindings';
import {
  DEFAULT_PAD,
  DEFAULT_TOUCH,
  PAD_ACTIONS,
  TOUCH_ACTIONS,
  assignPad,
  captureNextPadButton,
  padLabel,
  useGamepadConnected,
  type PadAction,
  type TouchLayout,
  type TouchMode,
} from '@/client/game/inputDevices';
import { Btn } from './controls';
import { sfx } from './sfx';
import { MATCH_LENGTHS, useSettings, type Difficulty } from './settings';

export type SettingsTab = 'keyboard' | 'controller' | 'touch' | 'gameplay' | 'audio';
const LABELS: Record<SettingsTab, string> = { keyboard: 'Keyboard', controller: 'Controller', touch: 'Touch', gameplay: 'Gameplay', audio: 'Audio' };

/** Tabs and the panel for each. Used full-screen in Settings and inside the pause menu. */
export function SettingsPanels({ tabs = ['keyboard', 'controller', 'touch', 'gameplay', 'audio'], initial }: { tabs?: SettingsTab[]; initial?: SettingsTab }) {
  const [tab, setTab] = useState<SettingsTab>(initial ?? tabs[0]);
  return (
    <div>
      <div className="mb-4 flex flex-wrap gap-1 border-b border-white/10" role="tablist">
        {tabs.map((t) => (
          <button key={t} role="tab" aria-selected={tab === t} onClick={() => setTab(t)} className={`px-4 py-2 font-display text-lg font-bold uppercase italic tracking-wider ${tab === t ? 'border-b-[3px] border-neon-400 text-white' : 'text-mist-400 hover:text-white'}`}>
            {LABELS[t]}
          </button>
        ))}
      </div>
      {tab === 'keyboard' && <Keyboard />}
      {tab === 'controller' && <Controller />}
      {tab === 'touch' && <Touch />}
      {tab === 'gameplay' && <Gameplay />}
      {tab === 'audio' && <Audio />}
    </div>
  );
}

function Row({ label, children }: { label: string; children: ReactNode }) {
  return (
    <div className="flex items-center justify-between gap-3 rounded bg-white/5 px-3 py-2">
      <span className="font-body text-sm text-white">{label}</span>
      {children}
    </div>
  );
}

const keyBtn = (active: boolean) =>
  `min-w-[5.5rem] rounded px-3 py-1.5 font-display text-base font-bold uppercase tracking-wider transition-colors ${active ? 'animate-pulse bg-neon-400 text-ink-950' : 'bg-white/10 text-neon-300 hover:bg-white/20'}`;

function ResetRow({ disabled, onReset }: { disabled: boolean; onReset: () => void }) {
  return (
    <div className="mt-5">
      <Btn size="sm" disabled={disabled} onClick={onReset}><RotateCcw size={14} /> Reset to defaults</Btn>
    </div>
  );
}

function Keyboard() {
  const { bindings, setBindings, resetBindings } = useSettings();
  const [capturing, setCapturing] = useState<GameAction | null>(null);

  useEffect(() => {
    if (!capturing) return;
    const onKey = (e: KeyboardEvent) => {
      e.preventDefault();
      e.stopPropagation();
      if (e.code === 'Escape') return setCapturing(null);
      setBindings(assignKey(bindings, capturing, e.code));
      setCapturing(null);
      sfx.select();
    };
    // Capture phase so the menu navigation and the game never see this key.
    window.addEventListener('keydown', onKey, true);
    return () => window.removeEventListener('keydown', onKey, true);
  }, [capturing, bindings, setBindings]);

  const isDefault = (Object.keys(DEFAULT_BINDINGS) as GameAction[]).every((a) => bindings[a] === DEFAULT_BINDINGS[a]);
  return (
    <>
      <p className="mb-4 font-body text-sm text-mist-300">Pick an action, then press the key you want. <b className="text-white">Esc</b> cancels. Two actions never share a key.</p>
      <div className="grid gap-x-6 gap-y-5 md:grid-cols-2">
        {BINDING_GROUPS.map((g) => (
          <div key={g.title}>
            <h3 className="t-label mb-2">{g.title}</h3>
            <div className="space-y-1.5">
              {g.actions.map(({ action, label }) => (
                <Row key={action} label={label}>
                  <button className={keyBtn(capturing === action)} onClick={() => setCapturing((c) => (c === action ? null : action))}>
                    {capturing === action ? 'Press a key…' : codeLabel(bindings[action])}
                  </button>
                </Row>
              ))}
            </div>
          </div>
        ))}
      </div>
      <ResetRow disabled={isDefault} onReset={resetBindings} />
    </>
  );
}

function Controller() {
  const { pad, setPad } = useSettings();
  const connected = useGamepadConnected();
  const [capturing, setCapturing] = useState<PadAction | null>(null);

  useEffect(() => {
    if (!capturing) return;
    const abort = new AbortController();
    captureNextPadButton(abort.signal)
      .then((b) => {
        setPad(assignPad(pad, capturing, b));
        setCapturing(null);
        sfx.select();
      })
      .catch(() => {});
    return () => abort.abort();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [capturing]);

  const isDefault = (Object.keys(DEFAULT_PAD) as PadAction[]).every((a) => pad[a] === DEFAULT_PAD[a]);
  return (
    <>
      <p className={`mb-1 font-body text-sm ${connected ? 'text-win' : 'text-mist-300'}`}>{connected ? 'Controller connected.' : 'No controller detected. Connect one and press any button on it.'}</p>
      <p className="mb-4 font-body text-sm text-mist-300">The left stick or D-pad moves. Pick an action, then press the button you want for it.</p>
      <div className="grid gap-1.5 md:grid-cols-2">
        {PAD_ACTIONS.map(({ action, label }) => (
          <Row key={action} label={label}>
            <button className={keyBtn(capturing === action)} onClick={() => setCapturing((c) => (c === action ? null : action))}>
              {capturing === action ? 'Press a button…' : padLabel(pad[action])}
            </button>
          </Row>
        ))}
      </div>
      <ResetRow disabled={isDefault} onReset={() => setPad({ ...DEFAULT_PAD })} />
    </>
  );
}

function Touch() {
  const { touch, setTouch } = useSettings();
  const swap = (slot: number, action: GameAction) => {
    const layout = [...touch.layout] as TouchLayout;
    const other = layout.indexOf(action);
    if (other >= 0) layout[other] = layout[slot];
    layout[slot] = action;
    setTouch({ ...touch, layout });
  };
  const isDefault = touch.mode === 'auto' && touch.layout.every((a, i) => a === DEFAULT_TOUCH[i]);
  return (
    <>
      <p className="mb-3 font-body text-sm text-mist-300">A thumb stick and buttons appear over the pitch on touch screens. You can also force them on or off.</p>
      <div className="mb-5 flex gap-2" role="radiogroup" aria-label="On-screen controls">
        {(['auto', 'on', 'off'] as TouchMode[]).map((m) => (
          <button key={m} role="radio" aria-checked={touch.mode === m} onClick={() => setTouch({ ...touch, mode: m })} className={`rounded px-4 py-2 font-display text-sm font-bold uppercase tracking-wider ${touch.mode === m ? 'bg-neon-400 text-ink-950' : 'bg-white/10 text-mist-200 hover:bg-white/20'}`}>
            {m === 'auto' ? 'Auto' : m === 'on' ? 'Always on' : 'Off'}
          </button>
        ))}
      </div>
      <h3 className="t-label mb-2">Button layout</h3>
      <div className="grid gap-1.5 md:grid-cols-2">
        {touch.layout.map((action, slot) => (
          <Row key={slot} label={`Button ${slot + 1}`}>
            <select aria-label={`Button ${slot + 1} action`} className="field !min-h-9 !w-40" value={action} onChange={(e) => swap(slot, e.target.value as GameAction)}>
              {TOUCH_ACTIONS.map((a) => <option key={a.action} value={a.action}>{a.label}</option>)}
            </select>
          </Row>
        ))}
      </div>
      <ResetRow disabled={isDefault} onReset={() => setTouch({ mode: 'auto', layout: [...DEFAULT_TOUCH] as TouchLayout })} />
    </>
  );
}

function Gameplay() {
  const { difficulty, setDifficulty, matchSecs, setMatchSecs } = useSettings();
  const info: Record<Difficulty, string> = {
    easy: 'The CPU is a touch slower and less accurate. Good for learning.',
    normal: 'The CPU plays to its ratings.',
    hard: 'The CPU is quicker and sharper, and fouls more often.',
  };
  return (
    <>
      <h3 className="t-label mb-2">CPU difficulty</h3>
      <div className="grid max-w-md grid-cols-3 gap-2" role="radiogroup" aria-label="CPU difficulty">
        {(['easy', 'normal', 'hard'] as Difficulty[]).map((d) => (
          <button key={d} role="radio" aria-checked={difficulty === d} onClick={() => setDifficulty(d)} className={`rounded py-3 font-display text-lg font-bold uppercase tracking-wider ${difficulty === d ? 'bg-neon-400 text-ink-950' : 'bg-white/10 text-mist-200 hover:bg-white/20'}`}>{d}</button>
        ))}
      </div>
      <p className="mt-3 font-body text-sm text-mist-300">{info[difficulty]} Applies to World Cup matches and practice. Matches against friends are not affected.</p>

      <h3 className="t-label mb-2 mt-6">Match length (World Cup)</h3>
      <div className="grid max-w-md grid-cols-3 gap-2" role="radiogroup" aria-label="Match length">
        {MATCH_LENGTHS.map((s) => (
          <button key={s} role="radio" aria-checked={matchSecs === s} onClick={() => setMatchSecs(s)} className={`rounded py-3 font-display text-lg font-bold uppercase tracking-wider ${matchSecs === s ? 'bg-neon-400 text-ink-950' : 'bg-white/10 text-mist-200 hover:bg-white/20'}`}>{s / 60} min</button>
        ))}
      </div>
      <p className="mt-3 font-body text-sm text-mist-300">Real minutes for the full 90. There is a half-time break in the middle.</p>
    </>
  );
}

function Audio() {
  const { muted, setSoundMuted } = useSettings();
  return (
    <>
      <Row label="Sound effects (menu sounds, whistle, goal)">
        <button role="switch" aria-checked={!muted} onClick={() => { setSoundMuted(!muted); if (muted) setTimeout(sfx.select, 30); }} className={`relative h-8 w-14 rounded-full transition-colors ${muted ? 'bg-white/20' : 'bg-neon-400'}`}>
          <span className={`absolute top-1 h-6 w-6 rounded-full bg-white shadow transition-all ${muted ? 'left-1' : 'left-7'}`} />
          <span className="sr-only">{muted ? 'Off' : 'On'}</span>
        </button>
      </Row>
    </>
  );
}
