import type { HudState, MatchStats } from '@/client/game/types';
import type { TeamData } from '@/client/game/teams';
import { nationId } from '@/client/game/teams';
import { Flag } from './Flag';

export function fmtTime(secs: number) {
  const m = Math.floor(secs / 60);
  const s = secs % 60;
  return `${m}:${s.toString().padStart(2, '0')}`;
}

/** Broadcast scoreboard, player name plates and the big centre message, drawn over the pitch. */
export function MatchHud({
  home,
  away,
  hud,
  homeLabel,
  awayLabel,
  scoreboard = true,
  tag,
}: {
  home: TeamData;
  away: TeamData;
  hud: HudState;
  homeLabel?: string;
  awayLabel?: string;
  scoreboard?: boolean;
  /** Small label under the scoreboard, e.g. the round. */
  tag?: string;
}) {
  return (
    <>
      {scoreboard && (
        <div className="pointer-events-none absolute left-[max(0.75rem,env(safe-area-inset-left))] top-[max(0.75rem,env(safe-area-inset-top))] select-none animate-fade-in">
          <div className="flex h-10 items-stretch overflow-hidden rounded-[3px] font-display shadow-lg shadow-black/50 md:h-12">
            <span className="w-1.5" style={{ backgroundColor: home.color }} />
            <span className="flex items-center gap-2 bg-ink-950/90 pl-2 pr-2">
              <Flag nation={nationId(home)} className="h-4 w-6 md:h-5 md:w-7" />
              <span className="max-w-24 truncate text-sm font-bold uppercase tracking-wider text-white md:text-base">{homeLabel ?? home.abbr}</span>
            </span>
            <span className="flex items-center bg-white px-2.5 text-2xl font-extrabold tabular-nums text-ink-900 md:px-3 md:text-3xl">{hud.homeScore}</span>
            <span className="flex items-center bg-white px-0.5 text-xl font-bold text-ink-900/60">–</span>
            <span className="flex items-center bg-white px-2.5 text-2xl font-extrabold tabular-nums text-ink-900 md:px-3 md:text-3xl">{hud.awayScore}</span>
            <span className="flex items-center gap-2 bg-ink-950/90 pl-2 pr-2">
              <span className="max-w-24 truncate text-sm font-bold uppercase tracking-wider text-white md:text-base">{awayLabel ?? away.abbr}</span>
              <Flag nation={nationId(away)} className="h-4 w-6 md:h-5 md:w-7" />
            </span>
            <span className="w-1.5" style={{ backgroundColor: away.color }} />
            <span className="flex min-w-[3.6rem] items-center justify-center bg-neon-400 px-2.5 text-base font-extrabold tabular-nums text-ink-950 md:text-lg">
              {fmtTime(hud.clock)}
              {hud.extraTime && <sup className="ml-1 text-[10px]">ET</sup>}
              {!hud.extraTime && hud.added != null && hud.clock >= 5400 && <sup className="ml-1 text-[10px]">+{hud.added}</sup>}
            </span>
          </div>
          {tag && <div className="mt-1 inline-block rounded-sm bg-ink-950/80 px-2 py-0.5 font-display text-[11px] font-bold uppercase tracking-[0.2em] text-mist-300">{tag}</div>}
        </div>
      )}

      {hud.replay && (
        <div className="pointer-events-none absolute left-1/2 top-[max(0.75rem,env(safe-area-inset-top))] z-10 flex -translate-x-1/2 flex-col items-center gap-1 select-none" role="status">
          <span className="rounded-[3px] bg-hot-500 px-3 py-1 font-display text-xl font-extrabold uppercase tracking-[0.2em] text-white shadow-lg shadow-black/50 animate-pulse">Replay</span>
          <span className="rounded-[3px] bg-ink-950/80 px-2 py-0.5 font-display text-xs font-bold uppercase tracking-wider text-mist-300">Any key or tap to skip</span>
        </div>
      )}

      {hud.homePlayer && <NameTag side="left" color={home.color} text={home.textColor} num={hud.homePlayer.num} name={hud.homePlayer.name} charge={hud.charge} />}
      {hud.awayPlayer && <NameTag side="right" color={away.color} text={away.textColor} num={hud.awayPlayer.num} name={hud.awayPlayer.name} />}

      {hud.message && !hud.finished && (
        <div className="pointer-events-none absolute inset-0 flex items-center justify-center">
          <span key={hud.message + hud.homeScore + hud.awayScore} className="t-display animate-pop px-6 text-center text-6xl text-white drop-shadow-[0_6px_0_rgba(0,0,0,0.55)] sm:text-8xl md:text-9xl">
            {hud.message}
          </span>
        </div>
      )}
    </>
  );
}

function NameTag({ side, color, text, num, name, charge }: { side: 'left' | 'right'; color: string; text: string; num: number; name: string; charge?: number | null }) {
  return (
    <div className={`pointer-events-none absolute bottom-[max(0.75rem,env(safe-area-inset-bottom))] ${side === 'left' ? 'left-[max(0.75rem,env(safe-area-inset-left))]' : 'right-[max(0.75rem,env(safe-area-inset-right))]'} overflow-hidden rounded-[3px] bg-ink-950/90 shadow-lg shadow-black/50 animate-fade-in max-md:hidden [@media(pointer:coarse)]:hidden`}>
      <div className="flex h-9 items-stretch font-display">
        {side === 'left' && <span className="w-1.5" style={{ backgroundColor: color }} />}
        <span className="flex items-center px-2.5 text-base font-extrabold tabular-nums" style={{ backgroundColor: color, color: text }}>{num}</span>
        <span className="flex items-center px-3 text-base font-bold uppercase tracking-wider text-white">{name}</span>
        {side === 'right' && <span className="w-1.5" style={{ backgroundColor: color }} />}
      </div>
      <div className="h-1 w-full bg-white/10">
        {charge != null && <div className="h-full transition-[width] duration-75 ease-linear" style={{ width: `${Math.round(charge * 100)}%`, background: 'linear-gradient(90deg,#39e639 0%,#ffe23a 55%,#ff8c1a 80%,#ff2e2e 100%)' }} />}
      </div>
    </div>
  );
}

/** The charge bar for phones, where the name plates are hidden to save space. */
export function ChargeBar({ charge }: { charge: number | null }) {
  if (charge == null) return null;
  return (
    <div className="pointer-events-none absolute left-1/2 top-[max(0.75rem,env(safe-area-inset-top))] h-2 w-40 -translate-x-1/2 overflow-hidden rounded bg-white/15 md:hidden [@media(pointer:coarse)]:block">
      <div className="h-full" style={{ width: `${Math.round(charge * 100)}%`, background: 'linear-gradient(90deg,#39e639 0%,#ffe23a 55%,#ff8c1a 80%,#ff2e2e 100%)' }} />
    </div>
  );
}

/** End-of-match numbers as paired bars, home on the left. */
export function StatsBars({ stats, home, away }: { stats: MatchStats; home: string; away: string }) {
  const rows: { label: string; a: number; b: number; unit?: string }[] = [
    { label: 'Possession', a: stats.possession[0], b: stats.possession[1], unit: '%' },
    { label: 'Shots', a: stats.shots[0], b: stats.shots[1] },
    { label: 'On target', a: stats.onTarget[0], b: stats.onTarget[1] },
    { label: 'Saves', a: stats.saves[0], b: stats.saves[1] },
  ];
  const cards = stats.yellow[0] + stats.yellow[1] + stats.red[0] + stats.red[1] > 0;
  return (
    <div className="mx-auto w-full max-w-md space-y-2.5" aria-label="Match stats" role="group">
      <div className="flex justify-between font-display text-sm font-bold uppercase tracking-wider text-mist-300"><span>{home}</span><span>{away}</span></div>
      {rows.map((r) => {
        const total = r.a + r.b || 1;
        return (
          <div key={r.label}>
            <div className="flex items-baseline justify-between font-display font-bold tabular-nums">
              <span className={`text-xl ${r.a >= r.b ? 'text-white' : 'text-mist-400'}`}>{r.a}{r.unit}</span>
              <span className="text-xs uppercase tracking-[0.18em] text-mist-400">{r.label}</span>
              <span className={`text-xl ${r.b >= r.a ? 'text-white' : 'text-mist-400'}`}>{r.b}{r.unit}</span>
            </div>
            <div className="flex h-1.5 gap-1"><span className="rounded-full bg-neon-400" style={{ width: `${(r.a / total) * 100}%` }} /><span className="rounded-full bg-hot-500" style={{ width: `${(r.b / total) * 100}%` }} /></div>
          </div>
        );
      })}
      {cards && (
        <div className="flex items-center justify-between font-display font-bold tabular-nums text-white">
          <span className="flex gap-2"><i className="inline-block h-4 w-3 rounded-[2px] bg-gold-400" />{stats.yellow[0]}<i className="inline-block h-4 w-3 rounded-[2px] bg-loss" />{stats.red[0]}</span>
          <span className="text-xs uppercase tracking-[0.18em] text-mist-400">Cards</span>
          <span className="flex gap-2">{stats.yellow[1]}<i className="inline-block h-4 w-3 rounded-[2px] bg-gold-400" />{stats.red[1]}<i className="inline-block h-4 w-3 rounded-[2px] bg-loss" /></span>
        </div>
      )}
    </div>
  );
}
