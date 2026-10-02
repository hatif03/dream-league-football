// Thin client for Serverpod's JSON method-call API: POST /<endpoint>/<method>
// with a JSON body and `Authorization: Bearer <jwt>`.

/**
 * Where Serverpod's API lives. Set VITE_API_URL to override (a custom domain, say).
 * Otherwise: localhost in development, and on Serverpod Cloud the web host
 * <project>.serverpod.space maps to <project>.api.serverpod.space.
 */
function defaultApiUrl(): string {
  if (import.meta.env.VITE_API_URL) return import.meta.env.VITE_API_URL;
  if (import.meta.env.DEV) return 'http://localhost:8080';
  const { protocol, hostname } = location;
  if (hostname === 'localhost' || hostname === '127.0.0.1') return `${protocol}//${hostname}:8080`;
  return `${protocol}//${hostname.replace(/^([^.]+)\./, '$1.api.')}`;
}

export const API_URL: string = defaultApiUrl();

const STORE_KEY = 'wc2026.auth';

export interface StoredAuth {
  token: string;
  refreshToken: string | null;
  /** ms since epoch when the access token expires. */
  expiresAt: number;
}

export class ApiError extends Error {
  constructor(
    message: string,
    public status: number,
  ) {
    super(message);
  }
}

let auth: StoredAuth | null = readStored();
const listeners = new Set<() => void>();

function readStored(): StoredAuth | null {
  try {
    const raw = localStorage.getItem(STORE_KEY);
    return raw ? (JSON.parse(raw) as StoredAuth) : null;
  } catch {
    return null;
  }
}

export function getAuth() {
  return auth;
}

export function setAuth(next: StoredAuth | null) {
  auth = next;
  try {
    if (next) localStorage.setItem(STORE_KEY, JSON.stringify(next));
    else localStorage.removeItem(STORE_KEY);
  } catch {
    /* storage unavailable: the session lasts until reload */
  }
  listeners.forEach((l) => l());
}

export function onAuthChange(fn: () => void) {
  listeners.add(fn);
  return () => listeners.delete(fn);
}

interface AuthSuccess {
  token: string;
  tokenExpiresAt?: string | null;
  refreshToken?: string | null;
}

export function storeAuthSuccess(a: AuthSuccess) {
  setAuth({
    token: a.token,
    refreshToken: a.refreshToken ?? null,
    expiresAt: a.tokenExpiresAt ? Date.parse(a.tokenExpiresAt) : Date.now() + 9 * 60_000,
  });
}

/** Reason codes from Serverpod's email sign-in exceptions, in plain words. */
function authReason(reason: unknown): string | undefined {
  switch (reason) {
    case 'invalidCredentials':
      return 'Wrong email or password.';
    case 'tooManyAttempts':
      return 'Too many attempts. Wait a few minutes and try again.';
    case 'expired':
      return 'That code has expired. Start again to get a new one.';
    case 'invalid':
      return 'That code is not right. Check the email and try again.';
    case 'policyViolation':
      return 'That email or password is not allowed. Use a valid email and at least 8 characters.';
    default:
      return undefined;
  }
}

async function post<T>(path: string, body: unknown, token?: string): Promise<T> {
  let res: Response;
  try {
    res = await fetch(`${API_URL}/${path}`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        ...(token ? { Authorization: `Bearer ${token}` } : {}),
      },
      body: JSON.stringify(body ?? {}),
    });
  } catch {
    throw new ApiError('Cannot reach the game server. Check your connection.', 0);
  }
  const text = await res.text();
  let data: any = null;
  try {
    data = text ? JSON.parse(text) : null;
  } catch {
    /* non-JSON error body */
  }
  if (!res.ok) {
    // Serverpod serializable exceptions arrive as {className, data:{...}}: our own carry a
    // message, the auth module's carry a reason code.
    const message =
      data?.data?.message ?? authReason(data?.data?.reason) ?? data?.message ?? `Request failed (${res.status})`;
    throw new ApiError(message, res.status);
  }
  return data as T;
}

let refreshing: Promise<boolean> | null = null;

/** Trades the refresh token for a new access token. False means signed out. */
function refresh(): Promise<boolean> {
  refreshing ??= (async () => {
    const rt = auth?.refreshToken;
    if (!rt) return false;
    try {
      storeAuthSuccess(await post<AuthSuccess>('jwtRefresh/refreshAccessToken', { refreshToken: rt }));
      return true;
    } catch (e) {
      // Only a rejected token ends the session; a network blip keeps it.
      if (e instanceof ApiError && e.status >= 400 && e.status < 500) setAuth(null);
      return false;
    } finally {
      refreshing = null;
    }
  })();
  return refreshing;
}

/** Call an endpoint without credentials (sign-in and registration). */
export const callPublic = <T>(path: string, body?: unknown) => post<T>(path, body);

/** Call an endpoint as the signed-in user, refreshing the access token when needed. */
export async function call<T>(path: string, body?: unknown): Promise<T> {
  if (auth && auth.expiresAt - Date.now() < 30_000) await refresh();
  if (!auth) throw new ApiError('Sign in to continue.', 401);
  try {
    return await post<T>(path, body, auth.token);
  } catch (e) {
    if (e instanceof ApiError && e.status === 401 && (await refresh()) && auth) {
      return post<T>(path, body, auth.token);
    }
    throw e;
  }
}
