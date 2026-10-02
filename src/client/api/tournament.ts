import { call } from './http';

export interface Tournament {
  id: string;
  nationId: string;
  /** group | r32 | r16 | qf | sf | final (the round being played) | eliminated | champion */
  status: string;
  eliminatedIn?: string | null;
}

export type Round = 'group' | 'r32' | 'r16' | 'qf' | 'sf' | 'final';
export const ROUND_NAMES: Record<string, string> = {
  group: 'Group stage',
  r32: 'Round of 32',
  r16: 'Round of 16',
  qf: 'Quarter-finals',
  sf: 'Semi-finals',
  final: 'Final',
};

export interface TournamentFixture {
  id: string;
  round: Round;
  matchNo?: number | null;
  groupName: string;
  matchday: number;
  kickoffUtc: string;
  homeNation: string;
  awayNation: string;
  venue: string;
  homeScore?: number | null;
  awayScore?: number | null;
  homePens?: number | null;
  awayPens?: number | null;
  decidedBy?: string | null;
  playedByUser: boolean;
}

export interface StandingRow {
  groupName: string;
  nationId: string;
  position: number;
  played: number;
  won: number;
  drawn: number;
  lost: number;
  goalsFor: number;
  goalsAgainst: number;
  points: number;
  qualified: boolean;
}

export interface TournamentView {
  tournament: Tournament;
  fixtures: TournamentFixture[];
  standings: StandingRow[];
  nextFixtureId?: string | null;
  matchday: number;
}

export const getCurrentRun = () => call<TournamentView | null>('tournament/current');
export const startRun = (nationId: string) => call<TournamentView>('tournament/start', { nationId });
export const abandonRun = () => call<void>('tournament/abandon');

export const submitResult = (
  tournamentId: string,
  fixtureId: string,
  nonce: string,
  homeScore: number,
  awayScore: number,
  extra: { homePens?: number; awayPens?: number; decidedBy?: string } = {},
) =>
  call<TournamentView>('tournament/submitResult', {
    tournamentId,
    fixtureId,
    nonce,
    homeScore,
    awayScore,
    ...extra,
  });
