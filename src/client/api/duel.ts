import { call } from './http';
import { CLIENT_VERSION, type LobbyView } from './friend';

// Matchmaking, the server-refereed penalty duel, the daily challenge and shareable result links.

export interface QueueStatus {
  searching: boolean;
  waitedSecs: number;
  mode: string;
  /** Other players waiting for the same kind of game. */
  queued: number;
  /** Set when an opponent was found. */
  lobby?: LobbyView | null;
}

export const joinQueue = (mode: 'match' | 'penalties') =>
  call<QueueStatus>('matchmaking/join', { mode, clientVersion: CLIENT_VERSION });
export const queueStatus = () => call<QueueStatus>('matchmaking/status', {});
export const cancelQueue = () => call<void>('matchmaking/cancel', {});

/** A kick as a player may see it: nothing about the keeper's choice until it is settled. */
export interface KickView {
  seq: number;
  shooterIsHost: boolean;
  shooterZone?: number | null;
  keeperZone?: number | null;
  /** goal | saved | miss | post */
  outcome?: string | null;
}

export interface DuelView {
  matchId: string;
  /** live | finished | abandoned | void */
  status: string;
  youAreHost: boolean;
  hostName: string;
  guestName: string;
  hostGoals: number;
  guestGoals: number;
  kicks: KickView[];
  /** The kick being played now, or -1 when the duel is over. */
  seq: number;
  youShoot: boolean;
  youSubmitted: boolean;
  msLeft: number;
  youWon?: boolean | null;
  ratingDelta?: number | null;
}

export const getDuel = (matchId: string) => call<DuelView>('penalty/state', { matchId });
export const submitKick = (matchId: string, seq: number, zone: number) =>
  call<DuelView>('penalty/submit', { matchId, seq, zone });

export interface DailyChallenge {
  day: string;
  kind: string;
  title: string;
  description: string;
  target: number;
  progress: number;
  done: boolean;
  streak: number;
}

export const getDailyChallenge = () => call<DailyChallenge>('challenges/today', {});

export interface ShareLink {
  id: string;
  imageUrl: string;
}

/** Stores a result picture (PNG as base64) and returns the id of the public /r/<id> page. */
export const createSharedResult = (pngBase64: string, title: string, description: string) =>
  call<ShareLink>('share/createResult', { pngBase64, title, description });

