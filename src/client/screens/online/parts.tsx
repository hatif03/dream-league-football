import { useEffect, useMemo, useRef, useState } from 'react';
import { createPortal } from 'react-dom';
import { toast } from 'react-hot-toast';
import { useQueryClient } from '@tanstack/react-query';
import { Search } from 'lucide-react';
import { TEAMS, nationId } from '@/client/game/teams';
import { Avatar, Btn } from '@/client/ui/controls';
import { Flag } from '@/client/ui/Flag';
import { useDialog } from '@/client/ui/Dialog';
import { useNotifications } from '@/client/ui/Notifications';
import { blockPlayer, getChat, removeFriend, requestFriend, sendChat, type ChatLine, type FriendsView } from '@/client/api/social';

/** A modal grid of nations to choose from (the opponent's nation is greyed out). */
export function NationModal({ current, taken, onPick, onClose }: { current?: string | null; taken?: string | null; onPick: (id: string) => void; onClose: () => void }) {
  const [q, setQ] = useState('');
  const list = useMemo(() => TEAMS.filter((t) => t.name.toLowerCase().includes(q.trim().toLowerCase())), [q]);
  return createPortal(
    <div className="fixed inset-0 z-[90] flex items-center justify-center bg-ink-950/80 p-3 backdrop-blur-sm animate-fade-in" onClick={onClose}>
      <div role="dialog" aria-modal="true" aria-label="Choose a nation" data-nav-scope className="glass-solid flex max-h-[88vh] w-full max-w-3xl flex-col p-4 md:p-6 animate-pop" onClick={(e) => e.stopPropagation()}>
        <div className="mb-3 flex items-center gap-3">
          <h2 className="t-display text-3xl text-white">Choose your nation</h2>
          <div className="relative ml-auto w-48">
            <Search size={15} className="absolute left-3 top-1/2 -translate-y-1/2 text-mist-400" />
            <input className="field !min-h-10 !pl-9" placeholder="Search" aria-label="Search nations" autoFocus value={q} onChange={(e) => setQ(e.target.value)} />
          </div>
          <Btn data-back size="sm" onClick={onClose}>Close</Btn>
        </div>
        <div className="grid grid-cols-3 gap-2 overflow-y-auto p-1 sm:grid-cols-4 md:grid-cols-6">
          {list.map((t) => {
            const id = nationId(t);
            const disabled = id === taken;
            return (
              <button key={id} disabled={disabled} data-autofocus={id === current ? '' : undefined} onClick={() => onPick(id)} className={`tile flex-col items-center gap-1 px-2 pb-2 pt-3.5 ${id === current ? 'ring-2 ring-neon-400' : ''}`} style={{ ['--accent' as string]: t.color }} title={disabled ? 'Your opponent picked this nation' : t.name}>
                <Flag nation={id} className="h-9 w-14" />
                <span className="line-clamp-1 text-center font-display text-sm font-bold uppercase text-white">{t.name}</span>
              </button>
            );
          })}
        </div>
      </div>
    </div>,
    document.body,
  );
}

/** Friends with online dots; add by exact name; requests and blocks. `action` adds a button per friend. */
export function FriendsList({
  action,
  compact,
}: {
  action?: (p: { userId: string; name: string; online: boolean }) => React.ReactNode;
  compact?: boolean;
}) {
  const { friends } = useNotifications();
  const qc = useQueryClient();
  const dialog = useDialog();
  const [name, setName] = useState('');
  const [busy, setBusy] = useState(false);
  const set = (v: FriendsView) => qc.setQueryData(['friends'], v);

  const add = async (e: React.FormEvent) => {
    e.preventDefault();
    const n = name.trim();
    if (!n) return;
    setBusy(true);
    try {
      set(await requestFriend(n));
      setName('');
      toast.success(`Request sent to ${n}`);
    } catch (err) {
      toast.error((err as Error).message);
    } finally {
      setBusy(false);
    }
  };

  const list = [...(friends?.friends ?? [])].sort((a, b) => Number(b.online) - Number(a.online) || a.name.localeCompare(b.name));

  return (
    <section className="glass p-4" aria-label="Friends">
      <div className="mb-3 flex items-center justify-between">
        <h2 className="t-display text-2xl text-white">Friends</h2>
        <span className="font-body text-xs text-mist-400">{list.filter((f) => f.online).length} online</span>
      </div>

      <form onSubmit={add} className="mb-3 flex gap-2">
        <input className="field !min-h-10" placeholder="Add by exact name" aria-label="Friend's display name" value={name} onChange={(e) => setName(e.target.value)} maxLength={16} />
        <Btn type="submit" size="sm" variant="primary" disabled={busy || !name.trim()}>Add</Btn>
      </form>

      {friends?.incoming.map((p) => (
        <div key={p.userId} className="mb-2 flex items-center gap-3 rounded bg-hot-500/15 p-2">
          <Avatar name={p.name} />
          <span className="flex-1 font-body text-sm text-white"><b>{p.name}</b> wants to be friends</span>
          <Btn size="sm" variant="primary" onClick={async () => { const { acceptFriend } = await import('@/client/api/social'); set(await acceptFriend(p.userId)); }}>Accept</Btn>
          <Btn size="sm" onClick={async () => set(await removeFriend(p.userId))}>No</Btn>
        </div>
      ))}

      {!friends ? (
        <div className="space-y-2">{[0, 1, 2].map((i) => <div key={i} className="skeleton h-11" />)}</div>
      ) : list.length === 0 ? (
        <p className="py-4 text-center font-body text-sm text-mist-400">No friends yet. Add someone by their exact display name, or share a room code.</p>
      ) : (
        <ul className={`space-y-1.5 ${compact ? 'max-h-64 overflow-y-auto pr-1' : ''}`}>
          {list.map((p) => (
            <li key={p.userId} className="flex items-center gap-3 rounded bg-white/5 px-3 py-2">
              <Avatar name={p.name} online={p.online} />
              <div className="min-w-0 flex-1">
                <div className="truncate font-display text-lg font-bold uppercase leading-tight text-white">{p.name}</div>
                <div className={`font-body text-xs ${p.online ? 'text-win' : 'text-mist-500'}`}>{p.online ? 'Online' : 'Offline'}</div>
              </div>
              {action?.(p)}
              <button
                className="rounded px-2 py-1 font-body text-xs text-mist-400 hover:bg-white/10 hover:text-white"
                aria-label={`More for ${p.name}`}
                onClick={async () => {
                  const c = await dialog.choose({ title: p.name, choices: [{ id: 'remove', label: 'Remove friend', tone: 'ghost' }, { id: 'block', label: 'Block', tone: 'danger' }] });
                  if (c === 'remove') set(await removeFriend(p.userId));
                  if (c === 'block' && (await dialog.confirm({ title: `Block ${p.name}?`, body: 'You will not see their messages and neither of you can invite the other.', confirmLabel: 'Block', tone: 'danger' }))) set(await blockPlayer(p.userId));
                }}
              >
                ⋯
              </button>
            </li>
          ))}
        </ul>
      )}

      {!!friends?.outgoing.length && (
        <p className="mt-2 font-body text-xs text-mist-400">Waiting for: {friends.outgoing.map((p) => p.name).join(', ')}</p>
      )}
    </section>
  );
}

/** Room chat stored on the server, so a friend who arrives late sees what was said. */
export function RoomChat({ lobbyId }: { lobbyId: string }) {
  const [lines, setLines] = useState<ChatLine[]>([]);
  const [text, setText] = useState('');
  const box = useRef<HTMLDivElement>(null);

  useEffect(() => {
    let alive = true;
    const load = () => getChat(lobbyId).then((l) => alive && setLines(l)).catch(() => {});
    void load();
    const t = window.setInterval(load, 2000);
    return () => {
      alive = false;
      window.clearInterval(t);
    };
  }, [lobbyId]);
  useEffect(() => {
    box.current?.scrollTo({ top: box.current.scrollHeight });
  }, [lines.length]);

  return (
    <section className="glass flex flex-col p-4" aria-label="Room chat">
      <h2 className="t-display mb-2 text-2xl text-white">Chat</h2>
      <div ref={box} className="h-40 flex-1 space-y-1 overflow-y-auto rounded bg-ink-950/50 p-2.5 font-body text-sm" aria-live="polite">
        {lines.length === 0 && <p className="text-mist-500">Say hello while you wait.</p>}
        {lines.map((l) => (
          <p key={l.id} className="break-words"><b className="text-neon-400">{l.name}</b> <span className="text-mist-100">{l.text}</span></p>
        ))}
      </div>
      <form
        className="mt-2 flex gap-2"
        onSubmit={(e) => {
          e.preventDefault();
          const t = text.trim();
          if (!t) return;
          setText('');
          sendChat(lobbyId, t).then(() => getChat(lobbyId).then(setLines)).catch((err) => toast.error((err as Error).message));
        }}
      >
        <input className="field !min-h-10" placeholder="Type a message" aria-label="Chat message" maxLength={200} value={text} onChange={(e) => setText(e.target.value)} />
        <Btn type="submit" size="sm">Send</Btn>
      </form>
    </section>
  );
}
