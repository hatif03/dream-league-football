import { useCallback, useEffect, useRef, useState } from 'react';
import { toast } from 'react-hot-toast';
import { PitchKickGame } from '@/client/game/engine';
import { GuestView } from '@/client/game/guestView';
import { teamById } from '@/client/game/teams';
import type { HudState } from '@/client/game/types';
import { touchEnabled } from '@/client/game/inputDevices';
import { useDeviceInput } from '@/client/game/useDeviceInput';
import { TouchControls } from '@/client/components/game/TouchControls';
import { Btn, Spinner } from '@/client/ui/controls';
import { useDialog } from '@/client/ui/Dialog';
import { MenuNav } from '@/client/ui/MenuNav';
import { ChargeBar, MatchHud } from '@/client/ui/MatchHud';
import { useSettings } from '@/client/ui/settings';
import { sfx } from '@/client/ui/sfx';
import {
  claimResult,
  getMatch,
  leaveMatch,
  leaveMatchOnUnload,
  rematch,
  type LobbyView,
  type MatchView,
} from '@/client/api/friend';
import { blockPlayer, reportPlayer } from '@/client/api/social';
import { connectMatch, type Link } from '@/client/net/peerMatch';
import { CornerButtons, MatchStage, PauseMenu, ResultPanel, RotatePrompt } from './shared';
import { usePauseKeys } from './usePause';

const EMPTY_HUD: HudState = { homeScore: 0, awayScore: 0, clock: 0, message: '', possession: 'none', homePlayer: null, awayPlayer: null, charge: null, finished: false };
const RECONNECT_MS = 25_000;
const RESULT_POLL_MS = 1500;
const RESULT_WAIT_MS = 70_000;
const LIVE_POLL_MS = 3000;

type Phase = 'connecting' | 'playing' | 'lost' | 'waitResult' | 'result' | 'failed';

/**
 * One online friend match. The host's browser runs the simulation (`PitchKickGame` with a
 * guest seat); the guest's browser only draws snapshots (`GuestView`). Both sign the final
 * score with Serverpod. Leaving is announced at once, to the server and to the opponent.
 */
export function FriendMatchStage({ view, onExit, onRematch }: { view: LobbyView; onExit: () => void; onRematch: (next: LobbyView) => void }) {
  const matchId = view.lobby.matchId!;
  const role = view.youAreHost ? 'host' : 'guest';
  const hostTeam = teamById(view.lobby.hostNation ?? '')!;
  const guestTeam = teamById(view.lobby.guestNation ?? '')!;
  const home = view.youAreHost ? hostTeam : guestTeam;
  const away = view.youAreHost ? guestTeam : hostTeam;
  const homeName = view.youAreHost ? view.hostName : (view.guestName ?? 'You');
  const awayName = view.youAreHost ? (view.guestName ?? 'Opponent') : view.hostName;
  const opponentName = awayName;
  const { bindings, pad, touch } = useSettings();
  const dialog = useDialog();

  const canvasRef = useRef<HTMLCanvasElement>(null);
  const engineRef = useRef<PitchKickGame | null>(null);
  const guestRef = useRef<GuestView | null>(null);
  const linkRef = useRef<Link | null>(null);
  const abortRef = useRef(new AbortController());
  const claimedRef = useRef(false);
  const doneRef = useRef(false); // result known: nothing left to report on unload
  const hudRef = useRef<HudState>(EMPTY_HUD);
  if (import.meta.env.DEV) (window as unknown as { __fm: unknown }).__fm = { engineRef, guestRef, linkRef, hudRef };

  const [phase, setPhase] = useState<Phase>('connecting');
  const [status, setStatus] = useState('Connecting to your opponent…');
  const [hud, setHudState] = useState<HudState>(EMPTY_HUD);
  const [result, setResult] = useState<MatchView | null>(null);
  const [menu, setMenu] = useState(false);
  const lastMsg = useRef('');

  const setHud = useCallback((h: HudState) => {
    hudRef.current = h;
    setHudState(h);
  }, []);

  // ---- result ------------------------------------------------------------

  const showResult = useCallback((m: MatchView) => {
    doneRef.current = true;
    setResult(m);
    setPhase('result');
  }, []);

  const waitForResult = useCallback(async () => {
    setPhase('waitResult');
    const until = Date.now() + RESULT_WAIT_MS;
    while (!abortRef.current.signal.aborted && Date.now() < until) {
      try {
        const m = await getMatch(matchId);
        if (m.match.status !== 'live') return showResult(m);
      } catch {
        /* keep polling */
      }
      await new Promise((r) => setTimeout(r, RESULT_POLL_MS));
    }
    if (!abortRef.current.signal.aborted) setPhase('failed');
  }, [matchId, showResult]);

  const sign = useCallback(
    async (reason: 'fulltime' | 'abandoned') => {
      if (claimedRef.current) return;
      claimedRef.current = true;
      const h = hudRef.current;
      const [hostGoals, guestGoals] = view.youAreHost ? [h.homeScore, h.awayScore] : [h.awayScore, h.homeScore];
      try {
        const stats = view.youAreHost && reason === 'fulltime' && h.stats ? JSON.stringify(h.stats) : undefined;
        await claimResult(matchId, hostGoals, guestGoals, reason, stats);
      } catch (e) {
        toast.error((e as Error).message);
      }
      await waitForResult();
    },
    [matchId, view.youAreHost, waitForResult],
  );

  // ---- connection ------------------------------------------------------------

  /** The opponent said goodbye (or the server says they left): show it right away. */
  const opponentLeft = useCallback(async () => {
    if (doneRef.current) return;
    claimedRef.current = true;
    sfx.notify();
    engineRef.current?.setPaused(true);
    try {
      const m = await getMatch(matchId);
      if (m.match.status !== 'live') return showResult(m);
    } catch {
      /* fall through to waiting */
    }
    await waitForResult();
  }, [matchId, showResult, waitForResult]);

  const attach = useCallback(
    (link: Link) => {
      linkRef.current = link;
      link.onBye = () => void opponentLeft();
      if (role === 'host') {
        const engine = engineRef.current!;
        link.onInput = (m) => engine.guestInput(m.held, m.pressed, m.released);
        engine.setSnapshotSink((s) => link.sendSnapshot(s), 30);
      } else {
        link.onSnapshot = (s) => guestRef.current?.pushSnapshot(s);
      }
      link.onClose = (reason) => {
        if (claimedRef.current || doneRef.current || abortRef.current.signal.aborted) return;
        void recover(reason);
      };
    },
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [role, opponentLeft],
  );

  const recover = useCallback(
    async (reason: string) => {
      setPhase('lost');
      setStatus(`Connection lost (${reason}). Trying to get ${opponentName} back…`);
      if (role === 'host') engineRef.current?.setPaused(true);
      const signal = AbortSignal.any([abortRef.current.signal, AbortSignal.timeout(RECONNECT_MS)]);
      try {
        const link = await connectMatch(matchId, role, signal, setStatus);
        attach(link);
        if (role === 'host') engineRef.current?.setPaused(false);
        setPhase('playing');
      } catch {
        if (abortRef.current.signal.aborted || doneRef.current) return;
        setStatus(`${opponentName} did not come back.`);
        await sign('abandoned');
      }
    },
    [attach, matchId, role, sign, opponentName],
  );

  useEffect(() => {
    const abort = (abortRef.current = new AbortController());
    const canvas = canvasRef.current!;
    if (role === 'host') {
      engineRef.current = new PitchKickGame(canvas, setHud, hostTeam, guestTeam, { bindings, guestSeat: true });
    } else {
      guestRef.current = new GuestView(canvas, setHud, hostTeam, guestTeam, (m) => linkRef.current?.sendInput(m), bindings);
    }
    connectMatch(matchId, role, abort.signal, setStatus)
      .then((link) => {
        attach(link);
        engineRef.current?.start();
        engineRef.current?.enableBackgroundTicks();
        guestRef.current?.start();
        sfx.whistle();
        setPhase('playing');
      })
      .catch((e: Error) => {
        if (abort.signal.aborted) return;
        setStatus(e.message || 'Could not connect.');
        setPhase('failed');
      });
    return () => {
      abort.abort();
      engineRef.current?.stop();
      engineRef.current = null;
      guestRef.current?.stop();
      guestRef.current = null;
      linkRef.current?.close();
      linkRef.current = null;
    };
    // The match is fixed for the lifetime of this component.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [matchId]);

  // Closing the tab or reloading counts as leaving: tell the server now, not after a timeout.
  useEffect(() => {
    const onHide = () => {
      if (!doneRef.current && !claimedRef.current) leaveMatchOnUnload(matchId);
    };
    window.addEventListener('pagehide', onHide);
    return () => window.removeEventListener('pagehide', onHide);
  }, [matchId]);

  // Watch the server too: it knows if the opponent left, was voided, or the match ended.
  useEffect(() => {
    if (phase !== 'playing' && phase !== 'lost') return;
    const t = window.setInterval(async () => {
      try {
        const m = await getMatch(matchId);
        if (m.match.status !== 'live' && !doneRef.current) {
          claimedRef.current = true;
          showResult(m);
        }
      } catch {
        /* ignore */
      }
    }, LIVE_POLL_MS);
    return () => window.clearInterval(t);
  }, [phase, matchId, showResult]);

  useEffect(() => engineRef.current?.setBindings(bindings), [bindings]);
  useEffect(() => {
    engineRef.current?.suspendInput(menu);
    guestRef.current?.suspendInput(menu);
  }, [menu, phase]);

  usePauseKeys(phase === 'playing' || phase === 'lost', () => setMenu((m) => !m));
  const sink = () => engineRef.current ?? guestRef.current;
  useDeviceInput(sink, phase === 'playing' && !menu, menu, pad);

  useEffect(() => {
    if (hud.message && hud.message !== lastMsg.current && /GOAL|SCORE/.test(hud.message)) sfx.goal();
    lastMsg.current = hud.message;
  }, [hud.message]);

  // Full time: sign the score. The guest signs only a stream that looked like a real match.
  useEffect(() => {
    if (!hud.finished || phase !== 'playing') return;
    sfx.whistle();
    if (role === 'guest' && guestRef.current && !guestRef.current.trusted()) {
      claimedRef.current = true;
      toast.error('The match data looked wrong, so your result was not signed.');
      void waitForResult();
      return;
    }
    void sign('fulltime');
  }, [hud.finished, phase, role, sign, waitForResult]);

  // ---- leaving -----------------------------------------------------------

  const quit = async () => {
    const ok = await dialog.confirm({
      title: 'Quit the match?',
      body: `${opponentName} is told you left straight away. No win is recorded for either of you.`,
      confirmLabel: 'Quit match',
      tone: 'danger',
    });
    if (!ok) return;
    claimedRef.current = true;
    doneRef.current = true;
    try {
      await leaveMatch(matchId);
    } catch {
      /* the unload beacon and the server timeouts still cover it */
    }
    linkRef.current?.sendBye();
    onExit();
  };

  const [rematchBusy, setRematchBusy] = useState(false);
  const startRematch = async () => {
    setRematchBusy(true);
    try {
      onRematch(await rematch(view.lobby.id));
    } catch (e) {
      toast.error((e as Error).message);
    } finally {
      setRematchBusy(false);
    }
  };

  const m = result?.match;
  const myId = view.youAreHost ? m?.hostUserId : m?.guestUserId;
  const oppId = view.youAreHost ? m?.guestUserId : m?.hostUserId;
  const mine = m ? (view.youAreHost ? m.hostGoals : m.guestGoals) : null;
  const theirs = m ? (view.youAreHost ? m.guestGoals : m.hostGoals) : null;
  const live = phase === 'playing' || phase === 'lost';
  const shownHud: HudState = m?.status === 'finished' && mine != null ? { ...hud, homeScore: mine, awayScore: theirs ?? 0 } : hud;

  let headline = 'Draw';
  let sub: string | undefined = 'Saved to both of your records.';
  if (m) {
    if (m.status === 'finished') headline = !m.winnerUserId ? 'Draw' : m.winnerUserId === myId ? 'Victory' : 'Defeat';
    else if (m.status === 'abandoned') {
      headline = m.leaverUserId === myId ? 'You left' : `${opponentName} left`;
      sub = m.leaverUserId === myId ? 'No result was recorded.' : 'The match ended early. No win is recorded for either of you.';
    } else {
      headline = 'No result';
      sub = 'The two results did not match, so the match was not recorded.';
    }
  }

  return (
    <MatchStage canvasRef={canvasRef}>
      <MenuNav enabled={menu || phase === 'result' || phase === 'failed'} />
      {live && <MatchHud home={home} away={away} hud={hud} homeLabel={homeName} awayLabel={awayName} tag={role === 'host' ? 'Hosting' : undefined} />}
      {live && <ChargeBar charge={hud.charge} />}
      {live && <CornerButtons onPause={() => setMenu(true)} />}
      {phase === 'playing' && touchEnabled(touch.mode) && !menu && <TouchControls sink={sink} layout={touch.layout} />}
      <RotatePrompt />

      {phase === 'connecting' && (
        <Overlay title="Connecting" body={status}>
          <Spinner label="" />
          <Btn data-back className="mt-4" onClick={() => { leaveMatch(matchId).catch(() => {}); onExit(); }}>Cancel</Btn>
        </Overlay>
      )}
      {phase === 'lost' && !menu && <Overlay title="Connection lost" body={status}><Spinner label="" /></Overlay>}
      {phase === 'waitResult' && <Overlay title="Full time" body="Waiting for both results to be saved…"><Spinner label="" /></Overlay>}
      {phase === 'failed' && (
        <Overlay title="Could not finish" body={status}>
          <Btn variant="primary" className="mt-4" autoFocus data-autofocus onClick={onExit}>Back to menu</Btn>
        </Overlay>
      )}

      {phase === 'result' && m && (
        <ResultPanel home={home} away={away} hud={shownHud} headline={headline} sub={sub} label={m.status === 'finished' ? 'Full time' : 'Match ended'} showScore={m.status === 'finished'}>
          {m.status === 'finished' && <Btn variant="primary" size="lg" disabled={rematchBusy} onClick={startRematch} autoFocus data-autofocus>Rematch</Btn>}
          <Btn size="lg" onClick={onExit} data-back autoFocus={m.status !== 'finished'}>Menu</Btn>
          {oppId && (
            <span className="flex w-full justify-center gap-5 pt-2 font-display text-xs font-bold uppercase tracking-[0.16em] text-mist-400">
              <button className="hover:text-white" onClick={async () => {
                const reason = await dialog.prompt({ title: `Report ${opponentName}`, body: 'What happened? This goes to the moderators with the match.', label: 'Reason', confirmLabel: 'Send report', maxLength: 500 });
                if (!reason) return;
                try { await reportPlayer(oppId, m.id, reason); toast.success('Report sent. Thank you.'); } catch (e) { toast.error((e as Error).message); }
              }}>Report player</button>
              <button className="hover:text-white" onClick={async () => {
                if (!(await dialog.confirm({ title: `Block ${opponentName}?`, body: 'You will not be paired again and cannot invite each other.', confirmLabel: 'Block', tone: 'danger' }))) return;
                try { await blockPlayer(oppId); toast.success('Blocked'); } catch (e) { toast.error((e as Error).message); }
              }}>Block</button>
            </span>
          )}
        </ResultPanel>
      )}

      {menu && live && <PauseMenu friend onResume={() => setMenu(false)} onQuit={quit} />}
    </MatchStage>
  );
}

function Overlay({ title, body, children }: { title: string; body: string; children?: React.ReactNode }) {
  return (
    <div className="absolute inset-0 z-30 flex flex-col items-center justify-center gap-2 bg-ink-950/85 p-6 text-center backdrop-blur-sm animate-fade-in">
      <h2 className="t-display text-5xl text-white md:text-6xl">{title}</h2>
      <p className="mb-3 max-w-md font-body text-mist-300">{body}</p>
      {children}
    </div>
  );
}
