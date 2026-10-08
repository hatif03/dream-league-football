import { useQuery } from '@tanstack/react-query';
import { useSession } from './session';
import { getCurrentRun } from './tournament';
import { getRecord } from './social';
import { matchHistory } from './friend';
import { getAchievements, getLeaderboard, type LeaderBy } from './rankings';
import { getDailyChallenge } from './duel';

/** The signed-in player's solo World Cup run (null if none). */
export function useRun() {
  const signedIn = useSession().status === 'in';
  return useQuery({ queryKey: ['run'], queryFn: getCurrentRun, enabled: signedIn, staleTime: 15_000 });
}

export function useRecord() {
  const signedIn = useSession().status === 'in';
  return useQuery({ queryKey: ['record'], queryFn: getRecord, enabled: signedIn, staleTime: 30_000 });
}

export function useHistory(limit = 10) {
  const signedIn = useSession().status === 'in';
  return useQuery({ queryKey: ['history', limit], queryFn: () => matchHistory(limit), enabled: signedIn, staleTime: 15_000 });
}

export function useAchievements() {
  const signedIn = useSession().status === 'in';
  return useQuery({ queryKey: ['achievements'], queryFn: getAchievements, enabled: signedIn, staleTime: 30_000 });
}

export function useLeaderboard(limit = 25, by: LeaderBy = 'rating') {
  const signedIn = useSession().status === 'in';
  return useQuery({ queryKey: ['leaderboard', limit, by], queryFn: () => getLeaderboard(limit, by), enabled: signedIn, staleTime: 20_000 });
}

export function useDailyChallenge() {
  const signedIn = useSession().status === 'in';
  return useQuery({ queryKey: ['daily'], queryFn: getDailyChallenge, enabled: signedIn, staleTime: 30_000 });
}
