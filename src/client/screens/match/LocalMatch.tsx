import { useCallback, useEffect, useRef, useState } from 'react';
import { toast } from 'react-hot-toast';
import { useQueryClient } from '@tanstack/react-query';
import { PitchKickGame } from '@/client/game/engine';
import { PenaltyShootout, type ShootoutState } from '@/client/game/shootout';
import { nationId, type TeamData } from '@/client/game/teams';
import type { HudState } from '@/client/game/types';
import { touchEnabled } from '@/client/game/inputDevices';
import { useDeviceInput } from '@/client/game/useDeviceInput';
import { TouchControls } from '@/client/components/game/TouchControls';
import { ShootoutHud } from '@/client/components/game/ShootoutHud';
import { Btn } from '@/client/ui/controls';
import { useDialog } from '@/client/ui/Dialog';
import { MenuNav } from '@/client/ui/MenuNav';
import { ChargeBar, MatchHud } from '@/client/ui/MatchHud';
import { useSettings } from '@/client/ui/settings';
import { sfx } from '@/client/ui/sfx';
import { ROUND_NAMES, submitResult, type TournamentFixture } from '@/client/api/tournament';
import { CornerButtons, IntroCard, MatchStage, PauseMenu, ResultPanel, RotatePrompt } from './shared';
import { usePauseKeys } from './usePause';

const EMPTY_HUD: HudState = { homeScore: 0, awayScore: 0, clock: 0, message: '', possession: 'none', homePlayer: null, awayPlayer: null, charge: null, finished: false };
type Stage = 'intro' | 'playing' | 'shootout' | 'result';
type SaveState = 'idle' | 'saving' | 'saved' | 'error';

/** Practice and World Cup matches: everything runs in this browser. */
export function LocalMatch({
  kind,
  home,
  away,
  fixture,
  tournamentId,
  onExit,
}: {
  kind: 'practice' | 'worldcup';
  home: TeamData;
  away: TeamData;
  fixture?: TournamentFixture;
  tournamentId?: string;
  onExit: () => void;
}) {
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const engineRef = useRef<PitchKickGame | null>(null);
  const shootRef = useRef<PenaltyShootout | null>(null);
  const dialog = useDialog();
  const qc = useQueryClient();
  const { bindings, pad, touch, difficulty } = useSettings();
  const knockout = !!fixture && fixture.round !== 'group';

  const [stage, setStage] = useState<Stage>('intro');
  const [paused, setPaused] = useState(false);
  const [hud, setHud] = useState<HudState>(EMPTY_HUD);
  const [shoot, setShoot] = useState<ShootoutState | null>(null);
  const [saveState, setSaveState] = useState<SaveState>('idle');
  const [gameKey, setGameKey] = useState(0);
  const pensRef = useRef<{ home: number; away: number } | null>(null);
  const nonce = useRef(crypto.randomUUID());
  const lastMsg = useRef('');

  // Build the engine up front and show the kickoff formation behind the intro card.
  useEffect(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    setHud(EMPTY_HUD);
    setStage(gameKey === 0 ? 'intro' : 'playing');
    let game: PitchKickGame;
    if (kind === 'practice') {
      const pHome: TeamData = { ...home, players: home.players.slice(0, 5), kickoffFwd: 4 };
      const pAway: TeamData = { ...away, players: away.players.slice(0, 1), kickoffFwd: 0 };
      game = new PitchKickGame(canvas, setHud, pHome, pAway, { practice: true, bindings, difficulty });
    } else {
      game = new PitchKickGame(canvas, setHud, home, away, { bindings, knockout, difficulty });
    }
    engineRef.current = game;
    if (import.meta.env.DEV) (window as unknown as { __game: unknown }).__game = engineRef;
    game.start();
    if (gameKey === 0) {
      game.setPaused(true);
      game.previewFrame();
    }
    return () => {
      game.stop();
      engineRef.current = null;
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [gameKey]);

  useEffect(() => engineRef.current?.setBindings(bindings), [bindings]);

  const kickOff = () => {
    engineRef.current?.setPaused(false);
    sfx.whistle();
    setStage('playing');
  };

  const pause = useCallback((on: boolean) => {
    setPaused(on);
    engineRef.current?.setPaused(on);
    shootRef.current?.suspend(on);
  }, []);

  usePauseKeys(stage === 'playing' || stage === 'shootout', () => pause(!paused));
  useDeviceInput(() => engineRef.current, stage === 'playing' && !paused, paused, pad);

  // Sounds: goals and the final whistle.
  useEffect(() => {
    if (hud.message && hud.message !== lastMsg.current && /GOAL|SCORE/.test(hud.message)) sfx.goal();
    lastMsg.current = hud.message;
  }, [hud.message]);

  const userIsHome = fixture?.homeNation === nationId(home);
  const save = useCallback(async () => {
    if (!fixture || !tournamentId) return;
    const [h, a] = userIsHome ? [hud.homeScore, hud.awayScore] : [hud.awayScore, hud.homeScore];
    const pens = pensRef.current;
    const [hp, ap] = pens ? (userIsHome ? [pens.home, pens.away] : [pens.away, pens.home]) : [undefined, undefined];
    setSaveState('saving');
    try {
      const view = await submitResult(tournamentId, fixture.id, nonce.current, h, a, pens ? { homePens: hp, awayPens: ap, decidedBy: 'pens' } : { decidedBy: hud.extraTime ? 'et' : '90' });
      qc.setQueryData(['run'], view);
      setSaveState('saved');
    } catch (e) {
      setSaveState('error');
      toast.error((e as Error).message);
    }
  }, [fixture, tournamentId, userIsHome, hud.homeScore, hud.awayScore, hud.extraTime, qc]);

  // Full time: a knockout still level after extra time goes to penalties; anything else is saved.
  const tied = hud.homeScore === hud.awayScore;
  useEffect(() => {
    if (kind !== 'worldcup' || stage !== 'playing' || !hud.finished || saveState !== 'idle') return;
    sfx.whistle();
    engineRef.current?.stop();
    if (knockout && tied) {
      pensRef.current = null;
      setShoot(null);
      setStage('shootout');
    } else {
      setStage('result');
      void save();
    }
  }, [kind, stage, hud.finished, saveState, knockout, tied, save]);

  useEffect(() => {
    if (stage !== 'shootout' || !canvasRef.current) return;
    const game = new PenaltyShootout(canvasRef.current, setShoot, home, away, bindings);
    shootRef.current = game;
    if (import.meta.env.DEV) (window as unknown as { __shoot: unknown }).__shoot = shootRef;
    game.start();
    return () => {
      game.stop();
      shootRef.current = null;
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [stage]);
  useEffect(() => {
    if (stage === 'shootout' && shoot?.phase === 'done') {
      pensRef.current = { home: shoot.homeGoals, away: shoot.awayGoals };
      setStage('result');
      void save();
    }
  }, [stage, shoot, save]);

  const quit = async () => {
    if (kind === 'worldcup' && saveState !== 'saved') {
      const ok = await dialog.confirm({ title: 'Leave the match?', body: 'Nothing is saved and this fixture starts again at 0–0.', confirmLabel: 'Leave match', tone: 'danger' });
      if (!ok) return;
    }
    onExit();
  };

  const label = kind === 'practice' ? 'Practice' : fixture ? (fixture.round === 'group' ? `World Cup · Group ${fixture.groupName} · Matchday ${fixture.matchday}` : `World Cup · ${ROUND_NAMES[fixture.round]}`) : 'World Cup';
  const menuOpen = paused || stage === 'intro' || stage === 'result';
  const pens = pensRef.current;
  const winner = pens ? (pens.home > pens.away ? 'home' : 'away') : hud.homeScore > hud.awayScore ? 'home' : hud.homeScore < hud.awayScore ? 'away' : 'draw';
  const headline = winner === 'draw' ? 'Draw' : winner === 'home' ? 'Victory' : 'Defeat';

  return (
    <MatchStage canvasRef={canvasRef}>
      <MenuNav enabled={menuOpen} />
      {(stage === 'playing' || stage === 'shootout') && (
        <>
          {stage === 'playing' && <MatchHud home={home} away={away} hud={hud} scoreboard={kind !== 'practice'} tag={knockout && fixture ? ROUND_NAMES[fixture.round] : undefined} />}
          {stage === 'playing' && kind === 'practice' && <div className="absolute left-[max(0.75rem,env(safe-area-inset-left))] top-[max(0.75rem,env(safe-area-inset-top))] rounded-[3px] bg-neon-400 px-3 py-1.5 font-display text-sm font-extrabold uppercase italic tracking-[0.2em] text-ink-950">Practice</div>}
          {stage === 'shootout' && shoot && <ShootoutHud state={shoot} home={home} away={away} />}
          <ChargeBar charge={hud.charge} />
          <CornerButtons onPause={() => pause(true)} />
          {stage === 'playing' && touchEnabled(touch.mode) && !paused && <TouchControls sink={() => engineRef.current} layout={touch.layout} />}
        </>
      )}
      <RotatePrompt />

      {stage === 'intro' && <IntroCard home={home} away={away} label={label} sub={kind === 'practice' ? 'No clock, no rules. Just you, four teammates and a keeper.' : knockout ? 'Knockout: extra time and penalties if level after 90 minutes.' : undefined} onStart={kickOff} onBack={onExit} />}

      {paused && <PauseMenu onResume={() => pause(false)} onQuit={quit} onRestart={kind === 'practice' ? () => { pause(false); setGameKey((k) => k + 1); } : undefined} />}

      {stage === 'result' && kind === 'worldcup' && (
        <ResultPanel home={home} away={away} hud={hud} headline={headline} pens={pens} sub={saveState === 'saving' ? 'Saving your result…' : saveState === 'saved' ? 'Result saved to your World Cup.' : saveState === 'error' ? 'Could not save the result. Your score is kept: try again.' : undefined}>
          {saveState === 'error' && <Btn variant="primary" size="lg" onClick={save}>Retry save</Btn>}
          {saveState === 'saved' && <Btn variant="primary" size="lg" onClick={onExit} autoFocus data-autofocus>Continue</Btn>}
        </ResultPanel>
      )}
    </MatchStage>
  );
}
