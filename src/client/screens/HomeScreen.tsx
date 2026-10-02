import { useEffect, type ReactNode } from 'react';
import { useNavigate } from 'react-router-dom';
import { useSession } from '@/client/api/session';
import { useRecord, useRun } from '@/client/api/queries';
import { ROUND_NAMES, type TournamentView } from '@/client/api/tournament';
import { teamById } from '@/client/game/teams';
import { Badge, Tile } from '@/client/ui/controls';
import { Flag } from '@/client/ui/Flag';
import { PracticeArt, ProfileArt, TrophyArt, VersusArt } from '@/client/ui/art';
import { useNotifications } from '@/client/ui/Notifications';
import { LinkBtn } from '@/client/ui/controls';

/** Where the player stands in their World Cup run, in a line. */
export function runLine(v: TournamentView): { title: string; sub: string } {
  const t = v.tournament;
  const mine = teamById(t.nationId)?.name ?? t.nationId;
  if (t.status === 'champion') return { title: mine, sub: 'World champions' };
  if (t.status === 'eliminated') return { title: mine, sub: `Out in the ${ROUND_NAMES[t.eliminatedIn ?? 'group'].toLowerCase()}` };
  const next = v.fixtures.find((f) => f.id === v.nextFixtureId);
  const opp = next ? teamById(next.homeNation === t.nationId ? next.awayNation : next.homeNation)?.name : undefined;
  const where = t.status === 'group' ? `Matchday ${next?.matchday ?? ''}` : ROUND_NAMES[t.status];
  return { title: mine, sub: opp ? `${where} · v ${opp}` : where };
}

export default function HomeScreen() {
  const session = useSession();
  const navigate = useNavigate();
  const run = useRun();
  const record = useRecord();
  const { friends, invites } = useNotifications();
  const signedIn = session.status === 'in';
  const online = friends?.friends.filter((f) => f.online).length ?? 0;

  useEffect(() => {
    document.title = 'World Cup 2026';
    // Old shared links looked like /?room=CODE.
    const code = new URLSearchParams(location.search).get('room');
    if (code) navigate(`/online?join=${encodeURIComponent(code)}`, { replace: true });
  }, [navigate]);

  const gate = (to: string) => (signedIn ? navigate(to) : navigate(`/login?_redirect=${encodeURIComponent(to)}`));
  const runInfo = run.data ? runLine(run.data) : null;
  const finished = run.data && (run.data.tournament.status === 'champion' || run.data.tournament.status === 'eliminated');

  return (
    <div className="mx-auto flex min-h-full max-w-7xl flex-col px-4 py-5 md:py-8">
      <div className="mb-5 flex flex-wrap items-end justify-between gap-3">
        <div>
          <div className="t-label">{signedIn ? 'Welcome back' : 'Kick off'}</div>
          <h1 className="t-display text-4xl text-white md:text-6xl">
            {signedIn && session.status === 'in' ? session.profile.displayName : 'Take on the world'}
          </h1>
        </div>
        {!signedIn && session.status !== 'loading' && (
          <div className="flex items-center gap-3">
            <span className="hidden font-body text-mist-300 sm:inline">Sign in to save your World Cup and play friends.</span>
            <LinkBtn to="/login" variant="primary">Sign in</LinkBtn>
          </div>
        )}
      </div>

      <div className="grid flex-1 gap-4 md:grid-cols-4">
        <HomeTile
          accent="#ffc83a"
          label="Solo"
          title="World Cup"
          badge={run.data && !finished ? <Badge tone="gold">Continue</Badge> : undefined}
          sub={
            !signedIn ? 'Sign in to start your campaign' : runInfo ? `${runInfo.title} · ${runInfo.sub}` : 'Pick a nation and chase the trophy'
          }
          art={<TrophyArt className="h-full max-h-[230px] w-auto drop-shadow-[0_10px_30px_rgba(255,200,58,0.45)]" />}
          flag={run.data?.tournament.nationId}
          onClick={() => gate('/world-cup')}
          autoFocus
        />
        <HomeTile
          accent="#ff3d8b"
          label="Online"
          title="Play a Friend"
          badge={invites.length ? <Badge tone="hot">{invites.length} invite{invites.length > 1 ? 's' : ''}</Badge> : online ? <Badge tone="win">{online} online</Badge> : undefined}
          sub={signedIn ? 'Create a room, share the code, kick off' : 'Sign in to play head to head'}
          art={<VersusArt className="h-full max-h-[200px] w-auto" />}
          onClick={() => gate('/online')}
        />
        <HomeTile
          accent="#28e4ff"
          label="Warm up"
          title="Practice"
          sub="Learn the controls on an open pitch. No clock, no pressure."
          art={<PracticeArt className="h-full max-h-[200px] w-auto" />}
          onClick={() => navigate('/practice')}
        />
        <HomeTile
          accent="#ffffff"
          label={signedIn ? 'Career' : 'Profile'}
          title={signedIn ? 'Your Record' : 'Account'}
          sub={
            signedIn && record.data
              ? `${record.data.wins} W · ${record.data.draws} D · ${record.data.losses} L against friends`
              : signedIn
                ? 'Friend matches, head to head, settings'
                : 'Create an account in a minute'
          }
          art={<ProfileArt className="h-full max-h-[200px] w-auto" />}
          onClick={() => (signedIn ? navigate('/profile') : navigate('/signup'))}
        />
      </div>

      <p className="mt-6 text-center font-body text-sm text-mist-400">
        Tip: hold a pass or shot button to charge the power bar. Tap it for a soft pass.
      </p>
    </div>
  );
}

function HomeTile({
  accent,
  label,
  title,
  sub,
  art,
  badge,
  flag,
  onClick,
  autoFocus,
}: {
  accent: string;
  label: string;
  title: string;
  sub: string;
  art: ReactNode;
  badge?: ReactNode;
  flag?: string;
  onClick: () => void;
  autoFocus?: boolean;
}) {
  return (
    <Tile
      accent={accent}
      onClick={onClick}
      autoFocus={autoFocus}
      data-autofocus={autoFocus ? '' : undefined}
      className="min-h-[132px] flex-row md:min-h-[460px] md:flex-col"
    >
      <div
        className="relative flex w-[38%] shrink-0 items-center justify-center overflow-hidden p-3 md:w-auto md:flex-1 md:p-6"
        style={{ background: `radial-gradient(circle at 50% 40%, ${accent}38, transparent 65%)` }}
      >
        {art}
        {flag && <Flag nation={flag} className="absolute right-3 top-6 h-7 w-10" />}
      </div>
      <div className="flex flex-1 flex-col justify-center gap-1 bg-ink-950/45 p-4 md:flex-none md:p-5">
        <div className="flex items-center justify-between gap-2">
          <span className="t-label">{label}</span>
          {badge}
        </div>
        <span className="t-display text-2xl text-white md:text-4xl">{title}</span>
        <span className="line-clamp-3 font-body text-sm leading-snug text-mist-300 md:min-h-[3.4rem]">{sub}</span>
      </div>
    </Tile>
  );
}
