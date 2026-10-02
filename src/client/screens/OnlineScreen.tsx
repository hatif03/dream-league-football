import { useCallback, useEffect, useRef, useState } from 'react';
import { useLocation, useSearchParams } from 'react-router-dom';
import { toast } from 'react-hot-toast';
import QRCode from 'qrcode';
import { Check, Copy, Share2 } from 'lucide-react';
import { teamById } from '@/client/game/teams';
import { KitJersey } from '@/client/components/game/TeamCrest';
import { Avatar, Badge, Btn, Spinner, Tile } from '@/client/ui/controls';
import { Flag } from '@/client/ui/Flag';
import { VersusArt } from '@/client/ui/art';
import { useDialog } from '@/client/ui/Dialog';
import { useHints } from '@/client/ui/hints';
import { sfx } from '@/client/ui/sfx';
import { useSession } from '@/client/api/session';
import { useHistory } from '@/client/api/queries';
import { createLobby, getLobby, joinLobby, leaveLobby, leaveLobbyOnUnload, setNation, setReady, type LobbyView } from '@/client/api/friend';
import { getLiveStatus, inviteFriend, type LiveStatus } from '@/client/api/social';
import { FriendsList, NationModal, RoomChat } from './online/parts';
import { useMatch } from './matchContext';

const KEY = 'wc2026.room';
const remember = (id: string | null) => {
  try {
    if (id) sessionStorage.setItem(KEY, id);
    else sessionStorage.removeItem(KEY);
  } catch {
    /* storage unavailable */
  }
};

export default function OnlineScreen() {
  const session = useSession();
  const location = useLocation();
  const [params, setParams] = useSearchParams();
  const [view, setView] = useState<LobbyView | null>((location.state as { lobby?: LobbyView } | null)?.lobby ?? null);
  const [busy, setBusy] = useState(false);
  const [live, setLive] = useState<LiveStatus | null>(null);
  const tried = useRef(false);

  useEffect(() => {
    getLiveStatus().then(setLive).catch(() => {});
  }, []);

  // Resume the room after a reload, or join the code from a shared link.
  const joinCode = params.get('join');
  useEffect(() => {
    if (session.status !== 'in' || tried.current || view) return;
    tried.current = true;
    (async () => {
      try {
        if (joinCode) {
          setBusy(true);
          setParams({}, { replace: true });
          setView(await joinLobby(joinCode.toUpperCase().slice(0, 5)));
          return;
        }
        const id = sessionStorage.getItem(KEY);
        if (id) {
          const v = await getLobby(id);
          if (v.lobby.status === 'open') setView(v);
          else remember(null);
        }
      } catch (e) {
        if (joinCode) toast.error((e as Error).message);
        remember(null);
      } finally {
        setBusy(false);
      }
    })();
  }, [session.status, joinCode, view, setParams]);

  useEffect(() => remember(view?.lobby.id ?? null), [view?.lobby.id]);

  if (session.status === 'loading') return <div className="p-10"><Spinner /></div>;

  if (view) {
    return <Lobby initial={view} onLeft={() => { setView(null); remember(null); }} />;
  }
  return <Hub busy={busy} setBusy={setBusy} maintenance={live?.maintenance ? (live.message ?? 'New rooms are paused for maintenance.') : null} onRoom={setView} />;
}

// ---- hub ---------------------------------------------------------------------------

function Hub({ busy, setBusy, maintenance, onRoom }: { busy: boolean; setBusy: (b: boolean) => void; maintenance: string | null; onRoom: (v: LobbyView) => void }) {
  const [code, setCode] = useState('');
  const history = useHistory(5);
  useHints([{ kb: 'Enter', pad: 'A', label: 'Select' }]);

  const guard = async (fn: () => Promise<LobbyView>) => {
    setBusy(true);
    try {
      onRoom(await fn());
    } catch (e) {
      toast.error((e as Error).message);
      sfx.error();
    } finally {
      setBusy(false);
    }
  };

  const onCode = (v: string) => {
    const c = v.toUpperCase().replace(/[^A-Z0-9]/g, '').slice(0, 5);
    setCode(c);
    if (c.length === 5) void guard(() => joinLobby(c));
  };

  return (
    <div className="mx-auto max-w-6xl px-4 py-5 md:py-8">
      <div className="mb-4">
        <div className="t-label">Online</div>
        <h1 className="t-display text-4xl text-white md:text-6xl">Play a friend</h1>
      </div>
      {maintenance && <p role="status" className="mb-4 rounded bg-gold-500/20 px-4 py-2 font-body text-sm text-gold-400">{maintenance}</p>}

      <div className="grid gap-5 lg:grid-cols-[1.25fr_1fr]">
        <div className="space-y-5">
          <div className="grid gap-4 sm:grid-cols-2">
            <Tile accent="#28e4ff" disabled={busy || !!maintenance} onClick={() => guard(createLobby)} autoFocus data-autofocus="" className="min-h-[240px]">
              <div className="flex flex-1 items-center justify-center bg-[radial-gradient(circle_at_50%_40%,rgba(40,228,255,0.25),transparent_65%)] p-4"><VersusArt className="h-32 w-auto" /></div>
              <div className="bg-ink-950/45 p-4">
                <div className="t-display text-3xl text-white">Create a room</div>
                <div className="font-body text-sm text-mist-300">You get a code and a link. Send it to a friend.</div>
              </div>
            </Tile>
            <div className="tile flex-col cursor-default" style={{ ['--accent' as string]: '#ff3d8b' }}>
              <div className="flex flex-1 flex-col justify-center gap-3 p-5">
                <div className="t-display text-3xl text-white">Join with a code</div>
                <input
                  className="field text-center font-display text-4xl uppercase tracking-[0.45em]"
                  placeholder="•••••"
                  aria-label="Room code"
                  value={code}
                  autoCapitalize="characters"
                  autoComplete="off"
                  spellCheck={false}
                  maxLength={5}
                  disabled={busy}
                  onChange={(e) => onCode(e.target.value)}
                  onPaste={(e) => {
                    // A pasted link or code both work.
                    const t = e.clipboardData.getData('text');
                    const m = t.match(/join=([A-Za-z0-9]{5})/);
                    if (m) {
                      e.preventDefault();
                      onCode(m[1]);
                    }
                  }}
                />
                <p className="text-center font-body text-sm text-mist-300">It joins as soon as the fifth character is in.</p>
              </div>
            </div>
          </div>

          <section className="glass p-4" aria-label="Recent matches">
            <h2 className="t-display mb-2 text-2xl text-white">Recent matches</h2>
            {history.isLoading ? <div className="skeleton h-10" /> : !history.data?.length ? (
              <p className="font-body text-sm text-mist-400">Your friend matches will show up here.</p>
            ) : (
              <ul className="space-y-1.5">
                {history.data.map((m) => {
                  const mine = m.youAreHost ? m.match.hostGoals : m.match.guestGoals;
                  const theirs = m.youAreHost ? m.match.guestGoals : m.match.hostGoals;
                  const opp = m.youAreHost ? m.guestName : m.hostName;
                  const myId = m.youAreHost ? m.match.hostUserId : m.match.guestUserId;
                  const fin = m.match.status === 'finished';
                  return (
                    <li key={m.match.id} className="flex items-center gap-3 rounded bg-white/5 px-3 py-2">
                      <Flag nation={m.youAreHost ? m.match.hostNation : m.match.guestNation} className="h-5 w-7" />
                      <span className="t-display w-14 text-center text-lg tabular text-white">{fin ? `${mine}–${theirs}` : 'v'}</span>
                      <Flag nation={m.youAreHost ? m.match.guestNation : m.match.hostNation} className="h-5 w-7" />
                      <span className="flex-1 truncate font-body text-sm text-mist-200">{opp}</span>
                      <Badge tone={fin ? (!m.match.winnerUserId ? 'gold' : m.match.winnerUserId === myId ? 'win' : 'hot') : 'mute'}>
                        {fin ? (!m.match.winnerUserId ? 'Draw' : m.match.winnerUserId === myId ? 'Win' : 'Loss') : m.match.status === 'abandoned' ? 'Abandoned' : 'No result'}
                      </Badge>
                    </li>
                  );
                })}
              </ul>
            )}
          </section>
        </div>

        <FriendsList
          action={(p) => (
            <Btn size="sm" variant="primary" disabled={busy || !!maintenance || !p.online} title={p.online ? `Create a room and invite ${p.name}` : `${p.name} is offline`}
              onClick={() => guard(async () => {
                const v = await createLobby();
                await inviteFriend(p.userId, v.lobby.id).catch((e) => toast.error((e as Error).message));
                toast.success(`Invited ${p.name}`);
                return v;
              })}
            >
              Challenge
            </Btn>
          )}
        />
      </div>
    </div>
  );
}

// ---- lobby -------------------------------------------------------------------------

function Lobby({ initial, onLeft }: { initial: LobbyView; onLeft: () => void }) {
  const [view, setView] = useState(initial);
  const [pick, setPick] = useState(false);
  const [count, setCount] = useState<number | null>(null);
  const dialog = useDialog();
  const match = useMatch();
  const session = useSession();
  const prev = useRef(initial);
  const closing = useRef(false);
  const started = useRef(false);
  const { lobby, youAreHost } = view;
  const me = session.status === 'in' ? session.profile : null;
  const myNation = youAreHost ? lobby.hostNation : lobby.guestNation;
  const theirNation = youAreHost ? lobby.guestNation : lobby.hostNation;
  const myReady = youAreHost ? lobby.hostReady : lobby.guestReady;
  const theirReady = youAreHost ? lobby.guestReady : lobby.hostReady;
  const myName = youAreHost ? view.hostName : (view.guestName ?? me?.displayName ?? 'You');
  const theirName = youAreHost ? view.guestName : view.hostName;
  useHints([{ kb: 'Enter', pad: 'A', label: myReady ? 'Not ready' : 'Ready' }]);

  const apply = useCallback((v: LobbyView) => setView(v), []);

  // Poll the room; announce arrivals, departures and a closed room the moment they happen.
  useEffect(() => {
    if (started.current) return;
    const t = window.setInterval(async () => {
      try {
        const v = await getLobby(lobby.id);
        const p = prev.current;
        prev.current = v;
        const wasGuest = youAreHost ? p.guestName : p.hostName;
        const isGuest = youAreHost ? v.guestName : v.hostName;
        if (!wasGuest && isGuest) { sfx.notify(); toast.success(`${isGuest} joined the room`); }
        if (wasGuest && !isGuest) { sfx.notify(); toast(`${wasGuest} left the room`, { icon: '👋' }); }
        if (youAreHost ? v.lobby.guestNation !== p.lobby.guestNation && v.lobby.guestNation : v.lobby.hostNation !== p.lobby.hostNation && v.lobby.hostNation) {
          const n = teamById((youAreHost ? v.lobby.guestNation : v.lobby.hostNation) ?? '')?.name;
          if (n) toast(`${isGuest ?? 'Opponent'} picked ${n}`, { duration: 2500 });
        }
        setView(v);
        if (v.lobby.status === 'closed' && !closing.current) {
          closing.current = true;
          await dialog.alert({ title: 'Room closed', body: 'The host closed the room.', okLabel: 'Back to Online' });
          onLeft();
        }
      } catch {
        /* a missed poll is fine; the next catches up */
      }
    }, 1000);
    return () => window.clearInterval(t);
  }, [lobby.id, youAreHost, dialog, onLeft]);

  // Closing the tab while waiting frees the room (and tells the other player) straight away.
  useEffect(() => {
    const onHide = () => { if (!started.current && !closing.current) leaveLobbyOnUnload(lobby.id); };
    window.addEventListener('pagehide', onHide);
    return () => window.removeEventListener('pagehide', onHide);
  }, [lobby.id]);

  // Both ready: count in, then kick off.
  useEffect(() => {
    if (!view.lobby.matchId || started.current) return;
    started.current = true;
    sfx.whistle();
    let n = 3;
    setCount(n);
    const t = window.setInterval(() => {
      n -= 1;
      if (n <= 0) {
        window.clearInterval(t);
        match.start({ kind: 'friend', view, returnTo: '/online' });
      } else {
        sfx.tick();
        setCount(n);
      }
    }, 1000);
    return () => window.clearInterval(t);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [view.lobby.matchId]);

  // Start with the favourite nation so the common case is one tap on Ready.
  const autoPicked = useRef(false);
  useEffect(() => {
    const fav = me?.favouriteNation;
    if (autoPicked.current || myNation || !fav || fav === theirNation) return;
    autoPicked.current = true;
    setNation(lobby.id, fav).then(apply).catch(() => {});
  }, [me?.favouriteNation, myNation, theirNation, lobby.id, apply]);

  const leave = async () => {
    const others = youAreHost && view.guestName;
    if (others && !(await dialog.confirm({ title: 'Close the room?', body: `${view.guestName} will be sent back to the menu.`, confirmLabel: 'Close room', tone: 'danger' }))) return;
    closing.current = true;
    await leaveLobby(lobby.id).catch(() => {});
    onLeft();
  };

  const toggleReady = async () => {
    try {
      apply(await setReady(lobby.id, !myReady));
      sfx.select();
    } catch (e) {
      toast.error((e as Error).message);
    }
  };

  const link = `${location.origin}/online?join=${lobby.code}`;
  const blocker = !theirName ? 'Waiting for a friend to join' : !myNation ? 'Pick your nation' : !theirNation ? `Waiting for ${theirName} to pick a nation` : null;

  return (
    <div className="mx-auto max-w-6xl px-4 py-5 md:py-6">
      <div className="mb-4 flex flex-wrap items-end justify-between gap-3">
        <div>
          <div className="t-label">Friendly match · {youAreHost ? 'You are hosting' : `${view.hostName} is hosting`}</div>
          <h1 className="t-display text-4xl text-white md:text-5xl">Room {lobby.code}</h1>
        </div>
        <Btn data-back onClick={leave}>{youAreHost && view.guestName ? 'Close room' : 'Leave room'}</Btn>
      </div>

      <div className="grid items-stretch gap-3 md:grid-cols-[1fr_auto_1fr]">
        <SeatCard name={myName} you host={youAreHost} nation={myNation} away={!youAreHost} ready={myReady} onPick={() => setPick(true)} />
        <div className="t-display flex items-center justify-center text-5xl text-mist-500 md:text-7xl">VS</div>
        <SeatCard name={theirName ?? undefined} host={!youAreHost} nation={theirNation} away={youAreHost} ready={theirReady} />
      </div>

      <div className="mt-4 flex flex-col items-center gap-2">
        <Btn variant={myReady ? 'ghost' : 'primary'} size="lg" disabled={!!blocker || count !== null} onClick={toggleReady} autoFocus data-autofocus="">
          {myReady ? 'Ready ✓  (tap to cancel)' : "I'm ready"}
        </Btn>
        <p className="font-body text-sm text-mist-300" role="status">
          {blocker ?? (myReady ? `Waiting for ${theirName} to be ready…` : `${theirName} is ${theirReady ? 'ready' : 'picking'}. Press ready when you are.`)}
        </p>
      </div>

      {!theirName && <ShareBlock code={lobby.code} link={link} lobbyId={lobby.id} canInvite={youAreHost} />}

      <div className="mt-5 grid gap-4 md:grid-cols-2">
        <RoomChat lobbyId={lobby.id} />
        {theirName ? (
          <section className="glass p-4">
            <h2 className="t-display mb-2 text-2xl text-white">How it works</h2>
            <ul className="list-disc space-y-1 pl-5 font-body text-sm text-mist-200">
              <li>A match is 90 minutes in about three real minutes. A draw stays a draw.</li>
              <li>{youAreHost ? 'Your browser runs the match for both of you, so keep this tab open.' : `${view.hostName}'s browser runs the match; you play over a direct link.`}</li>
              <li>If someone leaves, the other player is told straight away and no win is given.</li>
            </ul>
          </section>
        ) : (
          <FriendsInvite lobbyId={lobby.id} />
        )}
      </div>

      {pick && (
        <NationModal
          current={myNation}
          taken={theirNation}
          onClose={() => setPick(false)}
          onPick={async (id) => {
            setPick(false);
            try {
              apply(await setNation(lobby.id, id));
            } catch (e) {
              toast.error((e as Error).message);
            }
          }}
        />
      )}

      {count !== null && (
        <div className="fixed inset-0 z-[95] flex flex-col items-center justify-center bg-ink-950/85 backdrop-blur-sm" role="status" aria-live="assertive">
          <div className="t-label mb-2">Kick off in</div>
          <div key={count} className="t-display text-[12rem] leading-none text-white" style={{ animation: 'count-pop 1s ease-out' }}>{count}</div>
          <div className="mt-4 flex items-center gap-4">
            <Flag nation={myNation ?? ''} className="h-10 w-14" /><span className="t-display text-3xl text-mist-300">v</span><Flag nation={theirNation ?? ''} className="h-10 w-14" />
          </div>
        </div>
      )}
    </div>
  );
}

function SeatCard({ name, you, host, nation, away, ready, onPick }: { name?: string; you?: boolean; host?: boolean; nation?: string | null; away: boolean; ready: boolean; onPick?: () => void }) {
  const team = teamById(nation ?? '');
  const empty = !name;
  return (
    <section className="glass relative overflow-hidden p-4 md:p-5" style={{ borderTop: `4px solid ${ready ? '#3df08a' : (team?.color ?? '#7a75b8')}` }} aria-label={you ? 'Your side' : 'Opponent'}>
      <div className="mb-3 flex items-center gap-3">
        {empty ? <span className="skeleton h-9 w-9 rounded-full" /> : <Avatar name={name} online size={40} />}
        <div className="min-w-0 flex-1">
          <div className="t-label">{you ? 'You' : 'Opponent'}{host ? ' · Host' : ''}</div>
          <div className="truncate font-display text-2xl font-bold uppercase text-white">{empty ? 'Waiting for a friend…' : name}</div>
        </div>
        {ready && <Badge tone="win"><Check size={12} className="mr-1" />Ready</Badge>}
      </div>
      <button
        className={`tile w-full flex-row items-center gap-4 p-4 ${onPick ? '' : 'cursor-default'}`}
        style={{ ['--accent' as string]: team?.color ?? '#7a75b8' }}
        disabled={!onPick && !team}
        onClick={onPick}
        aria-label={onPick ? (team ? `Change nation, now ${team.name}` : 'Pick your nation') : undefined}
        tabIndex={onPick ? 0 : -1}
      >
        {team ? (
          <>
            <Flag nation={nation!} className="h-16 w-24" />
            <div className="min-w-0 flex-1 text-left">
              <div className="t-display truncate text-3xl text-white">{team.name}</div>
              <div className="font-body text-sm text-mist-300">{onPick ? 'Tap to change' : 'Picked'}</div>
            </div>
            <KitJersey kit={away ? team.awayKit : team.kit} />
          </>
        ) : (
          <div className="flex w-full items-center justify-center py-3 font-display text-xl font-bold uppercase tracking-wider text-mist-300">{onPick ? 'Pick your nation' : 'Choosing a nation…'}</div>
        )}
      </button>
    </section>
  );
}

function ShareBlock({ code, link, lobbyId, canInvite }: { code: string; link: string; lobbyId: string; canInvite: boolean }) {
  const [copied, setCopied] = useState(false);
  const [qr, setQr] = useState<string | null>(null);
  const [showQr, setShowQr] = useState(false);
  void lobbyId;
  void canInvite;

  useEffect(() => {
    if (!showQr || qr) return;
    QRCode.toDataURL(link, { margin: 1, width: 240, color: { dark: '#0b0933', light: '#ffffff' } }).then(setQr).catch(() => {});
  }, [showQr, qr, link]);

  const copy = async () => {
    try {
      await navigator.clipboard.writeText(link);
      setCopied(true);
      toast.success('Invite link copied. Send it to your friend.');
      setTimeout(() => setCopied(false), 2500);
    } catch {
      toast.error('Could not copy. Select the code and share it by hand.');
    }
  };
  const canShare = typeof navigator !== 'undefined' && !!navigator.share;

  return (
    <section className="glass-solid mt-5 p-5 text-center" aria-label="Invite a friend" style={{ borderTop: '4px solid #28e4ff' }}>
      <div className="t-label">Share this code</div>
      <button onClick={copy} className="mx-auto mt-2 flex gap-2" aria-label={`Room code ${code.split('').join(' ')}. Tap to copy the invite link.`}>
        {code.split('').map((c, i) => (
          <span key={i} className="t-display flex h-16 w-12 items-center justify-center rounded bg-white/10 text-5xl text-white ring-1 ring-white/25 md:h-20 md:w-16 md:text-6xl">{c}</span>
        ))}
      </button>
      <div className="mt-4 flex flex-wrap items-center justify-center gap-3">
        <Btn variant="primary" onClick={copy}>{copied ? <><Check size={18} /> Copied</> : <><Copy size={18} /> Copy invite link</>}</Btn>
        {canShare && <Btn onClick={() => navigator.share({ title: 'World Cup 2026', text: 'Play me at World Cup 2026!', url: link }).catch(() => {})}><Share2 size={18} /> Share…</Btn>}
        <Btn onClick={() => setShowQr((s) => !s)}>{showQr ? 'Hide QR' : 'Show QR code'}</Btn>
      </div>
      {showQr && <div className="mt-4 flex justify-center">{qr ? <img src={qr} alt={`QR code for ${link}`} className="h-48 w-48 rounded bg-white p-1" /> : <Spinner label="Making QR" />}</div>}
      <p className="mt-3 flex items-center justify-center gap-2 font-body text-sm text-mist-300">
        <span className="flex gap-1"><i className="h-2 w-2 animate-pulse rounded-full bg-neon-400" /><i className="h-2 w-2 animate-pulse rounded-full bg-neon-400 [animation-delay:200ms]" /><i className="h-2 w-2 animate-pulse rounded-full bg-neon-400 [animation-delay:400ms]" /></span>
        Waiting for your friend to join
      </p>
    </section>
  );
}

function FriendsInvite({ lobbyId }: { lobbyId: string }) {
  const [sent, setSent] = useState<Set<string>>(new Set());
  return (
    <FriendsList
      compact
      action={(p) => (
        <Btn
          size="sm"
          variant="primary"
          disabled={sent.has(p.userId)}
          onClick={async () => {
            try {
              await inviteFriend(p.userId, lobbyId);
              setSent((s) => new Set(s).add(p.userId));
              toast.success(`Invited ${p.name}`);
            } catch (e) {
              toast.error((e as Error).message);
            }
          }}
        >
          {sent.has(p.userId) ? 'Invited' : 'Invite'}
        </Btn>
      )}
    />
  );
}
