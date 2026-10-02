import { useMemo, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { toast } from 'react-hot-toast';
import { useQueryClient } from '@tanstack/react-query';
import { Search } from 'lucide-react';
import { TEAMS, nationId, teamById, type TeamData } from '@/client/game/teams';
import { GROUPS } from '@/client/game/teams/schedule';
import { KitJersey } from '@/client/components/game/TeamCrest';
import { Badge, Btn, Spinner, Tile } from '@/client/ui/controls';
import { Flag } from '@/client/ui/Flag';
import { TrophyArt } from '@/client/ui/art';
import { useDialog } from '@/client/ui/Dialog';
import { useHints } from '@/client/ui/hints';
import { useSettings, type Difficulty } from '@/client/ui/settings';
import { useSession } from '@/client/api/session';
import { useRun } from '@/client/api/queries';
import { abandonRun, ROUND_NAMES, startRun, type TournamentFixture, type TournamentView } from '@/client/api/tournament';
import { useMatch } from './matchContext';
import { runLine } from './HomeScreen';

const CONFED: Record<string, string> = {};
const put = (c: string, ids: string) => ids.split(' ').forEach((i) => (CONFED[i] = c));
put('UEFA', 'france spain england germany portugal netherlands croatia belgium switzerland austria turkiye norway sweden scotland czechrepublic bosniah');
put('CONMEBOL', 'argentina brazil uruguay colombia ecuador paraguay');
put('CAF', 'morocco senegal egypt ghana algeria ivorycoast tunisia southafrica capeverde drcongo');
put('AFC', 'japan southkorea iran australia saudiarabia qatar uzbekistan iraq jordan');
put('CONCACAF', 'unitedstates mexico canada panama curacao haiti');
put('OFC', 'newzealand');
const CONFEDS = ['All', 'UEFA', 'CONMEBOL', 'CAF', 'AFC', 'CONCACAF', 'OFC'];

const GROUP_OF: Record<string, string> = {};
for (const [g, ts] of Object.entries(GROUPS)) for (const t of ts) GROUP_OF[nationId(t)] = g;

const squadRating = (t: TeamData) => Math.round(t.players.reduce((s, p) => s + p.ratings.ovr, 0) / t.players.length);

export default function WorldCupScreen() {
  const session = useSession();
  const run = useRun();
  const [picking, setPicking] = useState(false);
  useHints([{ kb: 'Enter', pad: 'A', label: 'Select' }]);

  if (session.status !== 'in') return <div className="p-10"><Spinner /></div>;
  if (run.isLoading) return <div className="p-10"><Spinner label="Loading your World Cup" /></div>;
  if (run.isError) {
    return (
      <div className="mx-auto max-w-md p-10 text-center">
        <p className="mb-4 font-body text-mist-200">Could not load your World Cup.</p>
        <Btn variant="primary" onClick={() => run.refetch()}>Try again</Btn>
      </div>
    );
  }
  if (!run.data || picking) return <TeamSelect onBack={run.data ? () => setPicking(false) : undefined} favourite={session.profile.favouriteNation ?? undefined} onStarted={() => setPicking(false)} />;
  return <RunHub view={run.data} onNew={() => setPicking(true)} />;
}

// ---- team select -----------------------------------------------------------------

function TeamSelect({ favourite, onBack, onStarted }: { favourite?: string; onBack?: () => void; onStarted: () => void }) {
  const qc = useQueryClient();
  const { difficulty, setDifficulty } = useSettings();
  const [confed, setConfed] = useState('All');
  const [query, setQuery] = useState('');
  const [picked, setPicked] = useState<string>(favourite && teamById(favourite) ? favourite : 'brazil');
  const [busy, setBusy] = useState(false);

  const list = useMemo(
    () =>
      TEAMS.filter((t) => (confed === 'All' || CONFED[nationId(t)] === confed) && t.name.toLowerCase().includes(query.trim().toLowerCase())),
    [confed, query],
  );
  const team = teamById(picked)!;
  const group = GROUP_OF[picked];
  const mates = (GROUPS[group] ?? []).filter((t) => nationId(t) !== picked);
  const top = [...team.players].sort((a, b) => b.ratings.ovr - a.ratings.ovr).slice(0, 3);

  const start = async () => {
    setBusy(true);
    try {
      const view = await startRun(picked);
      qc.setQueryData(['run'], view);
      onStarted();
    } catch (e) {
      toast.error((e as Error).message);
    } finally {
      setBusy(false);
    }
  };

  return (
    <div className="mx-auto max-w-7xl px-4 py-5 md:py-6">
      <div className="mb-4 flex flex-wrap items-end justify-between gap-3">
        <div>
          <div className="t-label">World Cup</div>
          <h1 className="t-display text-4xl text-white md:text-5xl">Choose your nation</h1>
        </div>
        {onBack && <Btn data-back onClick={onBack}>Back to my run</Btn>}
      </div>

      <div className="grid gap-5 lg:grid-cols-[1fr_380px]">
        <section aria-label="Nations">
          <div className="mb-3 flex flex-wrap items-center gap-2">
            <div className="relative min-w-[200px] flex-1">
              <Search size={16} className="absolute left-3 top-1/2 -translate-y-1/2 text-mist-400" />
              <input className="field !pl-9" placeholder="Search nations" aria-label="Search nations" value={query} onChange={(e) => setQuery(e.target.value)} />
            </div>
            <div className="flex flex-wrap gap-1.5" role="group" aria-label="Confederation">
              {CONFEDS.map((c) => (
                <button key={c} aria-pressed={confed === c} onClick={() => setConfed(c)} className={`rounded px-3 py-1.5 font-display text-sm font-bold uppercase tracking-wider ${confed === c ? 'bg-neon-400 text-ink-950' : 'bg-white/10 text-mist-200 hover:bg-white/20'}`}>{c}</button>
              ))}
            </div>
          </div>
          {list.length === 0 ? (
            <p className="py-10 text-center font-body text-mist-400">No nation matches that search.</p>
          ) : (
            <div className="grid grid-cols-3 gap-2.5 sm:grid-cols-4 xl:grid-cols-6">
              {list.map((t) => {
                const id = nationId(t);
                return (
                  <Tile
                    key={id}
                    accent={t.color}
                    data-focus={picked === id}
                    aria-pressed={picked === id}
                    onClick={() => setPicked(id)}
                    onFocus={() => setPicked(id)}
                    className="items-center gap-1.5 px-2 pb-2.5 pt-4"
                  >
                    <Flag nation={id} className="h-10 w-14" />
                    <span className="line-clamp-1 w-full text-center font-display text-sm font-bold uppercase tracking-wide text-white">{t.name}</span>
                    <span className="font-display text-xs font-semibold text-mist-300 tabular">{squadRating(t)} OVR</span>
                  </Tile>
                );
              })}
            </div>
          )}
        </section>

        <aside className="glass-solid h-fit p-5 lg:sticky lg:top-4" aria-label={`${team.name} details`}>
          <div className="flex items-center gap-4">
            <Flag nation={picked} className="h-16 w-24" />
            <div className="min-w-0">
              <div className="t-label">{CONFED[picked]} · Group {group}</div>
              <h2 className="t-display truncate text-4xl text-white">{team.name}</h2>
            </div>
          </div>

          <div className="mt-4 flex items-center gap-4">
            <div className="rounded-md bg-white/5 p-2"><KitJersey kit={team.kit} /></div>
            <div className="flex-1 space-y-2">
              <div>
                <div className="flex justify-between font-display text-sm font-bold uppercase tracking-wider text-mist-300"><span>Squad rating</span><span className="text-white tabular">{squadRating(team)}</span></div>
                <div className="h-2 rounded bg-white/10"><div className="h-2 rounded bg-gradient-to-r from-neon-500 to-neon-300" style={{ width: `${Math.min(100, ((squadRating(team) - 60) / 25) * 100)}%` }} /></div>
              </div>
              <div className="font-body text-sm text-mist-300">Formation <b className="text-white">{team.formation}</b></div>
            </div>
          </div>

          <h3 className="t-label mt-4 mb-1">Star players</h3>
          <ul className="space-y-1">
            {top.map((p) => (
              <li key={p.num} className="flex items-center justify-between rounded bg-white/5 px-3 py-1.5 font-body text-sm text-white">
                <span><span className="mr-2 inline-block w-6 text-right font-display font-bold text-mist-400">{p.num}</span>{p.name}</span>
                <span className="font-display font-bold text-neon-300 tabular">{p.ratings.ovr}</span>
              </li>
            ))}
          </ul>

          <h3 className="t-label mt-4 mb-1">Group {group}</h3>
          <div className="flex gap-3">
            {mates.map((m) => <div key={nationId(m)} className="flex flex-col items-center gap-1"><Flag nation={nationId(m)} className="h-6 w-9" /><span className="font-body text-[11px] text-mist-300">{m.abbr}</span></div>)}
          </div>

          <h3 className="t-label mt-4 mb-1">CPU difficulty</h3>
          <div className="grid grid-cols-3 gap-2" role="radiogroup" aria-label="CPU difficulty">
            {(['easy', 'normal', 'hard'] as Difficulty[]).map((d) => (
              <button key={d} role="radio" aria-checked={difficulty === d} onClick={() => setDifficulty(d)} className={`rounded py-2 font-display text-sm font-bold uppercase tracking-wider ${difficulty === d ? 'bg-neon-400 text-ink-950' : 'bg-white/10 text-mist-200 hover:bg-white/20'}`}>{d}</button>
            ))}
          </div>

          <Btn variant="primary" size="lg" className="mt-5 w-full" disabled={busy} onClick={start}>{busy ? 'Starting…' : `Play as ${team.name}`}</Btn>
        </aside>
      </div>
    </div>
  );
}

// ---- the run ---------------------------------------------------------------------

function RunHub({ view, onNew }: { view: TournamentView; onNew: () => void }) {
  const { tournament: t, fixtures } = view;
  const qc = useQueryClient();
  const dialog = useDialog();
  const match = useMatch();
  const navigate = useNavigate();
  const [tab, setTab] = useState<'overview' | 'groups' | 'bracket'>(fixtures.some((f) => f.round !== 'group') ? 'bracket' : 'overview');
  const [busy, setBusy] = useState(false);
  const next = fixtures.find((f) => f.id === view.nextFixtureId) ?? null;
  const finished = t.status === 'champion' || t.status === 'eliminated';
  const line = runLine(view);

  const play = (f: TournamentFixture) => {
    const user = teamById(t.nationId);
    const opp = teamById(f.homeNation === t.nationId ? f.awayNation : f.homeNation);
    if (!user || !opp) return toast.error('Unknown nation in this fixture.');
    match.start({ kind: 'worldcup', fixture: f, tournamentId: t.id, user, opp, returnTo: '/world-cup' });
  };

  const abandon = async () => {
    if (!(await dialog.confirm({ title: 'Abandon this World Cup?', body: 'All saved results of this run are lost.', confirmLabel: 'Abandon run', tone: 'danger' }))) return;
    setBusy(true);
    try {
      await abandonRun();
      qc.setQueryData(['run'], null);
      navigate('/world-cup', { replace: true });
    } catch (e) {
      toast.error((e as Error).message);
    } finally {
      setBusy(false);
    }
  };

  return (
    <div className="mx-auto max-w-6xl px-4 py-5 md:py-6">
      <div className="mb-4 flex flex-wrap items-end justify-between gap-3">
        <div>
          <div className="t-label">Your World Cup</div>
          <h1 className="t-display text-4xl text-white md:text-6xl">{line.title} <span className="text-gold-400">2026</span></h1>
        </div>
        <div className="flex gap-2">
          {finished ? <Btn variant="primary" onClick={onNew}>New World Cup</Btn> : <Btn variant="ghost" size="sm" disabled={busy} onClick={abandon}>Abandon run</Btn>}
        </div>
      </div>

      {next ? <NextMatchCard fixture={next} mine={t.nationId} onPlay={() => play(next)} /> : <FinishedCard view={view} />}

      <div className="mt-6 mb-3 flex gap-1 border-b border-white/10" role="tablist">
        {(['overview', 'groups', 'bracket'] as const).map((k) => (
          <button key={k} role="tab" aria-selected={tab === k} onClick={() => setTab(k)} className={`px-4 py-2 font-display text-lg font-bold uppercase italic tracking-wider ${tab === k ? 'border-b-[3px] border-neon-400 text-white' : 'text-mist-400 hover:text-white'}`}>
            {k === 'overview' ? 'My group' : k === 'groups' ? 'All groups' : 'Knockouts'}
          </button>
        ))}
      </div>
      {tab === 'overview' && <GroupsPanel view={view} only={fixtures.find((f) => f.round === 'group' && (f.homeNation === t.nationId || f.awayNation === t.nationId))?.groupName} />}
      {tab === 'groups' && <GroupsPanel view={view} />}
      {tab === 'bracket' && <Bracket fixtures={fixtures} mine={t.nationId} />}
    </div>
  );
}

function NextMatchCard({ fixture, mine, onPlay }: { fixture: TournamentFixture; mine: string; onPlay: () => void }) {
  const opp = fixture.homeNation === mine ? fixture.awayNation : fixture.homeNation;
  const knockout = fixture.round !== 'group';
  return (
    <section className="glass-solid relative overflow-hidden p-5 md:p-8 animate-screen-in" aria-label="Next match" style={{ borderTop: '4px solid #ffc83a' }}>
      <div className="mb-4 flex items-center justify-between">
        <Badge tone="gold">{knockout ? `${ROUND_NAMES[fixture.round]} · Match ${fixture.matchNo}` : `Matchday ${fixture.matchday} · Group ${fixture.groupName}`}</Badge>
        <span className="hidden font-body text-sm text-mist-400 sm:inline">{knockout ? 'Extra time and penalties if level' : fixture.venue}</span>
      </div>
      <div className="flex items-center justify-around gap-2">
        <Side nation={mine} />
        <span className="t-display text-5xl text-mist-500 md:text-7xl">VS</span>
        <Side nation={opp} />
      </div>
      <div className="mt-6 flex justify-center">
        <Btn variant="primary" size="lg" onClick={onPlay} autoFocus data-autofocus>▶ Play match</Btn>
      </div>
    </section>
  );
}

function Side({ nation }: { nation: string }) {
  const t = teamById(nation);
  return (
    <div className="flex min-w-0 flex-1 flex-col items-center gap-2 text-center">
      <Flag nation={nation} className="h-14 w-20 md:h-24 md:w-36" />
      <span className="t-display line-clamp-1 text-2xl text-white md:text-5xl">{t?.name ?? nation}</span>
    </div>
  );
}

function FinishedCard({ view }: { view: TournamentView }) {
  const t = view.tournament;
  const won = t.status === 'champion';
  return (
    <section className="glass-solid flex items-center gap-6 p-6 animate-screen-in" style={{ borderTop: `4px solid ${won ? '#ffc83a' : '#ff5470'}` }}>
      {won && <TrophyArt className="h-28 w-auto drop-shadow-[0_8px_24px_rgba(255,200,58,0.5)]" />}
      <div>
        <h2 className="t-display text-4xl text-white md:text-5xl">{won ? 'World champions!' : `Out in the ${ROUND_NAMES[t.eliminatedIn ?? 'group'].toLowerCase()}`}</h2>
        <p className="mt-1 font-body text-mist-300">{won ? 'You lifted the trophy. Start another World Cup to do it again.' : 'So close. Pick a nation and go again.'}</p>
      </div>
    </section>
  );
}

function GroupsPanel({ view, only }: { view: TournamentView; only?: string }) {
  const mine = view.tournament.nationId;
  const letters = only ? [only] : [...new Set(view.standings.map((s) => s.groupName))].sort();
  return (
    <div className={`grid gap-4 ${only ? '' : 'md:grid-cols-2'}`}>
      {letters.map((g) => {
        const rows = view.standings.filter((s) => s.groupName === g).sort((a, b) => a.position - b.position);
        const games = view.fixtures.filter((f) => f.round === 'group' && f.groupName === g);
        return (
          <section key={g} className="glass p-4" aria-label={`Group ${g}`}>
            <h3 className="t-display mb-2 text-2xl text-white">Group {g}</h3>
            <table className="w-full font-body text-sm tabular">
              <thead><tr className="text-left text-xs uppercase text-mist-400"><th className="w-6">#</th><th>Team</th>{['P', 'W', 'D', 'L', 'GD', 'Pts'].map((h) => <th key={h} className="w-8 text-right">{h}</th>)}</tr></thead>
              <tbody>
                {rows.map((r) => (
                  <tr key={r.nationId} className={`border-t border-white/10 ${r.nationId === mine ? 'bg-neon-400/15 font-semibold text-white' : 'text-mist-200'}`}>
                    <td className={`py-1.5 ${r.qualified ? 'text-win' : ''}`}>{r.position}</td>
                    <td><span className="flex items-center gap-2"><Flag nation={r.nationId} className="h-4 w-6" />{teamById(r.nationId)?.name}</span></td>
                    {[r.played, r.won, r.drawn, r.lost, r.goalsFor - r.goalsAgainst].map((v, i) => <td key={i} className="text-right">{v}</td>)}
                    <td className="text-right font-bold text-white">{r.points}</td>
                  </tr>
                ))}
              </tbody>
            </table>
            <ul className="mt-3 space-y-1">
              {games.map((f) => <Tie key={f.id} f={f} mine={mine} tag={`MD${f.matchday}`} />)}
            </ul>
          </section>
        );
      })}
    </div>
  );
}

function Tie({ f, mine, tag }: { f: TournamentFixture; mine: string; tag: string }) {
  const played = f.homeScore != null;
  const pens = f.homePens != null ? ` (${f.homePens}–${f.awayPens} p)` : '';
  const isMine = f.homeNation === mine || f.awayNation === mine;
  const homeWon = played && (f.homeScore! > f.awayScore! || (f.homePens ?? 0) > (f.awayPens ?? 0));
  return (
    <li className={`flex items-center gap-2 rounded px-2 py-1 font-body text-sm ${isMine ? 'bg-white/10' : ''}`}>
      <span className="w-10 text-xs text-mist-400">{tag}</span>
      <span className={`flex flex-1 items-center justify-end gap-2 ${played && homeWon ? 'font-bold text-white' : 'text-mist-200'}`}>{teamById(f.homeNation)?.abbr}<Flag nation={f.homeNation} className="h-4 w-6" /></span>
      <span className="t-display min-w-[4.5rem] text-center text-lg tabular text-white">{played ? `${f.homeScore} – ${f.awayScore}` : 'v'}{pens && <span className="block text-[10px] font-body font-normal leading-none text-mist-300">{pens}</span>}</span>
      <span className={`flex flex-1 items-center gap-2 ${played && !homeWon ? 'font-bold text-white' : 'text-mist-200'}`}><Flag nation={f.awayNation} className="h-4 w-6" />{teamById(f.awayNation)?.abbr}</span>
    </li>
  );
}

function Bracket({ fixtures, mine }: { fixtures: TournamentFixture[]; mine: string }) {
  const rounds = ['r32', 'r16', 'qf', 'sf', 'final'] as const;
  const have = rounds.filter((r) => fixtures.some((f) => f.round === r));
  if (!have.length) {
    return (
      <div className="glass p-8 text-center">
        <p className="font-body text-mist-300">The knockout bracket appears once the group stage is finished and you are through.</p>
      </div>
    );
  }
  return (
    <div className="overflow-x-auto pb-2">
      <div className="flex min-w-max gap-6">
        {have.map((r) => {
          const list = fixtures.filter((f) => f.round === r).sort((a, b) => (a.matchNo ?? 0) - (b.matchNo ?? 0));
          return (
            <section key={r} className="w-60 shrink-0" aria-label={ROUND_NAMES[r]}>
              <h3 className="t-label mb-2 text-center">{ROUND_NAMES[r]}</h3>
              <div className="flex h-full flex-col justify-around gap-2">
                {list.map((f) => {
                  const isMine = f.homeNation === mine || f.awayNation === mine;
                  const played = f.homeScore != null;
                  const hw = played && (f.homeScore! > f.awayScore! || (f.homePens ?? 0) > (f.awayPens ?? 0));
                  return (
                    <div key={f.id} className={`glass overflow-hidden ${isMine ? 'ring-2 ring-neon-400' : ''}`}>
                      {[{ n: f.homeNation, s: f.homeScore, w: hw, p: f.homePens }, { n: f.awayNation, s: f.awayScore, w: played && !hw, p: f.awayPens }].map((row, i) => (
                        <div key={i} className={`flex items-center gap-2 px-3 py-1.5 font-body text-sm ${row.w ? 'bg-white/10 font-bold text-white' : 'text-mist-200'}`}>
                          <Flag nation={row.n} className="h-4 w-6" />
                          <span className="flex-1 truncate">{teamById(row.n)?.name}</span>
                          <span className="t-display text-lg tabular">{played ? row.s : ''}{row.p != null ? <sup className="ml-0.5 text-xs">({row.p})</sup> : null}</span>
                        </div>
                      ))}
                    </div>
                  );
                })}
              </div>
            </section>
          );
        })}
      </div>
    </div>
  );
}
