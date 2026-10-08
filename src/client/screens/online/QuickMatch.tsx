import { useCallback, useEffect, useRef, useState } from 'react';
import { toast } from 'react-hot-toast';
import { Flame, Search, Trophy } from 'lucide-react';
import { Badge, Btn } from '@/client/ui/controls';
import { sfx } from '@/client/ui/sfx';
import { cancelQueue, joinQueue, queueStatus, type DailyChallenge, type QueueStatus } from '@/client/api/duel';
import type { LobbyView } from '@/client/api/friend';
import { useLive, useLiveConnected } from '@/client/net/live';

export type GameMode = 'match' | 'penalties';

export const MODE_NAME: Record<GameMode, string> = { match: '11 v 11 match', penalties: 'Penalty duel' };

/** A switch between the two kinds of online game. */
export function ModeToggle({ mode, onChange, disabled }: { mode: GameMode; onChange: (m: GameMode) => void; disabled?: boolean }) {
  return (
    <div role="radiogroup" aria-label="Kind of game" className="inline-flex overflow-hidden rounded ring-1 ring-white/20">
      {(['match', 'penalties'] as const).map((m) => (
        <button
          key={m}
          type="button"
          role="radio"
          aria-checked={mode === m}
          disabled={disabled}
          onClick={() => onChange(m)}
          className={`px-4 py-2 font-display text-sm font-bold uppercase tracking-wider transition-colors focus-visible:outline focus-visible:outline-2 focus-visible:outline-neon-400 ${mode === m ? 'bg-neon-400 text-ink-950' : 'bg-white/5 text-mist-200 hover:bg-white/10'}`}
        >
          {MODE_NAME[m]}
        </button>
      ))}
    </div>
  );
}

/**
 * "Find a match": the player joins Serverpod's matchmaking queue and is paired with someone of a similar
 * rating who is waiting for the same kind of game. The server pushes the pairing over the live socket;
 * a slow poll keeps the search alive and covers a dropped socket.
 */
export function QuickMatch({ mode, disabled, onFound, rating }: { mode: GameMode; disabled: boolean; onFound: (view: LobbyView) => void; rating?: number }) {
  const [state, setState] = useState<QueueStatus | null>(null);
  const [busy, setBusy] = useState(false);
  const [secs, setSecs] = useState(0);
  const live = useLiveConnected();
  const done = useRef(false);
  const searching = !!state?.searching;

  const check = useCallback(
    async (s: QueueStatus) => {
      setState(s);
      if (s.lobby && !done.current) {
        done.current = true;
        sfx.whistle();
        onFound(s.lobby);
      }
    },
    [onFound],
  );

  // Pick up a search that was running before a reload (or a pairing that happened meanwhile).
  useEffect(() => {
    queueStatus().then((s) => (s.searching || s.lobby ? check(s) : undefined)).catch(() => {});
  }, [check]);

  const poll = useCallback(() => {
    if (done.current) return;
    queueStatus().then(check).catch(() => {});
  }, [check]);
  useLive(['queue'], poll);
  useEffect(() => {
    if (!searching) return;
    const t = window.setInterval(poll, live ? 8000 : 2000);
    const c = window.setInterval(() => setSecs((n) => n + 1), 1000);
    return () => {
      window.clearInterval(t);
      window.clearInterval(c);
    };
  }, [searching, live, poll]);

  const start = async () => {
    setBusy(true);
    done.current = false;
    setSecs(0);
    try {
      await check(await joinQueue(mode));
      sfx.select();
    } catch (e) {
      toast.error((e as Error).message);
      sfx.error();
    } finally {
      setBusy(false);
    }
  };

  const stop = async () => {
    await cancelQueue().catch(() => {});
    setState(null);
    sfx.back();
  };

  return (
    <section className="glass p-4" aria-label="Find a match" style={{ borderTop: '4px solid #3df08a' }}>
      <div className="flex flex-wrap items-center justify-between gap-2">
        <h2 className="t-display text-2xl text-white">Find a match</h2>
        {rating != null && <Badge tone="gold">Rating {rating}</Badge>}
      </div>
      {searching ? (
        <div className="mt-3 flex flex-col items-center gap-3 text-center" role="status" aria-live="polite">
          <div className="flex items-center gap-3">
            <span className="flex gap-1"><i className="h-2.5 w-2.5 animate-pulse rounded-full bg-win" /><i className="h-2.5 w-2.5 animate-pulse rounded-full bg-win [animation-delay:200ms]" /><i className="h-2.5 w-2.5 animate-pulse rounded-full bg-win [animation-delay:400ms]" /></span>
            <span className="t-display text-2xl text-white">Searching… {secs}s</span>
          </div>
          <p className="font-body text-sm text-mist-300">
            {MODE_NAME[(state?.mode as GameMode) ?? mode] ?? 'A game'} · {state?.queued ? `${state.queued} other${state.queued === 1 ? '' : 's'} waiting` : 'you are first in line'}. The search widens to stronger and weaker players the longer you wait.
          </p>
          <Btn onClick={stop}>Cancel search</Btn>
        </div>
      ) : (
        <div className="mt-3 flex flex-col items-start gap-3">
          <p className="font-body text-sm text-mist-300">
            No friend online? Get paired with a player of a similar rating. Wins and losses move your rating.
          </p>
          <Btn variant="primary" size="lg" disabled={disabled || busy} onClick={start} autoFocus data-autofocus="">
            <Search size={18} /> Find a {mode === 'match' ? 'match' : 'penalty duel'}
          </Btn>
        </div>
      )}
    </section>
  );
}

/** Today's challenge, the same for every player, with a progress bar and the streak. */
export function DailyCard({ c }: { c: DailyChallenge | undefined }) {
  if (!c) return <div className="skeleton h-24" />;
  const pct = Math.min(100, Math.round((c.progress / c.target) * 100));
  return (
    <section className="glass p-4" aria-label="Daily challenge" style={{ borderTop: `4px solid ${c.done ? '#3df08a' : '#ffc233'}` }}>
      <div className="flex items-center justify-between gap-2">
        <div className="t-label">Daily challenge</div>
        {c.streak > 0 && <Badge tone="hot"><Flame size={12} className="mr-1" />{c.streak} day{c.streak === 1 ? '' : 's'}</Badge>}
      </div>
      <h2 className="t-display mt-1 flex items-center gap-2 text-2xl text-white">{c.done && <Trophy size={20} className="text-win" />}{c.title}</h2>
      <p className="font-body text-sm text-mist-200">{c.description}</p>
      <div className="mt-3 h-2 w-full overflow-hidden rounded bg-white/10" role="progressbar" aria-valuemin={0} aria-valuemax={c.target} aria-valuenow={Math.min(c.progress, c.target)} aria-label="Challenge progress">
        <div className={`h-full ${c.done ? 'bg-win' : 'bg-gold-400'}`} style={{ width: `${pct}%` }} />
      </div>
      <p className="mt-1 font-body text-xs text-mist-400">{c.done ? 'Done for today. Come back tomorrow.' : `${Math.min(c.progress, c.target)} of ${c.target}`}</p>
    </section>
  );
}
