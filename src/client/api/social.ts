import { call, callPublic } from './http';

export interface Person {
  userId: string;
  name: string;
  /** Checked in within the last minute or so. */
  online: boolean;
}

export interface Invite {
  lobbyId: string;
  code: string;
  fromName: string;
  createdAt: string;
}

export interface FriendsView {
  friends: Person[];
  incoming: Person[];
  outgoing: Person[];
  blocked: Person[];
  invites: Invite[];
}

export interface ChatLine {
  id: string;
  userId: string;
  name: string;
  text: string;
  createdAt: string;
}

export interface HeadToHead {
  opponentName: string;
  opponentUserId?: string | null;
  wins: number;
  draws: number;
  losses: number;
}

export interface RecordView {
  wins: number;
  draws: number;
  losses: number;
  abandoned: number;
  headToHead: HeadToHead[];
}

export interface LiveStatus {
  maintenance: boolean;
  message?: string | null;
}

export const getFriends = () => call<FriendsView>('friends/list');
export const requestFriend = (name: string) => call<FriendsView>('friends/request', { name });
export const acceptFriend = (userId: string) => call<FriendsView>('friends/accept', { userId });
export const removeFriend = (userId: string) => call<FriendsView>('friends/remove', { userId });
export const blockPlayer = (userId: string) => call<FriendsView>('friends/block', { userId });
export const unblockPlayer = (userId: string) => call<FriendsView>('friends/unblock', { userId });
export const inviteFriend = (userId: string, lobbyId: string) =>
  call<void>('friends/invite', { userId, lobbyId });
export const dismissInvite = (lobbyId: string) => call<FriendsView>('friends/dismissInvite', { lobbyId });

export const sendChat = (lobbyId: string, text: string) => call<void>('chat/send', { lobbyId, text });
export const getChat = (lobbyId: string) => call<ChatLine[]>('chat/list', { lobbyId });

export const reportPlayer = (targetUserId: string, matchId: string | null, reason: string) =>
  call<void>('report/create', { targetUserId, matchId, reason });

export const getRecord = () => call<RecordView>('profile/record');
export const deleteAccount = () => call<void>('profile/deleteAccount');

export const getLiveStatus = () => callPublic<LiveStatus>('liveOps/get');
