// The live connection between the two players of a friend match. It tries a
// direct WebRTC data channel first (the handshake is two small posts through
// Serverpod) and falls back to a WebSocket relay on Serverpod if the channel does
// not open in time. Either way the caller gets the same `Link`.

import { getAuth } from '@/client/api/http';
import { getSignal, postAnswer, postOffer, reportConnected } from '@/client/api/friend';
import type { InputMsg, Snapshot } from '@/client/game/snapshot';

export type Role = 'host' | 'guest';

export interface Link {
  transport: 'direct' | 'relay';
  /** Host → guest, about 30 per second. May be dropped. */
  sendSnapshot(s: Snapshot): void;
  /** Guest → host. Delivered in order. */
  sendInput(m: InputMsg): void;
  /** Tell the opponent we are leaving on purpose, so they are not left waiting. */
  sendBye(): void;
  /** The opponent said goodbye. */
  onBye: (() => void) | null;
  /** Quick chat: send the index of a phrase in EMOTES, and hear the opponent's. */
  sendEmote(code: number): void;
  onEmote: ((code: number) => void) | null;
  onSnapshot: ((s: Snapshot) => void) | null;
  onInput: ((m: InputMsg) => void) | null;
  /** The link died: the peer left, the network dropped, or it went silent. */
  onClose: ((reason: string) => void) | null;
  /** Milliseconds since anything arrived from the peer. */
  silentMs(): number;
  /** Smoothed round-trip time to the peer in ms, or null before the first reply. */
  rttMs(): number | null;
  close(): void;
}

const STUN = [{ urls: ['stun:stun.l.google.com:19302', 'stun:stun1.l.google.com:19302'] }];
const DIRECT_TIMEOUT_MS = 12_000;
const GATHER_TIMEOUT_MS = 2_500;
const POLL_MS = 250;
const HEARTBEAT_MS = 1_000;
const SILENT_LIMIT_MS = 8_000;

/** The relay is a route on Serverpod's web server, the same host that serves this page in production. */
const RELAY_URL: string =
  import.meta.env.VITE_RELAY_URL ??
  (import.meta.env.DEV ? 'ws://localhost:8082' : location.origin.replace(/^http/, 'ws'));

const sleep = (ms: number) => new Promise<void>((r) => setTimeout(r, ms));

/** Shared plumbing for both transports: JSON framing, heartbeat, silence detection. */
class BaseLink implements Link {
  onSnapshot: Link['onSnapshot'] = null;
  onBye: Link['onBye'] = null;
  onEmote: Link['onEmote'] = null;
  onInput: Link['onInput'] = null;
  onClose: Link['onClose'] = null;
  private lastRecv = performance.now();
  private timer = 0;
  private closed = false;
  private rtt: number | null = null;

  constructor(
    public transport: Link['transport'],
    private sendSnap: (text: string) => void,
    private sendCtl: (text: string) => void,
    private closeImpl: () => void,
  ) {
    this.timer = window.setInterval(() => {
      this.sendCtl(`{"k":"p","t":${performance.now()}}`); // heartbeat and ping in one
      if (this.silentMs() > SILENT_LIMIT_MS) this.fail('timeout');
    }, HEARTBEAT_MS);
  }

  sendSnapshot(s: Snapshot) {
    this.sendSnap(JSON.stringify({ k: 's', d: s }));
  }
  sendInput(m: InputMsg) {
    this.sendCtl(JSON.stringify({ k: 'i', d: m }));
  }
  sendEmote(code: number) {
    this.sendCtl(`{"k":"e","c":${Math.trunc(code)}}`);
  }
  sendBye() {
    // Reliable channel, twice: the other side may be mid-snapshot.
    this.sendCtl('{"k":"b"}');
    this.sendCtl('{"k":"b"}');
  }
  silentMs() {
    return performance.now() - this.lastRecv;
  }
  rttMs() {
    return this.rtt;
  }

  /** Feed every received text frame here. */
  receive(text: string) {
    this.lastRecv = performance.now();
    let m: { k: string; d?: unknown; t?: number; c?: number };
    try {
      m = JSON.parse(text);
    } catch {
      return;
    }
    if (m.k === 's') this.onSnapshot?.(m.d as Snapshot);
    else if (m.k === 'i') this.onInput?.(m.d as InputMsg);
    else if (m.k === 'b') this.onBye?.();
    else if (m.k === 'e' && Number.isInteger(m.c)) this.onEmote?.(m.c as number);
    else if (m.k === 'p') this.sendCtl(`{"k":"o","t":${Number(m.t) || 0}}`);
    else if (m.k === 'o') {
      const sample = performance.now() - (m.t ?? 0);
      if (sample >= 0 && sample < 2000) this.rtt = this.rtt == null ? sample : this.rtt * 0.8 + sample * 0.2;
    }
  }

  fail(reason: string) {
    if (this.closed) return;
    this.closed = true;
    window.clearInterval(this.timer);
    this.closeImpl();
    this.onClose?.(reason);
  }

  close() {
    if (this.closed) return;
    this.closed = true;
    window.clearInterval(this.timer);
    this.closeImpl();
  }
}

// ---- direct WebRTC --------------------------------------------------------

function gathered(pc: RTCPeerConnection): Promise<void> {
  return new Promise((resolve) => {
    if (pc.iceGatheringState === 'complete') return resolve();
    const done = () => {
      pc.removeEventListener('icegatheringstatechange', check);
      resolve();
    };
    const check = () => pc.iceGatheringState === 'complete' && done();
    pc.addEventListener('icegatheringstatechange', check);
    // Whatever candidates exist after a short wait are enough to try.
    setTimeout(done, GATHER_TIMEOUT_MS);
  });
}

async function pollSignal(matchId: string, want: 'offer' | 'answer', signal: AbortSignal): Promise<string> {
  while (!signal.aborted) {
    const s = await getSignal(matchId);
    if (s.status !== 'live') throw new Error('The match is over.');
    const v = want === 'offer' ? s.offer : s.answer;
    if (v) return v;
    await sleep(POLL_MS);
  }
  throw new Error('aborted');
}

async function connectDirect(matchId: string, role: Role, signal: AbortSignal): Promise<Link> {
  const pc = new RTCPeerConnection({ iceServers: STUN });
  let snapCh: RTCDataChannel | null = null;
  let ctlCh: RTCDataChannel | null = null;
  const opened = new Promise<void>((resolve, reject) => {
    const check = () => {
      if (snapCh?.readyState === 'open' && ctlCh?.readyState === 'open') resolve();
    };
    const wire = (ch: RTCDataChannel) => {
      if (ch.label === 'snap') snapCh = ch;
      else if (ch.label === 'ctl') ctlCh = ch;
      ch.addEventListener('open', check);
      check();
    };
    if (role === 'host') {
      wire(pc.createDataChannel('ctl', { ordered: true }));
      wire(pc.createDataChannel('snap', { ordered: false, maxRetransmits: 0 }));
    } else {
      pc.addEventListener('datachannel', (e) => wire(e.channel));
    }
    pc.addEventListener('connectionstatechange', () => {
      if (pc.connectionState === 'failed') reject(new Error('ice failed'));
    });
  });
  opened.catch(() => {});

  try {
    if (role === 'host') {
      await pc.setLocalDescription(await pc.createOffer());
      await gathered(pc);
      await postOffer(matchId, JSON.stringify(pc.localDescription));
      const answer = await pollSignal(matchId, 'answer', signal);
      await pc.setRemoteDescription(JSON.parse(answer));
    } else {
      const offer = await pollSignal(matchId, 'offer', signal);
      await pc.setRemoteDescription(JSON.parse(offer));
      await pc.setLocalDescription(await pc.createAnswer());
      await gathered(pc);
      await postAnswer(matchId, JSON.stringify(pc.localDescription));
    }
    await opened;
  } catch (e) {
    pc.close();
    throw e;
  }

  const link: BaseLink = new BaseLink(
    'direct',
    (t) => snapCh!.readyState === 'open' && snapCh!.send(t),
    (t) => ctlCh!.readyState === 'open' && ctlCh!.send(t),
    () => pc.close(),
  );
  for (const ch of [snapCh!, ctlCh!]) {
    ch.addEventListener('message', (e) => link.receive(String(e.data)));
    ch.addEventListener('close', () => link.fail('channel closed'));
  }
  pc.addEventListener('connectionstatechange', () => {
    if (pc.connectionState === 'failed' || pc.connectionState === 'closed') link.fail('connection lost');
  });
  return link;
}

// ---- relay ----------------------------------------------------------------

function connectRelay(matchId: string, signal: AbortSignal): Promise<Link> {
  return new Promise((resolve, reject) => {
    const token = getAuth()?.token;
    if (!token) return reject(new Error('Sign in to continue.'));
    const ws = new WebSocket(`${RELAY_URL}/relay/${matchId}`);
    let link: BaseLink | null = null;
    const abort = () => {
      ws.close();
      reject(new Error('aborted'));
    };
    signal.addEventListener('abort', abort, { once: true });

    ws.addEventListener('open', () => ws.send(JSON.stringify({ token })));
    ws.addEventListener('error', () => !link && reject(new Error('Could not reach the relay.')));
    ws.addEventListener('close', () => {
      if (link) link.fail('relay closed');
      else reject(new Error('The relay refused the connection.'));
    });
    ws.addEventListener('message', (e) => {
      const text = String(e.data);
      const m = safeParse(text);
      // Frames from the relay itself carry a "relay" field; everything else is the peer's.
      if (m && typeof m.relay === 'string') {
        if (m.relay === 'ok') {
          link = new BaseLink(
            'relay',
            (t) => ws.readyState === WebSocket.OPEN && ws.send(t),
            (t) => ws.readyState === WebSocket.OPEN && ws.send(t),
            () => ws.close(),
          );
          if (m.peer) resolve(link);
        } else if (m.relay === 'peer') {
          if (link) resolve(link);
        } else if (m.relay === 'peer-left') {
          link?.fail('opponent left');
        }
        return;
      }
      link?.receive(text);
    });
  });
}

const safeParse = (t: string): any => {
  try {
    return JSON.parse(t);
  } catch {
    return null;
  }
};

// ---- entry point ----------------------------------------------------------

/**
 * Connects the two players. Tries WebRTC for up to 12 s, then the relay.
 * Reports which transport won to Serverpod so the stored match records it.
 */
export async function connectMatch(
  matchId: string,
  role: Role,
  signal: AbortSignal,
  onStatus: (s: string) => void = () => {},
): Promise<Link> {
  onStatus('Connecting to your opponent…');
  // Dev/test switch: skip WebRTC and use the relay.
  const forceRelay = import.meta.env.DEV && localStorage.getItem('wc2026.forceRelay') === '1';
  const directAbort = new AbortController();
  const timer = setTimeout(() => directAbort.abort(), DIRECT_TIMEOUT_MS);
  signal.addEventListener('abort', () => directAbort.abort(), { once: true });
  let link: Link;
  try {
    if (forceRelay) throw new Error('relay forced');
    link = await Promise.race([
      connectDirect(matchId, role, directAbort.signal),
      new Promise<never>((_, rej) =>
        directAbort.signal.addEventListener('abort', () => rej(new Error('direct timed out')), { once: true }),
      ),
    ]);
  } catch (e) {
    if (signal.aborted) throw e;
    onStatus('Direct connection failed. Switching to the relay…');
    link = await connectRelay(matchId, signal);
  } finally {
    clearTimeout(timer);
  }
  void reportConnected(matchId, link.transport).catch(() => {});
  return link;
}
