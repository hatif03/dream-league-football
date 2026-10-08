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
  /** Elo rating from friend matches and penalty duels (starts at 1000). */
  rating: number;
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

export type LeaderBy = 'rating' | 'points';
export const getLeaderboard = (limit = 25, by: LeaderBy = 'rating') => call<LeaderboardView>('rankings/leaderboard', { limit, by });
export const getAchievements = () => call<Achievement[]>('rankings/achievements', {});
