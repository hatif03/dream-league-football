import { Link } from 'react-router-dom';
import { useLeaderboard } from '@/client/api/queries';
import type { LeaderEntry } from '@/client/api/rankings';
import { useSession } from '@/client/api/session';
import { Avatar, Spinner } from '@/client/ui/controls';
import { useHints } from '@/client/ui/hints';

function Row({ e, me }: { e: LeaderEntry; me: boolean }) {
  return (
    <tr className={`border-t border-white/10 ${me ? 'bg-neon-400/15 text-white' : 'text-mist-100'}`}>
      <td className="w-12 py-2 pl-3 font-display text-xl font-bold tabular text-mist-300">{e.rank}</td>
      <td className="py-2">
        <span className="flex items-center gap-2">
          <Avatar name={e.name} avatar={e.avatar} size={30} />
          <span className="truncate font-display text-lg font-bold uppercase">
            {e.name}
            {me ? ' (you)' : ''}
          </span>
        </span>
      </td>
      <td className="hidden text-right tabular sm:table-cell">{e.played}</td>
      <td className="text-right tabular text-win">{e.wins}</td>
      <td className="hidden text-right tabular text-gold-400 sm:table-cell">{e.draws}</td>
      <td className="hidden text-right tabular text-loss sm:table-cell">{e.losses}</td>
      <td className="text-right tabular text-gold-400">{e.titles > 0 ? `🏆 ${e.titles}` : ''}</td>
      <td className="pr-3 text-right font-display text-xl font-bold tabular text-white">{e.points}</td>
    </tr>
  );
}

/** The best players: 3 points for a friend-match win, 1 for a draw, 25 for a World Cup title. */
export default function LeaderboardScreen() {
  const session = useSession();
  const board = useLeaderboard(25);
  useHints([{ kb: 'Esc', pad: 'B', label: 'Back' }]);
  const meId = session.status === 'in' ? session.profile.userId : '';
  const data = board.data;
  const youBelow = data?.you && !data.top.some((e) => e.userId === data.you!.userId) ? data.you : null;

  return (
    <div className="mx-auto max-w-4xl px-4 py-5 md:py-8">
      <div className="mb-4">
        <div className="t-label">Global</div>
        <h1 className="t-display text-4xl text-white md:text-6xl">Leaderboard</h1>
      </div>
      <div className="glass p-3 md:p-5 animate-screen-in">
        {board.isLoading ? (
          <div className="p-6">
            <Spinner />
          </div>
        ) : board.isError ? (
          <p className="p-4 font-body text-mist-300">
            Could not load the leaderboard.{' '}
            <button className="text-neon-400 underline" onClick={() => board.refetch()}>
              Try again
            </button>
          </p>
        ) : !data?.top.length ? (
          <p className="p-4 font-body text-mist-300">Nobody is ranked yet. Finish a match against a friend, or win the World Cup, to take the first place.</p>
        ) : (
          <table className="w-full font-body text-sm">
            <thead>
              <tr className="text-left text-mist-400">
                <th className="pb-2 pl-3">#</th>
                <th className="pb-2">Player</th>
                <th className="hidden pb-2 text-right sm:table-cell">P</th>
                <th className="pb-2 text-right">W</th>
                <th className="hidden pb-2 text-right sm:table-cell">D</th>
                <th className="hidden pb-2 text-right sm:table-cell">L</th>
                <th className="pb-2 text-right">Cups</th>
                <th className="pb-2 pr-3 text-right">Pts</th>
              </tr>
            </thead>
            <tbody>
              {data.top.map((e) => (
                <Row key={e.userId} e={e} me={e.userId === meId} />
              ))}
              {youBelow && (
                <>
                  <tr>
                    <td colSpan={8} className="py-1 text-center text-mist-500">
                      …
                    </td>
                  </tr>
                  <Row e={youBelow} me />
                </>
              )}
            </tbody>
          </table>
        )}
        <p className="mt-4 px-3 font-body text-xs text-mist-400">
          Points: 3 for each friend-match win, 1 for each draw, 25 for each solo World Cup you win. {data ? `${data.total} players are ranked.` : ''} Abandoned and void matches count for nobody.{' '}
          {data && !data.you && (
            <>
              <Link to="/online" className="text-neon-400 underline">
                Play a friend
              </Link>{' '}
              to get on the board.
            </>
          )}
        </p>
      </div>
    </div>
  );
}
