import { useEffect, useRef, useSyncExternalStore } from 'react';
import { freshToken, getAuth, onAuthChange } from '@/client/api/http';

// The live channel: one WebSocket to the Serverpod web server (`/live`) that says "this changed"
// (friends, rooms, chat, duels, the matchmaking queue). The app then refetches only that thing, so
// screens poll rarely instead of every second. If the socket is down, screens keep their own slow polling.

export type LiveTopic = 'friends' | 'lobby' | 'chat' | 'match' | 'duel' | 'queue';
type Handler = (id?: string) => void;

const LIVE_URL: string =
  (import.meta.env.VITE_RELAY_URL ?? (import.meta.env.DEV ? 'ws://localhost:8082' : location.origin.replace(/^http/, 'ws'))) + '/live';

const handlers = new Map<LiveTopic, Set<Handler>>();
const watchers = new Set<() => void>();
let socket: WebSocket | null = null;
let connected = false;
let wanted = 0;
let retry = 0;
let timer: number | undefined;

const setConnected = (v: boolean) => {
  if (connected === v) return;
  connected = v;
  watchers.forEach((w) => w());
};

async function open() {
  if (socket || !wanted || !getAuth()) return;
  const token = await freshToken();
  if (!token || socket || !wanted) return;
  let ws: WebSocket;
  try {
    ws = new WebSocket(LIVE_URL);
  } catch {
    schedule();
    return;
  }
  socket = ws;
  ws.onopen = () => ws.send(JSON.stringify({ token }));
  ws.onmessage = (e) => {
    try {
      const m = JSON.parse(String(e.data)) as { live?: string; t?: LiveTopic; id?: string };
      if (m.live === 'ok') {
        retry = 0;
        setConnected(true);
        // Anything may have changed while we were away: every listener refetches once.
        handlers.forEach((set) => set.forEach((h) => h()));
      } else if (m.t) {
        handlers.get(m.t)?.forEach((h) => h(m.id));
      }
    } catch {
      /* ignore anything that is not ours */
    }
  };
  ws.onclose = () => {
    if (socket === ws) socket = null;
    setConnected(false);
    schedule();
  };
  ws.onerror = () => ws.close();
}

function schedule() {
  window.clearTimeout(timer);
  if (!wanted) return;
  retry = Math.min(retry + 1, 6);
  timer = window.setTimeout(() => void open(), Math.min(30_000, 1000 * 2 ** retry));
}

function close() {
  window.clearTimeout(timer);
  const s = socket;
  socket = null;
  setConnected(false);
  s?.close();
}

onAuthChange(() => {
  if (!getAuth()) close();
  else if (wanted) void open();
});

/** True while the live socket is open (screens poll less then). */
export function useLiveConnected(): boolean {
  return useSyncExternalStore(
    (cb) => {
      watchers.add(cb);
      return () => watchers.delete(cb);
    },
    () => connected,
    () => false,
  );
}

/**
 * Runs [handler] whenever one of [topics] changes (and once each time the socket connects, in case
 * something changed meanwhile). Holds the socket open while any screen listens.
 */
export function useLive(topics: LiveTopic[], handler: Handler) {
  const ref = useRef(handler);
  ref.current = handler;
  const key = topics.join(',');
  useEffect(() => {
    const h: Handler = (id) => ref.current(id);
    const list = key.split(',') as LiveTopic[];
    for (const t of list) {
      if (!handlers.has(t)) handlers.set(t, new Set());
      handlers.get(t)!.add(h);
    }
    wanted++;
    void open();
    return () => {
      for (const t of list) handlers.get(t)?.delete(h);
      wanted--;
      if (wanted <= 0) {
        wanted = 0;
        close();
      }
    };
  }, [key]);
}
