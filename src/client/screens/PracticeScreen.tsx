import { useState } from 'react';
import { TEAMS, nationId, teamById } from '@/client/game/teams';
import { findCurrentOrNextMatch } from '@/client/game/teams/schedule';
import { KitJersey } from '@/client/components/game/TeamCrest';
import { Btn } from '@/client/ui/controls';
import { Flag } from '@/client/ui/Flag';
import { PracticeArt } from '@/client/ui/art';
import { useSession } from '@/client/api/session';
import { NationModal } from './online/parts';
import { useMatch } from './matchContext';

/** Practice: pick your side and whose keeper you shoot at, then straight onto the pitch. */
export default function PracticeScreen() {
  const session = useSession();
  const match = useMatch();
  const fav = session.status === 'in' ? teamById(session.profile.favouriteNation ?? '') : undefined;
  const fixture = findCurrentOrNextMatch();
  const [mine, setMine] = useState(nationId(fav ?? fixture?.home ?? TEAMS[0]));
  const [theirs, setTheirs] = useState(nationId(fixture && nationId(fixture.away) !== nationId(fav ?? fixture.home) ? fixture.away : TEAMS[1]));
  const [pick, setPick] = useState<'mine' | 'theirs' | null>(null);

  const start = () => match.start({ kind: 'practice', home: teamById(mine)!, away: teamById(theirs)!, returnTo: '/practice' });
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
        <div className="t-label">Warm up</div>
        <h1 className="t-display text-4xl text-white md:text-6xl">Practice</h1>
      </div>
      <div className="glass-solid grid gap-6 p-5 md:grid-cols-[1fr_1.1fr] md:p-7 animate-screen-in">
        <div className="flex flex-col items-center justify-center gap-3">
          <PracticeArt className="h-44 w-auto" />
          <p className="text-center font-body text-mist-300">Four teammates and a keeper. No clock, no rules to worry about. Shoot, pass, and learn how it feels.</p>
        </div>
        <div className="flex flex-col gap-3">
          {side('mine', mine, 'Your team')}
          {side('theirs', theirs, "Goalkeeper's team")}
          <Btn variant="primary" size="lg" className="mt-2" onClick={start} autoFocus data-autofocus="">▶ Start practice</Btn>
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
