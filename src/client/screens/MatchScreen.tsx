import { Navigate } from 'react-router-dom';
import { useMatch } from './matchContext';
import { LocalMatch } from './match/LocalMatch';
import { FriendMatchStage } from './match/FriendMatchStage';

/** Plays whichever game `useMatch().start(...)` set up. Without one, back to the menu. */
export default function MatchScreen() {
  const { config, end } = useMatch();
  if (!config) return <Navigate to="/" replace />;

  if (config.kind === 'friend') {
    return (
      <FriendMatchStage
        key={config.view.lobby.matchId}
        view={config.view}
        onExit={() => end()}
        onRematch={(lobby) => end('/online', { lobby })}
      />
    );
  }
  if (config.kind === 'worldcup') {
    return <LocalMatch key={config.fixture.id} kind="worldcup" home={config.user} away={config.opp} fixture={config.fixture} tournamentId={config.tournamentId} onExit={() => end()} />;
  }
  return <LocalMatch kind="practice" home={config.home} away={config.away} onExit={() => end()} />;
}
