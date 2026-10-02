import { useEffect, useState, type ReactNode, type Ref } from 'react';
import { Maximize, Pause } from 'lucide-react';
import { CANVAS_H, CANVAS_W } from '@/client/game/constants';
import { codeLabel } from '@/client/game/keybindings';
import { PAD_ACTIONS, padLabel, useLastDevice } from '@/client/game/inputDevices';
import { nationId, type TeamData } from '@/client/game/teams';
import type { HudState } from '@/client/game/types';
import { Btn } from '@/client/ui/controls';
import { Flag } from '@/client/ui/Flag';
import { StatsBars } from '@/client/ui/MatchHud';
import { SettingsPanels } from '@/client/ui/SettingsPanels';
import { useSettings } from '@/client/ui/settings';
import { KitJersey } from '@/client/components/game/TeamCrest';

/** Full-viewport pitch: the canvas scales to fit, overlays sit on top. */
export function MatchStage({ canvasRef, children }: { canvasRef: Ref<HTMLCanvasElement>; children?: ReactNode }) {
  return (
    <div className="fixed inset-0 z-40 overflow-hidden bg-[#050416] select-none touch-none" style={{ height: '100dvh' }}>
      <canvas ref={canvasRef} width={CANVAS_W} height={CANVAS_H} className="absolute inset-0 h-full w-full object-contain" aria-label="Football pitch" role="img" />
      {children}
    </div>
  );
}

/** Phones in portrait: ask for landscape. Dismissible. */
export function RotatePrompt() {
  const [portrait, setPortrait] = useState(false);
  const [dismissed, setDismissed] = useState(false);
  useEffect(() => {
    const mq = window.matchMedia('(orientation: portrait) and (pointer: coarse)');
    const f = () => setPortrait(mq.matches);
    f();
    mq.addEventListener('change', f);
    return () => mq.removeEventListener('change', f);
  }, []);
  if (!portrait || dismissed) return null;
  return (
    <div className="absolute inset-0 z-30 flex flex-col items-center justify-center gap-5 bg-ink-950/95 p-8 text-center" role="alert">
      <svg viewBox="0 0 64 64" className="h-24 w-24 animate-pulse text-neon-400" fill="none" stroke="currentColor" strokeWidth="3" aria-hidden="true">
        <rect x="20" y="8" width="24" height="48" rx="4" /><path d="M10 34a22 22 0 0 0 10 18M54 30a22 22 0 0 0-10-18" strokeLinecap="round" /><path d="M20 52l-2-6 6 1M44 12l2 6-6-1" strokeLinecap="round" strokeLinejoin="round" />
      </svg>
      <h2 className="t-display text-4xl text-white">Turn your phone sideways</h2>
      <p className="font-body text-mist-300">The pitch needs a wide screen. Rotate to landscape to play.</p>
      <Btn size="sm" onClick={() => setDismissed(true)}>Play anyway</Btn>
    </div>
  );
}

/** Pause button and fullscreen toggle in the corner. */
export function CornerButtons({ onPause }: { onPause: () => void }) {
  const canFs = typeof document !== 'undefined' && document.fullscreenEnabled;
  const toggleFs = async () => {
    try {
      if (document.fullscreenElement) await document.exitFullscreen();
      else {
        await document.documentElement.requestFullscreen();
        await (screen.orientation as unknown as { lock?: (o: string) => Promise<void> }).lock?.('landscape').catch(() => {});
      }
    } catch {
      /* fullscreen refused */
    }
  };
  return (
    <div className="absolute right-[max(0.75rem,env(safe-area-inset-right))] top-[max(0.75rem,env(safe-area-inset-top))] z-20 flex gap-2">
      {canFs && (
        <button className="flex h-10 w-10 items-center justify-center rounded-full bg-ink-950/70 text-white ring-1 ring-white/25 hover:bg-ink-950" aria-label="Toggle fullscreen" onClick={toggleFs}>
          <Maximize size={18} />
        </button>
      )}
      <button className="flex h-10 w-10 items-center justify-center rounded-full bg-ink-950/70 text-white ring-1 ring-white/25 hover:bg-ink-950" aria-label="Pause menu" onClick={onPause}>
        <Pause size={18} />
      </button>
    </div>
  );
}

/** Pause menu: resume, controls, quit. `friend` matches keep running behind it. */
export function PauseMenu({ friend, onResume, onQuit, onRestart }: { friend?: boolean; onResume: () => void; onQuit: () => void; onRestart?: () => void }) {
  const [view, setView] = useState<'menu' | 'controls'>('menu');
  const device = useLastDevice();
  return (
    <div className="absolute inset-0 z-50 flex items-center justify-center bg-ink-950/80 p-4 backdrop-blur-sm animate-fade-in">
      <div role="dialog" aria-modal="true" aria-label="Paused" data-nav-scope className="glass-solid max-h-[92dvh] w-full max-w-lg overflow-y-auto p-6 shadow-2xl animate-pop">
        {view === 'menu' ? (
          <>
            <div className="t-label">{friend ? 'Menu · the match keeps running' : 'Paused'}</div>
            <h2 className="t-display mb-5 text-5xl text-white">{friend ? 'Match menu' : 'Paused'}</h2>
            <div className="flex flex-col gap-3">
              <Btn variant="primary" size="lg" onClick={onResume} data-back data-autofocus autoFocus>Resume</Btn>
              <Btn size="lg" onClick={() => setView('controls')}>Controls & settings</Btn>
              {onRestart && <Btn size="lg" onClick={onRestart}>Restart</Btn>}
              <Btn variant="danger" size="lg" onClick={onQuit}>Quit match</Btn>
            </div>
          </>
        ) : (
          <>
            <div className="mb-3 flex items-center justify-between">
              <h2 className="t-display text-4xl text-white">Controls</h2>
              <Btn size="sm" data-back onClick={() => setView('menu')}>Back</Btn>
            </div>
            <SettingsPanels tabs={['keyboard', 'controller', 'touch', 'audio']} initial={device} />
          </>
        )}
      </div>
    </div>
  );
}

/** Before kickoff: both teams, and the controls for whatever the player is using. */
export function IntroCard({ home, away, label, sub, onStart, onBack }: { home: TeamData; away: TeamData; label: string; sub?: string; onStart: () => void; onBack: () => void }) {
  const { bindings, pad } = useSettings();
  const device = useLastDevice();
  const kb: [string, string][] = [
    ['Move', '← ↑ ↓ →'],
    ['Sprint', codeLabel(bindings.sprint)],
    ['Short pass', codeLabel(bindings.shortPass)],
    ['Long pass', codeLabel(bindings.longPass)],
    ['Through pass', codeLabel(bindings.throughPass)],
    ['Shot / tackle', codeLabel(bindings.shot)],
    ['Switch player', codeLabel(bindings.switchPlayer)],
    ['Contain', codeLabel(bindings.contain)],
  ];
  const pd: [string, string][] = [['Move', 'L-Stick'], ...PAD_ACTIONS.map(({ action, label: l }) => [l, padLabel(pad[action])] as [string, string])];
  const rows = device === 'controller' ? pd : kb;
  return (
    <div className="absolute inset-0 z-30 flex overflow-y-auto bg-gradient-to-br from-ink-950/95 via-ink-800/92 to-ink-950/95 p-4 backdrop-blur-sm animate-fade-in">
      <div className="m-auto w-full max-w-4xl">
        <div className="mb-3 text-center">
          <div className="t-label">{label}</div>
          {sub && <div className="font-body text-sm text-mist-300">{sub}</div>}
        </div>
        <div className="flex items-center justify-center gap-3 md:gap-8">
          <TeamSide team={home} />
          <span className="t-display text-5xl text-mist-500 md:text-8xl">VS</span>
          <TeamSide team={away} awayKit />
        </div>
        <div className="glass mx-auto mt-5 max-w-2xl p-4 [@media(max-height:520px)]:hidden">
          <h2 className="t-label mb-2 text-center">{device === 'touch' ? 'Touch controls' : device === 'controller' ? 'Controller' : 'Keyboard'}</h2>
          {device === 'touch' ? (
            <p className="text-center font-body text-sm text-mist-200">Drag the stick to move. Tap a button for a soft pass or shot; <b>hold</b> it to charge the power bar, release to kick.</p>
          ) : (
            <div className="grid grid-cols-2 gap-x-6 gap-y-1 sm:grid-cols-4">
              {rows.map(([l, k]) => (
                <div key={l} className="flex flex-col items-center gap-0.5 py-1">
                  <kbd className="rounded bg-white/15 px-2 py-0.5 font-display text-base font-bold text-white ring-1 ring-white/25">{k}</kbd>
                  <span className="font-body text-xs text-mist-300">{l}</span>
                </div>
              ))}
            </div>
          )}
          <p className="mt-2 text-center font-body text-xs text-mist-400">Hold a pass or shot button to charge power, release to kick. A quick tap is a soft touch.</p>
        </div>
        <div className="mt-5 flex items-center justify-center gap-3 [@media(max-height:520px)]:mt-3">
          <Btn data-back onClick={onBack}>Back</Btn>
          <Btn variant="primary" size="lg" onClick={onStart} autoFocus data-autofocus>▶ Kick off</Btn>
        </div>
      </div>
    </div>
  );
}

function TeamSide({ team, awayKit }: { team: TeamData; awayKit?: boolean }) {
  return (
    <div className="flex flex-1 flex-col items-center gap-2 text-center">
      <Flag nation={nationId(team)} className="h-12 w-[4.5rem] md:h-20 md:w-32" />
      <span className="t-display line-clamp-1 text-3xl text-white md:text-5xl">{team.name}</span>
      <span className="hidden desk:block"><KitJersey kit={awayKit ? team.awayKit : team.kit} /></span>
    </div>
  );
}

/** Full-time summary shared by every mode. Buttons come in as children. */
export function ResultPanel({
  home,
  away,
  hud,
  headline,
  sub,
  pens,
  label = 'Full time',
  showScore = true,
  children,
}: {
  home: TeamData;
  away: TeamData;
  hud: HudState;
  headline: string;
  sub?: ReactNode;
  pens?: { home: number; away: number } | null;
  label?: string;
  showScore?: boolean;
  children: ReactNode;
}) {
  return (
    <div className="absolute inset-0 z-30 flex overflow-y-auto bg-gradient-to-br from-ink-950/92 via-ink-800/90 to-ink-950/92 p-4 backdrop-blur-sm animate-fade-in" role="dialog" aria-label="Full time">
      <div className="m-auto w-full max-w-xl text-center">
        <div className="t-label">{label}</div>
        <h2 className="t-display text-5xl text-white md:text-7xl">{headline}</h2>
        {showScore && <div className="my-3 flex items-center justify-center gap-4">
          <Flag nation={nationId(home)} className="h-9 w-14" />
          <span className="t-display text-6xl tabular-nums text-white md:text-8xl">{hud.homeScore} <span className="text-mist-500">–</span> {hud.awayScore}</span>
          <Flag nation={nationId(away)} className="h-9 w-14" />
        </div>}
        {pens && (
          <p className="mb-2 font-body text-sm text-mist-200">{pens.home > pens.away ? home.name : away.name} win {Math.max(pens.home, pens.away)}–{Math.min(pens.home, pens.away)} on penalties</p>
        )}
        {hud.stats && <div className="glass my-4 p-4"><StatsBars stats={hud.stats} home={home.abbr} away={away.abbr} /></div>}
        {sub && <div className="mb-3 font-body text-sm text-mist-300" role="status">{sub}</div>}
        <div className="flex flex-wrap items-center justify-center gap-3">{children}</div>
      </div>
    </div>
  );
}
