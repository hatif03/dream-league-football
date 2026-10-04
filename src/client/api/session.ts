import { useSyncExternalStore } from 'react';
import { call, callPublic, getAuth, onAuthChange, setAuth, storeAuthSuccess } from './http';
import { adoptAccountSettings } from './settingsSync';

export interface UserProfile {
  id: string;
  userId: string;
  displayName: string;
  region?: string | null;
  favouriteNation?: string | null;
  /** One of the 24 pre-made avatars, or null until chosen. */
  avatar?: number | null;
  /** The player's saved settings as JSON (see settingsSync). */
  settings?: string | null;
  /** The player's club crest and kit as JSON. */
  club?: string | null;
  termsAcceptedAt?: string | null;
}

export type SessionState =
  | { status: 'loading' }
  | { status: 'out' }
  /** Signed in but no display name yet. */
  | { status: 'needsProfile' }
  | { status: 'in'; profile: UserProfile };

let state: SessionState = getAuth() ? { status: 'loading' } : { status: 'out' };
const subs = new Set<() => void>();

function set(next: SessionState) {
  state = next;
  subs.forEach((s) => s());
}

/** Replace the signed-in profile with a fresh copy the server just returned. */
export function applyProfile(p: UserProfile) {
  set({ status: 'in', profile: p });
}

export async function loadProfile() {
  if (!getAuth()) return set({ status: 'out' });
  try {
    const p = await call<UserProfile | null>('profile/me');
    set(p ? { status: 'in', profile: p } : { status: 'needsProfile' });
    if (p) adoptAccountSettings(p.userId, p.settings);
  } catch {
    // A rejected session (tokens already cleared) or an unreachable server both
    // land on the signed-out screen; stored tokens survive a network failure.
    set({ status: 'out' });
  }
}

onAuthChange(() => {
  if (!getAuth()) set({ status: 'out' });
});
if (getAuth()) void loadProfile();

export function useSession(): SessionState {
  return useSyncExternalStore(
    (cb) => {
      subs.add(cb);
      return () => subs.delete(cb);
    },
    () => state,
  );
}

export async function signIn(email: string, password: string) {
  storeAuthSuccess(await callPublic('emailIdp/login', { email, password }));
  set({ status: 'loading' });
  await loadProfile();
}

/** Step 1 of registration: emails a code. Returns the request id for step 2. */
export const startRegistration = (email: string) =>
  callPublic<string>('emailIdp/startRegistration', { email });

/** Steps 2 and 3: verify the code, set the password, and sign in. */
export async function finishRegistration(requestId: string, code: string, password: string) {
  const token = await callPublic<string>('emailIdp/verifyRegistrationCode', {
    accountRequestId: requestId,
    verificationCode: code,
  });
  storeAuthSuccess(await callPublic('emailIdp/finishRegistration', { registrationToken: token, password }));
  set({ status: 'loading' });
  await loadProfile();
}

export const startPasswordReset = (email: string) =>
  callPublic<string>('emailIdp/startPasswordReset', { email });

export async function finishPasswordReset(requestId: string, code: string, newPassword: string) {
  const token = await callPublic<string>('emailIdp/verifyPasswordResetCode', {
    passwordResetRequestId: requestId,
    verificationCode: code,
  });
  await callPublic('emailIdp/finishPasswordReset', { finishPasswordResetToken: token, newPassword });
}

export async function createProfile(displayName: string) {
  const p = await call<UserProfile>('profile/createProfile', { displayName, acceptTerms: true });
  set({ status: 'in', profile: p });
}

export function signOut() {
  setAuth(null);
}
