import { createContext, useContext, useEffect, useMemo, useRef, useState, type ReactNode } from 'react';
import { useQuery, useQueryClient } from '@tanstack/react-query';
import { useNavigate } from 'react-router-dom';
import { Bell } from 'lucide-react';
import { toast } from 'react-hot-toast';
import { useSession } from '@/client/api/session';
import { acceptFriend, getFriends, removeFriend, type FriendsView, type Invite, type Person } from '@/client/api/social';
import { Avatar } from './controls';
import { sfx } from './sfx';

interface Value {
  friends: FriendsView | undefined;
  invites: Invite[];
  requests: Person[];
  count: number;
}
const Ctx = createContext<Value>({ friends: undefined, invites: [], requests: [], count: 0 });
export const useNotifications = () => useContext(Ctx);

/** Friends, requests and invites for the whole app: one poll, toasts as things arrive. */
export function NotificationsProvider({ children }: { children: ReactNode }) {
  const session = useSession();
  const navigate = useNavigate();
  const signedIn = session.status === 'in';
  const { data } = useQuery({
    queryKey: ['friends'],
    queryFn: getFriends,
    enabled: signedIn,
    refetchInterval: () => (document.hidden ? 30_000 : 6_000),
    refetchOnWindowFocus: true,
  });

  // Toast what is new since the last poll. Invites are live and short-lived, so one waiting on first
  // load still gets its toast; friend requests from before the page opened stay in the bell.
  const seen = useRef<{ invites: Set<string>; requests: Set<string> } | null>(null);
  useEffect(() => {
    if (!data) return;
    const inviteIds = new Set(data.invites.map((i) => i.lobbyId));
    const requestIds = new Set(data.incoming.map((p) => p.userId));
    {
      for (const i of data.invites) {
        if (!seen.current?.invites.has(i.lobbyId)) {
          sfx.notify();
          toast.custom(
            (t) => (
              <div className={`glass-solid flex items-center gap-4 px-4 py-3 shadow-xl shadow-black/50 ${t.visible ? 'animate-slide-up' : 'opacity-0'}`} role="status">
                <Avatar name={i.fromName} size={40} />
                <div>
                  <div className="t-label">Invite</div>
                  <div className="font-display text-lg font-bold uppercase text-white">{i.fromName} wants to play</div>
                </div>
                <button
                  className="btn btn-primary btn-sm"
                  onClick={() => {
                    toast.dismiss(t.id);
                    navigate(`/online?join=${i.code}`);
                  }}
                >
                  <span>Join</span>
                </button>
              </div>
            ),
            { duration: 20_000, id: `invite-${i.lobbyId}` },
          );
        }
      }
      for (const p of data.incoming) {
        if (seen.current && !seen.current.requests.has(p.userId)) {
          sfx.notify();
          toast(`${p.name} sent you a friend request`, { icon: '👋' });
        }
      }
    }
    seen.current = { invites: inviteIds, requests: requestIds };
  }, [data, navigate]);

  const value = useMemo<Value>(
    () => ({
      friends: data,
      invites: data?.invites ?? [],
      requests: data?.incoming ?? [],
      count: (data?.invites.length ?? 0) + (data?.incoming.length ?? 0),
    }),
    [data],
  );
  return <Ctx.Provider value={value}>{children}</Ctx.Provider>;
}

/** The bell in the header: a count, and a panel with invites and friend requests. */
export function NotificationBell() {
  const { invites, requests, count } = useNotifications();
  const [open, setOpen] = useState(false);
  const navigate = useNavigate();
  const qc = useQueryClient();
  const ref = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (!open) return;
    const away = (e: MouseEvent) => !ref.current?.contains(e.target as Node) && setOpen(false);
    document.addEventListener('mousedown', away);
    return () => document.removeEventListener('mousedown', away);
  }, [open]);

  const refresh = (v: FriendsView) => qc.setQueryData(['friends'], v);

  return (
    <div ref={ref} className="relative">
      <button
        className="relative flex h-10 w-10 items-center justify-center rounded-full bg-white/10 text-mist-200 ring-1 ring-white/20 hover:bg-white/20 focus-visible:ring-2 focus-visible:ring-white"
        aria-label={`Notifications${count ? `, ${count} new` : ''}`}
        aria-expanded={open}
        onClick={() => setOpen((o) => !o)}
      >
        <Bell size={18} />
        {count > 0 && (
          <span className="absolute -right-1 -top-1 flex h-5 min-w-5 items-center justify-center rounded-full bg-hot-500 px-1 text-[11px] font-bold text-white ring-2 ring-ink-900">{count}</span>
        )}
      </button>
      {open && (
        <div className="glass-solid absolute right-0 top-12 z-50 w-80 max-w-[90vw] p-3 shadow-2xl shadow-black/60 animate-fade-in" role="menu">
          {count === 0 && <p className="px-2 py-4 text-center font-body text-sm text-mist-400">Nothing new.</p>}
          {invites.map((i) => (
            <div key={i.lobbyId} className="flex items-center gap-3 rounded p-2 hover:bg-white/5">
              <Avatar name={i.fromName} />
              <span className="flex-1 font-body text-sm text-white"><b>{i.fromName}</b> invited you to a match</span>
              <button className="btn btn-primary btn-sm" onClick={() => { setOpen(false); navigate(`/online?join=${i.code}`); }}><span>Join</span></button>
            </div>
          ))}
          {requests.map((p) => (
            <div key={p.userId} className="flex items-center gap-3 rounded p-2 hover:bg-white/5">
              <Avatar name={p.name} />
              <span className="flex-1 font-body text-sm text-white"><b>{p.name}</b> wants to be friends</span>
              <button className="btn btn-primary btn-sm" onClick={async () => refresh(await acceptFriend(p.userId))}><span>Accept</span></button>
              <button className="btn btn-sm" onClick={async () => refresh(await removeFriend(p.userId))}><span>No</span></button>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
