import { useCallback, useEffect, useRef, useState } from 'react';
import type { GameEvent } from '@/client/game/types';
import type { TeamData } from '@/client/game/teams';

// Text commentary under the scoreboard: one short line per event, like a radio caller. The text is also
// announced to screen readers (role="status"), so it doubles as an audio description of the match.

const pick = <T,>(a: T[]): T => a[Math.floor(Math.random() * a.length)];
const title = (s: string) => s.charAt(0) + s.slice(1).toLowerCase();

/** Events worth a line right away; the rest (shots) are rate limited. */
const MINOR = new Set(['shot', 'foul', 'throwin', 'goalkick', 'corner']);

export function commentaryLine(e: GameEvent, home: TeamData, away: TeamData): string | null {
  const team = e.team === 'home' ? home : e.team === 'away' ? away : null;
  const other = e.team === 'home' ? away : home;
  const who = e.name ? title(e.name) : team?.name ?? 'The side';
  switch (e.kind) {
    case 'goal':
      return pick([
        `GOAL! ${who} finds the net! ${e.extra ?? ''}`,
        `${who} scores! ${team?.name} ${e.extra ? 'lead the way' : 'celebrate'}.`,
        `It's in! ${who} makes no mistake. ${e.extra ?? ''}`,
      ]).trim();
    case 'save':
      return pick([`Great save by ${who}!`, `${who} gets down well to keep it out.`, `Denied! ${who} stands tall.`]);
    case 'shot':
      return pick([`${who} has a go!`, `A shot from ${who}...`, `${who} tries his luck.`, `${team?.name} threaten.`]);
    case 'foul':
      return pick([`Foul by ${who}.`, `The referee blows for a foul on ${other.name}.`]);
    case 'yellow':
      return `${who} goes into the book. Yellow card.`;
    case 'red':
      return `Red card! ${who} is sent off, ${team?.name} are down to ten.`;
    case 'offside':
      return `Flag up. ${who} was offside.`;
    case 'corner':
      return `Corner to ${team?.name}.`;
    case 'goalkick':
      return `Goal kick for ${team?.name}.`;
    case 'throwin':
      return `Throw-in for ${team?.name}.`;
    case 'penalty':
      return `Penalty to ${team?.name}! The crowd holds its breath.`;
    case 'halftime':
      return 'The referee blows for half time.';
    case 'added':
      return `${e.extra} minute${e.extra === '1' ? '' : 's'} of added time.`;
    case 'extratime':
      return 'Level after ninety. We go to extra time!';
    case 'fulltime':
      return `Full time! ${home.name} ${e.extra?.replace('-', ' – ')} ${away.name}.`;
  }
}

/** A hook that turns events into the line to show. Call `push` from the engine's onEvent. */
export function useCommentary(home: TeamData, away: TeamData, enabled: boolean) {
  const [line, setLine] = useState<{ text: string; n: number } | null>(null);
  const last = useRef(0);
  const timer = useRef<number>(undefined);
  const teams = useRef({ home, away });
  teams.current = { home, away };

  const push = useCallback(
    (e: GameEvent) => {
      if (!enabled) return;
      const now = Date.now();
      // Quiet moments are only commented on every few seconds, so the strip never chatters.
      if (MINOR.has(e.kind) && now - last.current < 5000) return;
      const text = commentaryLine(e, teams.current.home, teams.current.away);
      if (!text) return;
      last.current = now;
      setLine((l) => ({ text, n: (l?.n ?? 0) + 1 }));
      window.clearTimeout(timer.current);
      timer.current = window.setTimeout(() => setLine(null), e.kind === 'goal' ? 6000 : 4200);
    },
    [enabled],
  );
  useEffect(() => () => window.clearTimeout(timer.current), []);
  return { line, push };
}

export function CommentaryStrip({ line }: { line: { text: string; n: number } | null }) {
  return (
    <div className="pointer-events-none absolute inset-x-0 bottom-[max(3.2rem,calc(env(safe-area-inset-bottom)+2.5rem))] z-10 flex justify-center px-3" role="status" aria-live="polite">
      {line && (
        <p key={line.n} className="max-w-xl rounded-[3px] bg-ink-950/85 px-4 py-1.5 text-center font-display text-base font-bold uppercase tracking-wide text-white shadow-lg shadow-black/50 animate-pop md:text-lg">
          {line.text}
        </p>
      )}
    </div>
  );
}
