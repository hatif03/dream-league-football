import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { toast } from 'react-hot-toast';
import { useQueryClient } from '@tanstack/react-query';
import { Avatar, Badge, Btn, Spinner } from '@/client/ui/controls';
import { Flag } from '@/client/ui/Flag';
import { useDialog } from '@/client/ui/Dialog';
import { TEAMS, nationId, teamById } from '@/client/game/teams';
import { call } from '@/client/api/http';
import { signOut, useSession } from '@/client/api/session';
import { deleteAccount } from '@/client/api/social';
import { useHistory, useRecord } from '@/client/api/queries';
import type { MatchView } from '@/client/api/friend';

function matchLine(m: MatchView) {
  const mine = m.youAreHost ? m.match.hostGoals : m.match.guestGoals;
  const theirs = m.youAreHost ? m.match.guestGoals : m.match.hostGoals;
  const myId = m.youAreHost ? m.match.hostUserId : m.match.guestUserId;
  const opp = m.youAreHost ? m.guestName : m.hostName;
  const myNation = m.youAreHost ? m.match.hostNation : m.match.guestNation;
  const theirNation = m.youAreHost ? m.match.guestNation : m.match.hostNation;
  let result: { label: string; tone: 'win' | 'hot' | 'mute' | 'gold' };
  if (m.match.status === 'finished') {
    result = !m.match.winnerUserId ? { label: 'Draw', tone: 'gold' } : m.match.winnerUserId === myId ? { label: 'Win', tone: 'win' } : { label: 'Loss', tone: 'hot' };
  } else if (m.match.status === 'abandoned') result = { label: 'Abandoned', tone: 'mute' };
  else if (m.match.status === 'void') result = { label: 'No result', tone: 'mute' };
  else result = { label: 'Live', tone: 'mute' };
  return { mine, theirs, opp, myNation, theirNation, result, finished: m.match.status === 'finished' };
}

export default function ProfileScreen() {
  const session = useSession();
  const navigate = useNavigate();
  const dialog = useDialog();
  const qc = useQueryClient();
  const record = useRecord();
  const history = useHistory(15);
  const [saving, setSaving] = useState(false);

  if (session.status !== 'in') return <div className="p-10"><Spinner /></div>;
  const profile = session.profile;

  const setFav = async (id: string) => {
    setSaving(true);
    try {
      await call('profile/updateProfile', { region: profile.region ?? null, favouriteNation: id || null });
      toast.success('Saved');
    } catch (e) {
      toast.error((e as Error).message);
    } finally {
      setSaving(false);
    }
  };

  const doSignOut = async () => {
    if (await dialog.confirm({ title: 'Sign out?', body: 'Your World Cup and records stay saved.', confirmLabel: 'Sign out' })) {
      qc.clear();
      signOut();
      navigate('/');
    }
  };

  const doDelete = async () => {
    const typed = await dialog.prompt({
      title: 'Delete your account?',
      body: `This removes your sign-in, World Cup runs, friends and chat. Matches you played stay for the other player as "Removed player". This cannot be undone. Type ${profile.displayName} to confirm.`,
      label: 'Your display name',
      confirmLabel: 'Delete forever',
    });
    if (typed !== profile.displayName) {
      if (typed !== null) toast.error('That is not your name, so nothing was deleted.');
      return;
    }
    try {
      await deleteAccount();
      qc.clear();
      signOut();
      navigate('/');
    } catch (e) {
      toast.error((e as Error).message);
    }
  };

  return (
    <div className="mx-auto max-w-5xl px-4 py-6 md:py-8">
      <div className="glass flex flex-wrap items-center gap-5 p-5 md:p-7 animate-screen-in">
        <Avatar name={profile.displayName} online size={84} />
        <div className="min-w-0 flex-1">
          <div className="t-label">Player</div>
          <h1 className="t-display truncate text-4xl text-white md:text-6xl">{profile.displayName}</h1>
        </div>
        <label className="flex items-center gap-3">
          <span className="t-label hidden sm:inline">Favourite nation</span>
          {profile.favouriteNation && <Flag nation={profile.favouriteNation} className="h-8 w-12" />}
          <select className="field !w-52" disabled={saving} defaultValue={profile.favouriteNation ?? ''} onChange={(e) => setFav(e.target.value)} aria-label="Favourite nation">
            <option value="">None</option>
            {TEAMS.map((t) => <option key={nationId(t)} value={nationId(t)}>{t.name}</option>)}
          </select>
        </label>
      </div>

      <section className="mt-5 grid grid-cols-2 gap-3 md:grid-cols-4" aria-label="Friend match record">
        {[
          ['Wins', record.data?.wins, '#3df08a'],
          ['Draws', record.data?.draws, '#ffd54f'],
          ['Losses', record.data?.losses, '#ff5470'],
          ['Abandoned', record.data?.abandoned, '#9792d3'],
        ].map(([label, v, c]) => (
          <div key={label as string} className="glass p-4 text-center" style={{ borderTop: `4px solid ${c}` }}>
            <div className="t-display text-5xl text-white tabular">{record.isLoading ? '–' : (v as number | undefined) ?? 0}</div>
            <div className="t-label">{label}</div>
          </div>
        ))}
      </section>

      <div className="mt-5 grid gap-5 md:grid-cols-2">
        <section className="glass p-5" aria-label="Head to head">
          <h2 className="t-display mb-3 text-2xl text-white">Head to head</h2>
          {!record.data?.headToHead.length ? (
            <p className="font-body text-mist-400">Play a friend and your record against them shows up here.</p>
          ) : (
            <table className="w-full font-body text-sm">
              <thead><tr className="text-left text-mist-400"><th className="pb-1">Opponent</th><th className="text-right">W</th><th className="text-right">D</th><th className="text-right">L</th></tr></thead>
              <tbody>
                {record.data.headToHead.map((h) => (
                  <tr key={h.opponentUserId ?? h.opponentName} className="border-t border-white/10 text-white">
                    <td className="py-1.5">{h.opponentName}</td>
                    <td className="text-right tabular text-win">{h.wins}</td>
                    <td className="text-right tabular text-gold-400">{h.draws}</td>
                    <td className="text-right tabular text-loss">{h.losses}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}
        </section>

        <section className="glass p-5" aria-label="Recent matches">
          <h2 className="t-display mb-3 text-2xl text-white">Recent matches</h2>
          {history.isLoading ? (
            <div className="space-y-2">{[0, 1, 2].map((i) => <div key={i} className="skeleton h-10" />)}</div>
          ) : !history.data?.length ? (
            <p className="font-body text-mist-400">No friend matches yet.</p>
          ) : (
            <ul className="space-y-1.5">
              {history.data.map((m) => {
                const l = matchLine(m);
                return (
                  <li key={m.match.id} className="flex items-center gap-3 rounded bg-white/5 px-3 py-2">
                    <Flag nation={l.myNation} className="h-5 w-7" />
                    <span className="t-display w-16 text-center text-xl tabular text-white">{l.finished ? `${l.mine} – ${l.theirs}` : 'v'}</span>
                    <Flag nation={l.theirNation} className="h-5 w-7" />
                    <span className="min-w-0 flex-1 truncate font-body text-sm text-mist-200">{l.opp}</span>
                    <Badge tone={l.result.tone}>{l.result.label}</Badge>
                  </li>
                );
              })}
            </ul>
          )}
        </section>
      </div>

      <div className="mt-8 flex flex-wrap items-center justify-between gap-3 border-t border-white/10 pt-5">
        <Btn onClick={doSignOut}>Sign out</Btn>
        <button className="font-body text-sm text-mist-400 underline hover:text-loss" onClick={doDelete}>Delete my account</button>
      </div>
      <p className="mt-6 text-center font-body text-xs text-mist-500">{teamById(profile.favouriteNation ?? '')?.name ? `Supporting ${teamById(profile.favouriteNation ?? '')?.name}` : ''}</p>
    </div>
  );
}
