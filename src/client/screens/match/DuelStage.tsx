import { useCallback, useEffect, useMemo, useRef, useState } from 'react';
import { toast } from 'react-hot-toast';
import { useQueryClient } from '@tanstack/react-query';
import { loadProfile } from '@/client/api/session';
import { teamById } from '@/client/game/teams';
import { Badge, Btn, Spinner } from '@/client/ui/controls';
import { Flag } from '@/client/ui/Flag';
import { ShareResultBtn } from '@/client/ui/ShareResult';
import { useDialog } from '@/client/ui/Dialog';
import { MenuNav } from '@/client/ui/MenuNav';
import { useHints } from '@/client/ui/hints';
import { sfx } from '@/client/ui/sfx';
import { getDuel, submitKick, type DuelView, type KickView } from '@/client/api/duel';
import { leaveMatch, rematch, type LobbyView } from '@/client/api/friend';
import { useLive, useLiveConnected } from '@/client/net/live';

const ZONES = ['Top left', 'Top centre', 'Top right', 'Bottom left', 'Bottom centre', 'Bottom right'];
const REVEAL_MS = 2600;

const OUTCOME_TEXT: Record<string, string> = { goal: 'GOAL!', saved: 'SAVED!', miss: 'WIDE!', post: 'OFF THE POST!' };

/**
 * The penalty duel. The server is the referee: each kick, the shooter and the keeper choose a zone in secret
 * (this screen only ever sends a number from 0 to 5), and the server draws the result with its own randomness.
 * Nothing here can be tampered with, and neither player has a latency advantage.
 */
export function DuelStage({ view, onExit, onRematch }: { view: LobbyView; onExit: () => void; onRematch: (next: LobbyView) => void }) {
  const matchId = view.lobby.matchId!;
  const dialog = useDialog();
  const queryClient = useQueryClient();
  const live = useLiveConnected();
  const [duel, setDuel] = useState<DuelView | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [chosen, setChosen] = useState<number | null>(null);
  /** How many resolved kicks have been shown to the player so far. */
  const [shown, setShown] = useState(0);
  const [reveal, setReveal] = useState<KickView | null>(null);
  const [now, setNow] = useState(Date.now());
  const fetchedAt = useRef(Date.now());
  const busy = useRef(false);
  const [rematchBusy, setRematchBusy] = useState(false);

  const apply = useCallback((d: DuelView) => {
    fetchedAt.current = Date.now();
    setDuel((old) => (old && JSON.stringify(old) === JSON.stringify(d) ? old : d));
    setError(null);
  }, []);

  const refresh = useCallback(async () => {
    if (busy.current) return;
    busy.current = true;
    try {
      apply(await getDuel(matchId));
    } catch (e) {
      setError((e as Error).message);
    } finally {
      busy.current = false;
    }
  }, [matchId, apply]);

  // The server pushes "duel changed"; a slow poll covers a dropped socket.
  useLive(['duel'], (id) => {
    if (!id || id === matchId) void refresh();
  });
  useEffect(() => {
    void refresh();
    const t = window.setInterval(() => void refresh(), live ? 6000 : 1500);
    return () => window.clearInterval(t);
  }, [refresh, live]);

  // A clock for the countdown bar.
  useEffect(() => {
    const t = window.setInterval(() => setNow(Date.now()), 200);
    return () => window.clearInterval(t);
  }, []);

  const resolved = useMemo(() => (duel?.kicks ?? []).filter((k) => k.outcome), [duel?.kicks]);

  // Show each settled kick in turn (the ball and the keeper's dive) before the next choice opens.
  useEffect(() => {
    if (!reveal && shown < resolved.length) setReveal(resolved[shown]);
  }, [resolved, shown, reveal]);
  useEffect(() => {
    if (!reveal) return;
    if (reveal.outcome === 'goal') sfx.goal();
    else sfx.error();
    const t = window.setTimeout(() => {
      setReveal(null);
      setShown((s) => s + 1);
      setChosen(null);
    }, REVEAL_MS);
    return () => window.clearTimeout(t);
  }, [reveal]);

  // When the duel is over the rating, leaderboard and daily challenge have moved.
  const over = duel?.status !== undefined && duel.status !== 'live';
  useEffect(() => {
    if (!over) return;
    void loadProfile();
    for (const key of ['daily', 'leaderboard', 'record', 'history']) void queryClient.invalidateQueries({ queryKey: [key] });
  }, [over, queryClient]);

  const caughtUp = !!duel && shown >= resolved.length && !reveal;
  const finished = !!duel && duel.status !== 'live' && caughtUp;
  const canChoose = !!duel && duel.status === 'live' && caughtUp && duel.seq === shown && !duel.youSubmitted && chosen === null;

  useHints(canChoose ? [{ kb: '← ↑ ↓ →  Enter', pad: 'D-pad  A', label: duel?.youShoot ? 'Aim and shoot' : 'Dive' }] : []);

  const youAreHost = view.youAreHost;
  const myName = youAreHost ? view.hostName : (view.guestName ?? 'You');
  const theirName = youAreHost ? (view.guestName ?? 'Opponent') : view.hostName;
  const myNation = (youAreHost ? view.lobby.hostNation : view.lobby.guestNation) ?? '';
  const theirNation = (youAreHost ? view.lobby.guestNation : view.lobby.hostNation) ?? '';
  const shownKicks = resolved.slice(0, shown + (reveal ? 1 : 0));
  const count = (host: boolean) => shownKicks.filter((k) => k.shooterIsHost === host && k.outcome === 'goal').length;
  const myGoals = count(youAreHost);
  const theirGoals = count(!youAreHost);

  const choose = async (zone: number) => {
    if (!duel || !canChoose) return;
    setChosen(zone);
    sfx.select();
    try {
      apply(await submitKick(matchId, duel.seq, zone));
    } catch (e) {
      toast.error((e as Error).message);
      setChosen(null);
    }
  };

  const leave = async () => {
    if (duel?.status === 'live') {
      const ok = await dialog.confirm({ title: 'Leave the duel?', body: 'You forfeit and your opponent is told. No win is given.', confirmLabel: 'Leave', tone: 'danger' });
      if (!ok) return;
      await leaveMatch(matchId).catch(() => {});
    }
    onExit();
  };

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

  const msLeft = duel ? Math.max(0, duel.msLeft - (now - fetchedAt.current)) : 0;
  const frac = Math.min(1, msLeft / 25_000);

  if (!duel) {
    return (
      <div className="flex min-h-[100dvh] items-center justify-center bg-ink-950">
        {error ? <p role="alert" className="font-body text-loss">{error}</p> : <Spinner label="Opening the penalty spot" />}
      </div>
    );
  }

  const prompt = finished
    ? ''
    : reveal
      ? OUTCOME_TEXT[reveal.outcome ?? ''] ?? ''
      : duel.status !== 'live'
        ? ''
        : duel.youSubmitted || chosen !== null
          ? `Waiting for ${theirName}…`
          : duel.youShoot
            ? 'Your kick: choose where to shoot'
            : `${theirName} shoots: choose where to dive`;

  return (
    <div className="flex min-h-[100dvh] flex-col items-center bg-[radial-gradient(circle_at_50%_0%,#2a2397,#0b0933_70%)] px-4 pb-8 pt-4">
      <MenuNav enabled />
      <div className="flex w-full max-w-3xl items-center justify-between">
        <Badge tone="gold">Penalty duel</Badge>
        <Btn size="sm" data-back onClick={leave}>{finished ? 'Back' : 'Forfeit'}</Btn>
      </div>

      <Scoreboard myName={myName} theirName={theirName} myNation={myNation} theirNation={theirNation} myGoals={myGoals} theirGoals={theirGoals} />
      <KickPips kicks={shownKicks} youAreHost={youAreHost} />

      <div className="mt-4 w-full max-w-3xl">
        <div className="h-1.5 w-full overflow-hidden rounded bg-white/10" aria-hidden>
          <div className="h-full bg-neon-400 transition-[width] duration-200" style={{ width: `${canChoose || chosen !== null ? frac * 100 : 0}%` }} />
        </div>
        <p role="status" aria-live="polite" className={`t-display mt-3 min-h-[3rem] text-center text-3xl md:text-5xl ${reveal ? (reveal.outcome === 'goal' ? 'text-win' : 'text-loss') : 'text-white'}`}>{prompt}</p>
      </div>

      <Goal
        disabled={!canChoose}
        chosen={chosen}
        reveal={reveal}
        youShoot={duel.youShoot}
        onPick={choose}
      />

      {finished && <Result duel={duel} myName={myName} theirName={theirName} myGoals={duel.youAreHost ? duel.hostGoals : duel.guestGoals} theirGoals={duel.youAreHost ? duel.guestGoals : duel.hostGoals} onRematch={startRematch} rematchBusy={rematchBusy} onExit={onExit} />}
    </div>
  );
}

function Scoreboard({ myName, theirName, myNation, theirNation, myGoals, theirGoals }: { myName: string; theirName: string; myNation: string; theirNation: string; myGoals: number; theirGoals: number }) {
  const mine = teamById(myNation);
  const theirs = teamById(theirNation);
  return (
    <div className="mt-4 flex w-full max-w-3xl items-stretch overflow-hidden rounded font-display shadow-lg shadow-black/50" aria-label={`Score ${myName} ${myGoals}, ${theirName} ${theirGoals}`}>
      <span className="w-1.5" style={{ backgroundColor: mine?.color ?? '#28e4ff' }} />
      <span className="flex min-w-0 flex-1 items-center gap-2 bg-ink-950/90 px-3 py-2">
        <Flag nation={myNation} className="h-5 w-7" />
        <span className="truncate text-lg font-bold uppercase text-white md:text-2xl">{myName}</span>
      </span>
      <span className="flex items-center bg-white px-4 text-4xl font-extrabold tabular-nums text-ink-900 md:text-5xl">{myGoals}</span>
      <span className="flex items-center bg-white px-1 text-2xl font-bold text-ink-900/60">–</span>
      <span className="flex items-center bg-white px-4 text-4xl font-extrabold tabular-nums text-ink-900 md:text-5xl">{theirGoals}</span>
      <span className="flex min-w-0 flex-1 items-center justify-end gap-2 bg-ink-950/90 px-3 py-2">
        <span className="truncate text-lg font-bold uppercase text-white md:text-2xl">{theirName}</span>
        <Flag nation={theirNation} className="h-5 w-7" />
      </span>
      <span className="w-1.5" style={{ backgroundColor: theirs?.color ?? '#ff3d8b' }} />
    </div>
  );
}

/** One dot per kick for each side: green goal, red not scored, grey still to come. */
function KickPips({ kicks, youAreHost }: { kicks: KickView[]; youAreHost: boolean }) {
  const row = (host: boolean, label: string) => {
    const mine = kicks.filter((k) => k.shooterIsHost === host);
    const slots = Math.max(5, mine.length);
    return (
      <div className="flex items-center gap-2">
        <span className="w-14 text-right font-body text-xs uppercase tracking-wider text-mist-400">{label}</span>
        <div className="flex gap-1.5">
          {Array.from({ length: slots }, (_, i) => {
            const k = mine[i];
            const text = !k ? 'to come' : k.outcome === 'goal' ? 'scored' : 'missed';
            return <i key={i} role="img" aria-label={`Kick ${i + 1} ${text}`} className={`h-4 w-4 rounded-full ring-1 ring-white/30 ${!k ? 'bg-white/10' : k.outcome === 'goal' ? 'bg-win' : 'bg-loss'}`} />;
          })}
        </div>
      </div>
    );
  };
  return (
    <div className="mt-3 flex flex-col gap-1.5">
      {row(youAreHost, 'You')}
      {row(!youAreHost, 'Them')}
    </div>
  );
}

/** The goal as the shooter sees it, six buttons for the six zones. During a reveal the ball and the keeper show where they went. */
function Goal({ disabled, chosen, reveal, youShoot, onPick }: { disabled: boolean; chosen: number | null; reveal: KickView | null; youShoot: boolean; onPick: (z: number) => void }) {
  return (
    <div className="relative mt-4 w-full max-w-3xl" role="group" aria-label={youShoot ? 'Choose where to shoot' : 'Choose where to dive'}>
      <div className="relative aspect-[16/7] w-full rounded-t-md border-x-[10px] border-t-[10px] border-white bg-[repeating-linear-gradient(0deg,rgba(255,255,255,0.08)_0_2px,transparent_2px_16px),repeating-linear-gradient(90deg,rgba(255,255,255,0.08)_0_2px,transparent_2px_16px)] shadow-[0_0_60px_rgba(40,228,255,0.25)]">
        <div className="absolute inset-0 grid grid-cols-3 grid-rows-2">
          {ZONES.map((name, z) => {
            const ball = reveal?.shooterZone === z;
            const keeper = reveal?.keeperZone === z;
            const picked = chosen === z;
            return (
              <button
                key={z}
                type="button"
                disabled={disabled}
                data-autofocus={z === 4 ? '' : undefined}
                autoFocus={z === 4}
                aria-label={name}
                aria-pressed={picked}
                onClick={() => onPick(z)}
                className={`relative flex items-center justify-center border border-white/15 transition-colors focus-visible:z-10 focus-visible:outline focus-visible:outline-4 focus-visible:outline-neon-400 ${picked ? 'bg-neon-400/30' : disabled ? '' : 'hover:bg-white/15 focus-visible:bg-white/15'}`}
              >
                {keeper && <span className="t-display rounded bg-gold-500/90 px-2 py-0.5 text-sm text-ink-950 md:text-xl" style={{ animation: 'count-pop 0.6s ease-out' }}>KEEPER</span>}
                {ball && <span className="absolute h-8 w-8 rounded-full bg-white shadow-[0_0_20px_#fff] md:h-12 md:w-12" style={{ animation: 'count-pop 0.5s ease-out' }} aria-hidden />}
                {!reveal && picked && <span className="t-display text-lg text-white md:text-2xl">{youShoot ? 'SHOT' : 'DIVE'}</span>}
              </button>
            );
          })}
        </div>
      </div>
      <div className="h-3 w-full rounded-b bg-gradient-to-b from-pitch-600/60 to-transparent" aria-hidden />
    </div>
  );
}

function Result({ duel, myName, theirName, myGoals, theirGoals, onRematch, rematchBusy, onExit }: { duel: DuelView; myName: string; theirName: string; myGoals: number; theirGoals: number; onRematch: () => void; rematchBusy: boolean; onExit: () => void }) {
  const won = duel.youWon === true;
  const void_ = duel.status !== 'finished';
  const delta = duel.ratingDelta;
  return (
    <div className="fixed inset-0 z-[90] flex items-center justify-center bg-ink-950/85 p-4 backdrop-blur-sm" role="dialog" aria-modal="true" aria-labelledby="duel-result" data-nav-scope>
      <div className="glass-solid w-full max-w-md p-6 text-center" style={{ borderTop: `4px solid ${void_ ? '#7a75b8' : won ? '#3df08a' : '#ff3d8b'}` }}>
        <div className="t-label">{void_ ? 'Duel ended' : 'Penalty duel'}</div>
        <h2 id="duel-result" className="t-display text-6xl text-white">{void_ ? 'No result' : won ? 'You win!' : 'You lose'}</h2>
        {!void_ && <p className="t-display mt-1 text-4xl tabular text-white">{myGoals}–{theirGoals}</p>}
        <p className="mt-2 font-body text-sm text-mist-300">
          {void_ ? `${theirName} left the duel, so no win was given.` : `${myName} v ${theirName}`}
        </p>
        {delta != null && !void_ && (
          <p className={`t-display mt-3 text-3xl tabular ${delta >= 0 ? 'text-win' : 'text-loss'}`} aria-label={`Rating ${delta >= 0 ? 'up' : 'down'} ${Math.abs(delta)}`}>
            {delta >= 0 ? '+' : '−'}{Math.abs(delta)} rating
          </p>
        )}
        <div className="mt-5 flex flex-wrap justify-center gap-3">
          {!void_ && <Btn variant="primary" size="lg" disabled={rematchBusy} onClick={onRematch} autoFocus data-autofocus="">Rematch</Btn>}
          {!void_ && (
            <ShareResultBtn
              info={{
                headline: won ? 'Victory' : 'Defeat',
                label: 'Penalty duel',
                homeName: myName,
                awayName: theirName,
                homeScore: myGoals,
                awayScore: theirGoals,
                homeColor: '#28e4ff',
                awayColor: '#ff3d8b',
                note: won ? `${myName} wins the duel` : `${theirName} wins the duel`,
              }}
            />
          )}
          <Btn size="lg" onClick={onExit} data-back autoFocus={void_} data-autofocus={void_ ? '' : undefined}>Back to Online</Btn>
        </div>
      </div>
    </div>
  );
}
