import { useState } from 'react';
import { Navigate, useNavigate } from 'react-router-dom';
import { toast } from 'react-hot-toast';
import { applyProfile, useSession, type UserProfile } from '@/client/api/session';
import { call } from '@/client/api/http';
import { CREST_ICONS, CREST_SHAPES, DEFAULT_CLUB, clubKit, parseClub, type Club } from '@/client/game/club';
import { KitJersey } from '@/client/components/game/TeamCrest';
import { Btn } from '@/client/ui/controls';
import { Crest } from '@/client/ui/Crest';
import { useHints } from '@/client/ui/hints';

const SWATCHES = ['#e63946', '#ff7a1a', '#f5c518', '#2ecc71', '#14b8a6', '#2a9df4', '#1d4ed8', '#a259ff', '#ff3d8b', '#f4f3ff', '#6b7280', '#0b0933'];

function ColorField({ label, value, onChange }: { label: string; value: string; onChange: (v: string) => void }) {
  return (
    <div className="mb-3">
      <div className="t-label mb-1">{label}</div>
      <div className="flex flex-wrap items-center gap-1.5">
        {SWATCHES.map((c) => (
          <button
            key={c}
            aria-label={`${label} ${c}`}
            aria-pressed={value.toLowerCase() === c}
            onClick={() => onChange(c)}
            className={`h-8 w-8 rounded-full ring-2 transition-transform hover:scale-110 focus-visible:scale-110 ${value.toLowerCase() === c ? 'ring-white' : 'ring-white/20'}`}
            style={{ background: c }}
          />
        ))}
        <input type="color" value={value} onChange={(e) => onChange(e.target.value)} aria-label={`${label}: custom colour`} className="h-8 w-10 cursor-pointer rounded border border-white/30 bg-transparent p-0" />
      </div>
    </div>
  );
}

const chip = (on: boolean) => `rounded px-3 py-1.5 font-display text-sm font-bold uppercase tracking-wider ${on ? 'bg-neon-400 text-ink-950' : 'bg-white/10 text-mist-200 hover:bg-white/20'}`;

/** Design your club: a crest and a kit, saved to your account and worn in your solo matches and friendlies. */
export default function ClubScreen() {
  const session = useSession();
  const navigate = useNavigate();
  const [club, setClub] = useState<Club | null>(null);
  const [saving, setSaving] = useState(false);
  useHints([{ kb: 'Esc', pad: 'B', label: 'Back' }]);
  if (session.status === 'loading') return null;
  if (session.status !== 'in') return <Navigate to="/login?_redirect=%2Fclub" replace />;
  const saved = parseClub(session.profile.club);
  const c = club ?? saved ?? DEFAULT_CLUB;
  const set = (patch: Partial<Club>) => setClub({ ...c, ...patch });
  const dirty = club !== null;

  const save = async () => {
    setSaving(true);
    try {
      applyProfile(await call<UserProfile>('profile/saveClub', { json: JSON.stringify(c) }));
      setClub(null);
      toast.success('Club saved');
    } catch (e) {
      toast.error((e as Error).message);
    } finally {
      setSaving(false);
    }
  };

  const preview = clubKit(c);

  return (
    <div className="mx-auto max-w-5xl px-4 py-5 md:py-8">
      <div className="mb-4">
        <div className="t-label">Make it yours</div>
        <h1 className="t-display text-4xl text-white md:text-6xl">Your club</h1>
      </div>

      <div className="grid gap-5 md:grid-cols-[320px_1fr]">
        <section className="glass-solid flex flex-col items-center gap-3 p-5 animate-screen-in" aria-label="Preview">
          <Crest crest={c.crest} size={140} />
          <div className="t-display max-w-full truncate text-3xl text-white">{c.name}</div>
          <KitJersey kit={preview} />
        </section>

        <section className="glass p-5 animate-screen-in" aria-label="Edit club">
          <label className="mb-4 block">
            <span className="t-label mb-1 block">Club name</span>
            <input className="field" maxLength={20} value={c.name} onChange={(e) => set({ name: e.target.value })} />
          </label>

          <div className="mb-4">
            <div className="t-label mb-1">Crest shape</div>
            <div role="radiogroup" aria-label="Crest shape" className="flex flex-wrap gap-1.5">
              {CREST_SHAPES.map((s) => <button key={s} role="radio" aria-checked={c.crest.shape === s} className={chip(c.crest.shape === s)} onClick={() => set({ crest: { ...c.crest, shape: s } })}>{s}</button>)}
            </div>
          </div>
          <div className="mb-4">
            <div className="t-label mb-1">Crest emblem</div>
            <div role="radiogroup" aria-label="Crest emblem" className="flex flex-wrap gap-1.5">
              {CREST_ICONS.map((i) => <button key={i} role="radio" aria-checked={c.crest.icon === i} className={chip(c.crest.icon === i)} onClick={() => set({ crest: { ...c.crest, icon: i } })}>{i}</button>)}
            </div>
          </div>
          <div className="grid gap-x-6 sm:grid-cols-2">
            <ColorField label="Crest colour" value={c.crest.c1} onChange={(v) => set({ crest: { ...c.crest, c1: v } })} />
            <ColorField label="Crest trim" value={c.crest.c2} onChange={(v) => set({ crest: { ...c.crest, c2: v } })} />
            <ColorField label="Shirt" value={c.kit.shirt} onChange={(v) => set({ kit: { ...c.kit, shirt: v } })} />
            <ColorField label="Sleeves" value={c.kit.sleeve} onChange={(v) => set({ kit: { ...c.kit, sleeve: v } })} />
            <ColorField label="Shorts" value={c.kit.shorts} onChange={(v) => set({ kit: { ...c.kit, shorts: v } })} />
          </div>

          <label className="mb-5 flex items-start gap-3 font-body text-sm text-mist-200">
            <input type="checkbox" className="mt-1 h-5 w-5 accent-cyan-400" checked={c.useKit} onChange={(e) => set({ useKit: e.target.checked })} />
            <span>Wear this kit in my solo matches and friendlies. (Online matches use your nation&apos;s kit.)</span>
          </label>

          <div className="flex flex-wrap gap-3">
            <Btn variant="primary" size="lg" disabled={saving || !dirty} onClick={save}>{saving ? 'Saving…' : 'Save club'}</Btn>
            <Btn size="lg" disabled={!dirty} onClick={() => setClub(null)}>Undo changes</Btn>
            <Btn size="lg" data-back onClick={() => navigate('/profile')}>Back to profile</Btn>
          </div>
        </section>
      </div>
    </div>
  );
}
