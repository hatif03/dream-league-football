import { call } from './http';

export interface LeaderEntry {
  rank: number;
  userId: string;
  name: string;
  avatar?: number | null;
  played: number;
  wins: number;
  draws: number;
  losses: number;
  titles: number;
  points: number;
}

export interface LeaderboardView {
  top: LeaderEntry[];
  you?: LeaderEntry | null;
  total: number;
}

export interface Achievement {
  id: string;
  title: string;
  description: string;
  done: boolean;
  progress: number;
  target: number;
}

export const getLeaderboard = (limit = 25) => call<LeaderboardView>('rankings/leaderboard', { limit });
export const getAchievements = () => call<Achievement[]>('rankings/achievements', {});
