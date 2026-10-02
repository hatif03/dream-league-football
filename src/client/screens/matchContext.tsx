import { createContext, useCallback, useContext, useMemo, useState, type ReactNode } from 'react';
import { useNavigate } from 'react-router-dom';
import type { TeamData } from '@/client/game/teams';
import type { LobbyView } from '@/client/api/friend';
import type { TournamentFixture } from '@/client/api/tournament';

export type MatchConfig =
  | { kind: 'practice'; home: TeamData; away: TeamData; returnTo: string }
  | { kind: 'worldcup'; fixture: TournamentFixture; tournamentId: string; user: TeamData; opp: TeamData; returnTo: string }
  | { kind: 'friend'; view: LobbyView; returnTo: string };

interface Value {
  config: MatchConfig | null;
  /** Open the match screen for this game. */
  start: (c: MatchConfig) => void;
  /** Leave the match screen for where the player came from. */
  end: (to?: string, state?: unknown) => void;
}

const Ctx = createContext<Value | null>(null);
export const useMatch = (): Value => {
  const v = useContext(Ctx);
  if (!v) throw new Error('MatchProvider missing');
  return v;
};

/** Which game the match screen is playing. Cleared when the match is left. */
export function MatchProvider({ children }: { children: ReactNode }) {
  const [config, setConfig] = useState<MatchConfig | null>(null);
  const navigate = useNavigate();
  const start = useCallback(
    (c: MatchConfig) => {
      setConfig(c);
      navigate('/match');
    },
    [navigate],
  );
  const end = useCallback(
    (to?: string, state?: unknown) => {
      setConfig((c) => {
        queueMicrotask(() => navigate(to ?? c?.returnTo ?? '/', { replace: true, state }));
        return null;
      });
    },
    [navigate],
  );
  const value = useMemo(() => ({ config, start, end }), [config, start, end]);
  return <Ctx.Provider value={value}>{children}</Ctx.Provider>;
}
