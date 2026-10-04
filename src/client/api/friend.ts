import { API_URL, call, getAuth } from './http';

export interface Lobby {
  id: string;
  code: string;
  hostUserId: string;
  guestUserId?: string | null;
  hostNation?: string | null;
  guestNation?: string | null;
  hostReady: boolean;
  guestReady: boolean;
  /** open | live | closed */
  status: string;
  clientVersion: string;
  matchId?: string | null;
  rematchLobbyId?: string | null;
}

export interface LobbyView {
  lobby: Lobby;
  hostName: string;
  hostAvatar?: number | null;
  guestName?: string | null;
  guestAvatar?: number | null;
  youAreHost: boolean;
}

export interface FriendMatch {
  id: string;
  lobbyId: string;
  hostUserId?: string | null;
  guestUserId?: string | null;
  hostNation: string;
  guestNation: string;
  /** live | finished | abandoned | void */
  status: string;
  hostGoals?: number | null;
  guestGoals?: number | null;
  endReason?: string | null;
  winnerUserId?: string | null;
  leaverUserId?: string | null;
  transport?: string | null;
  /** JSON of the end-of-match numbers, when the host reported them. */
  stats?: string | null;
  startedAt: string;
}

export interface MatchView {
  match: FriendMatch;
  hostName: string;
  guestName: string;
  youAreHost: boolean;
}

export interface SignalView {
  offer?: string | null;
  answer?: string | null;
  status: string;
}

/** Build id both players must share. Injected by Vite from a hash of src/client/game. */
export const CLIENT_VERSION: string = typeof __BUILD_ID__ === 'string' ? __BUILD_ID__ : 'dev';

export const createLobby = () => call<LobbyView>('lobby/create', { clientVersion: CLIENT_VERSION });
export const joinLobby = (code: string) => call<LobbyView>('lobby/join', { code, clientVersion: CLIENT_VERSION });
export const getLobby = (lobbyId: string) => call<LobbyView>('lobby/get', { lobbyId });
export const setNation = (lobbyId: string, nationId: string) =>
  call<LobbyView>('lobby/setNation', { lobbyId, nationId });
export const setReady = (lobbyId: string, ready: boolean) =>
  call<LobbyView>('lobby/setReady', { lobbyId, ready });
export const leaveLobby = (lobbyId: string) => call<void>('lobby/leave', { lobbyId });
export const rematch = (lobbyId: string) =>
  call<LobbyView>('lobby/rematch', { lobbyId, clientVersion: CLIENT_VERSION });

export const getMatch = (matchId: string) => call<MatchView>('friendMatch/get', { matchId });
export const postOffer = (matchId: string, sdp: string) => call<void>('friendMatch/postOffer', { matchId, sdp });
export const postAnswer = (matchId: string, sdp: string) => call<void>('friendMatch/postAnswer', { matchId, sdp });
export const getSignal = (matchId: string) => call<SignalView>('friendMatch/getSignal', { matchId });
export const reportConnected = (matchId: string, transport: 'direct' | 'relay') =>
  call<void>('friendMatch/connected', { matchId, transport });
export const claimResult = (
  matchId: string,
  hostGoals: number,
  guestGoals: number,
  reason: 'fulltime' | 'abandoned',
  stats?: string,
) => call<MatchView>('friendMatch/claim', { matchId, hostGoals, guestGoals, reason, stats });
export const matchHistory = (limit = 20) => call<MatchView[]>('friendMatch/history', { limit });

/** Leave a live match on purpose: it ends at once as abandoned and the opponent is told. */
export const leaveMatch = (matchId: string) => call<MatchView>('friendMatch/leave', { matchId });

/** Same, but survives the tab closing (keepalive), for pagehide. */
export function leaveMatchOnUnload(matchId: string) {
  const token = getAuth()?.token;
  if (!token) return;
  try {
    void fetch(`${API_URL}/friendMatch/leave`, {
      method: 'POST',
      keepalive: true,
      headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${token}` },
      body: JSON.stringify({ matchId }),
    });
  } catch {
    /* nothing more to do while unloading */
  }
}

/** Leave a room on unload too, so the host sees the seat free up. */
export function leaveLobbyOnUnload(lobbyId: string) {
  const token = getAuth()?.token;
  if (!token) return;
  try {
    void fetch(`${API_URL}/lobby/leave`, {
      method: 'POST',
      keepalive: true,
      headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${token}` },
      body: JSON.stringify({ lobbyId }),
    });
  } catch {
    /* nothing more to do while unloading */
  }
}
