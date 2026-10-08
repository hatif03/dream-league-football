import { Navigate } from 'react-router-dom';
import { useMatch } from './matchContext';
import { LocalMatch } from './match/LocalMatch';
import { FriendMatchStage } from './match/FriendMatchStage';
import { DuelStage } from './match/DuelStage';

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
  if (config.kind === 'duel') {
    return <DuelStage key={config.view.lobby.matchId} view={config.view} onExit={() => end()} onRematch={(lobby) => end('/online', { lobby })} />;
  }
  if (config.kind === 'worldcup') {
    return <LocalMatch key={config.fixture.id} kind="worldcup" home={config.user} away={config.opp} fixture={config.fixture} tournamentId={config.tournamentId} onExit={() => end()} />;
  }
  if (config.kind === 'friendly') {
    return <LocalMatch kind="friendly" home={config.home} away={config.away} decide={config.decide} onExit={() => end()} />;
  }
  if (config.kind === 'penalties') {
    return <LocalMatch kind="penalties" home={config.home} away={config.away} onExit={() => end()} />;
  }
  return <LocalMatch kind="practice" home={config.home} away={config.away} tutorial={config.tutorial} onExit={() => end()} />;
}
