import { useState } from 'react';
import { TEAMS, nationId, teamById } from '@/client/game/teams';
import { findCurrentOrNextMatch } from '@/client/game/teams/schedule';
import { KitJersey } from '@/client/components/game/TeamCrest';
import { Btn } from '@/client/ui/controls';
import { Flag } from '@/client/ui/Flag';
import { PracticeArt } from '@/client/ui/art';
import { useSession } from '@/client/api/session';
import { tutorialDone } from './match/Tutorial';
import { NationModal } from './online/parts';
import { useMatch } from './matchContext';

/** Practice (four team-mates and a keeper) or a Friendly (a full 11 v 11 against the CPU); pick the teams, then onto the pitch. */
export default function PracticeScreen() {
  const session = useSession();
  const match = useMatch();
  const fav = session.status === 'in' ? teamById(session.profile.favouriteNation ?? '') : undefined;
  const fixture = findCurrentOrNextMatch();
  const [mine, setMine] = useState(nationId(fav ?? fixture?.home ?? TEAMS[0]));
  const [theirs, setTheirs] = useState(nationId(fixture && nationId(fixture.away) !== nationId(fav ?? fixture.home) ? fixture.away : TEAMS[1]));
  const [pick, setPick] = useState<'mine' | 'theirs' | null>(null);
  const [mode, setMode] = useState<'practice' | 'friendly' | 'penalties'>('practice');
  const [decide, setDecide] = useState(true);
  const friendly = mode === 'friendly';
  const penalties = mode === 'penalties';

  const start = () =>
    match.start(
      mode === 'friendly'
        ? { kind: 'friendly', home: teamById(mine)!, away: teamById(theirs)!, returnTo: '/practice', decide }
        : { kind: mode, home: teamById(mine)!, away: teamById(theirs)!, returnTo: '/practice' },
    );
  const learn = () => match.start({ kind: 'practice', home: teamById(mine)!, away: teamById(theirs)!, returnTo: '/practice', tutorial: true });
  const side = (which: 'mine' | 'theirs', nation: string, title: string) => {
    const t = teamById(nation)!;
    return (
      <button className="tile flex-row items-center gap-4 p-4" style={{ ['--accent' as string]: t.color }} onClick={() => setPick(which)} aria-label={`${title}: ${t.name}. Change.`}>
        <Flag nation={nation} className="h-14 w-20" />
        <div className="min-w-0 flex-1 text-left">
          <div className="t-label">{title}</div>
          <div className="t-display truncate text-3xl text-white">{t.name}</div>
          <div className="font-body text-xs text-mist-400">Tap to change</div>
        </div>
        <span className="hidden lg:block"><KitJersey kit={which === 'mine' ? t.kit : t.awayKit} /></span>
      </button>
    );
  };

  return (
    <div className="mx-auto max-w-4xl px-4 py-5 md:py-8">
      <div className="mb-4">
        <div className="t-label">{friendly || penalties ? 'Play the CPU' : 'Warm up'}</div>
        <h1 className="t-display text-4xl text-white md:text-6xl">{friendly ? 'Friendly' : penalties ? 'Penalties' : 'Practice'}</h1>
      </div>
      <div role="radiogroup" aria-label="Mode" className="mb-4 grid max-w-xl grid-cols-3 gap-2">
        {(['practice', 'friendly', 'penalties'] as const).map((m) => (
          <button key={m} role="radio" aria-checked={mode === m} onClick={() => setMode(m)} className={`rounded py-2.5 font-display text-lg font-bold uppercase tracking-wider ${mode === m ? 'bg-neon-400 text-ink-950' : 'bg-white/10 text-mist-200 hover:bg-white/20'}`}>
            {m === 'practice' ? 'Practice' : m === 'friendly' ? '11 v 11 friendly' : 'Penalty shootout'}
          </button>
        ))}
      </div>
      {!friendly && !penalties && !tutorialDone() && (
        <div className="glass mb-4 flex flex-wrap items-center gap-3 border-l-4 border-neon-400 p-3">
          <p className="min-w-0 flex-1 font-body text-sm text-mist-100"><b>New here?</b> A two-minute tutorial shows you how to run, pass, shoot and defend.</p>
          <Btn size="sm" variant="primary" onClick={learn}>Take the tutorial</Btn>
        </div>
      )}
      <div className="glass-solid grid gap-6 p-5 md:grid-cols-[1fr_1.1fr] md:p-7 animate-screen-in">
        <div className="flex flex-col items-center justify-center gap-3">
          <PracticeArt className="h-44 w-auto" />
          <p className="text-center font-body text-mist-300">{penalties ? 'Take turns from the spot against the CPU keeper: five kicks each, then sudden death. Aim with the arrows and shoot, and dive the right way when the CPU shoots.' : friendly ? 'A full match against the CPU with real rules, half-time and your choice of formation. Nothing is saved, so play it for fun.' : 'Four teammates and a keeper. No clock, no rules to worry about. Shoot, pass, and learn how it feels.'}</p>
        </div>
        <div className="flex flex-col gap-3">
          {side('mine', mine, 'Your team')}
          {side('theirs', theirs, friendly || penalties ? "CPU's team" : "Goalkeeper's team")}
          <Btn variant="primary" size="lg" className="mt-2" onClick={start} autoFocus data-autofocus="">{friendly ? '▶ Start friendly' : penalties ? '▶ Start shootout' : '▶ Start practice'}</Btn>
          {friendly && (
            <label className="flex items-start gap-3 font-body text-sm text-mist-200">
              <input type="checkbox" className="mt-1 h-5 w-5 accent-cyan-400" checked={decide} onChange={(e) => setDecide(e.target.checked)} />
              <span>If it is level after 90 minutes, play extra time and then penalties.</span>
            </label>
          )}
          {!friendly && !penalties && <Btn onClick={learn}>Learn the basics</Btn>}
        </div>
      </div>
      {pick && (
        <NationModal
          current={pick === 'mine' ? mine : theirs}
          taken={pick === 'mine' ? theirs : mine}
          onClose={() => setPick(null)}
          onPick={(id) => {
            (pick === 'mine' ? setMine : setTheirs)(id);
            setPick(null);
          }}
        />
      )}
    </div>
  );
}
