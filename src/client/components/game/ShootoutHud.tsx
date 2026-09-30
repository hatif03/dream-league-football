import type { ShootoutState } from '@/client/game/shootout';
import type { TeamData } from '@/client/game/teams';

const KICKS_SHOWN = 5;

/** The shootout scoreboard, the instructions, and the result of each kick, over the pitch. */
export function ShootoutHud({ state, home, away }: { state: ShootoutState; home: TeamData; away: TeamData }) {
  const row = (team: 'home' | 'away', t: TeamData) => {
    const marks = state.kicks.filter((k) => k.team === team);
    const slots = Math.max(KICKS_SHOWN, marks.length + (state.phase === 'done' ? 0 : 1));
    return (
      <div className="flex items-center gap-2">
        <span className="w-10 font-heading uppercase text-xs tracking-wider text-white">{t.abbr}</span>
        <div className="flex gap-1">
          {Array.from({ length: slots }, (_, i) => {
            const m = marks[i];
            return (
              <span
                key={i}
                className={`flex h-5 w-5 items-center justify-center rounded-full text-[11px] font-bold ${
                  !m ? 'bg-night-700' : m.scored ? 'bg-volt-500 text-night-950' : 'bg-rose-500 text-white'
                }`}
              >
                {m ? (m.scored ? '✓' : '✗') : ''}
              </span>
            );
          })}
        </div>
        <span className="ml-1 font-display text-xl text-white tabular-nums">
          {team === 'home' ? state.homeGoals : state.awayGoals}
        </span>
      </div>
    );
  };

  return (
    <>
      <div className="absolute top-3 left-3 rounded-md bg-night-950/95 px-3 py-2 shadow-lg shadow-black/40 animate-fade-in">
        <div className="mb-1 font-heading uppercase text-[10px] tracking-[0.3em] text-volt-400">Penalty shootout</div>
        <div className="flex flex-col gap-1">
          {row('home', home)}
          {row('away', away)}
        </div>
      </div>

      {state.outcome && (
        <div className="absolute inset-0 flex items-center justify-center pointer-events-none">
          <span
            key={state.kicks.length}
            className="font-display text-7xl sm:text-8xl text-volt-500 drop-shadow-[0_4px_0_rgba(0,0,0,0.6)] animate-pop tracking-wider"
          >
            {state.outcome}
          </span>
        </div>
      )}

      {state.prompt && (
        <div className="absolute bottom-4 left-1/2 -translate-x-1/2 rounded-md bg-night-950/90 px-4 py-2 font-body text-sm text-white shadow-lg">
          {state.prompt}
        </div>
      )}
      {state.charge != null && (
        <div className="absolute bottom-16 left-1/2 h-2 w-56 -translate-x-1/2 overflow-hidden rounded bg-night-800">
          <div
            className="h-full"
            style={{
              width: `${Math.round(state.charge * 100)}%`,
              background: 'linear-gradient(90deg,#39e639 0%,#ffe23a 55%,#ff8c1a 80%,#ff2e2e 100%)',
            }}
          />
        </div>
      )}
    </>
  );
}
