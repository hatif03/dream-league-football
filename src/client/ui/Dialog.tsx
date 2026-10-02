import { createContext, useCallback, useContext, useEffect, useMemo, useRef, useState, type ReactNode } from 'react';
import { createPortal } from 'react-dom';
import { Btn } from './controls';

interface Choice {
  id: string;
  label: string;
  tone?: 'primary' | 'danger' | 'ghost';
}

interface Request {
  title: string;
  body?: ReactNode;
  confirmLabel?: string;
  cancelLabel?: string | null;
  tone?: 'primary' | 'danger';
  input?: { label: string; placeholder?: string; maxLength?: number; required?: boolean };
  choices?: Choice[];
  resolve: (value: string | boolean | null) => void;
}

interface Api {
  confirm(o: { title: string; body?: ReactNode; confirmLabel?: string; cancelLabel?: string; tone?: 'primary' | 'danger' }): Promise<boolean>;
  alert(o: { title: string; body?: ReactNode; okLabel?: string }): Promise<void>;
  prompt(o: { title: string; body?: ReactNode; label: string; placeholder?: string; confirmLabel?: string; maxLength?: number }): Promise<string | null>;
  choose(o: { title: string; body?: ReactNode; choices: Choice[]; cancelLabel?: string | null }): Promise<string | null>;
}

const Ctx = createContext<Api | null>(null);

/** Styled replacements for window.confirm / alert / prompt, usable from any component. */
export function useDialog(): Api {
  const api = useContext(Ctx);
  if (!api) throw new Error('DialogProvider missing');
  return api;
}

export function DialogProvider({ children }: { children: ReactNode }) {
  const [stack, setStack] = useState<Request[]>([]);

  const push = useCallback(
    <T,>(r: Omit<Request, 'resolve'>) =>
      new Promise<T>((resolve) => setStack((s) => [...s, { ...r, resolve: resolve as Request['resolve'] }])),
    [],
  );

  const api = useMemo<Api>(
    () => ({
      confirm: (o) => push<boolean>({ ...o, cancelLabel: o.cancelLabel ?? 'Cancel' }),
      alert: async (o) => {
        await push<boolean>({ title: o.title, body: o.body, confirmLabel: o.okLabel ?? 'OK', cancelLabel: null });
      },
      prompt: (o) => push<string | null>({ title: o.title, body: o.body, confirmLabel: o.confirmLabel ?? 'OK', cancelLabel: 'Cancel', input: { label: o.label, placeholder: o.placeholder, maxLength: o.maxLength } }),
      choose: (o) => push<string | null>({ title: o.title, body: o.body, choices: o.choices, cancelLabel: o.cancelLabel === undefined ? 'Cancel' : o.cancelLabel }),
    }),
    [push],
  );

  const top = stack[stack.length - 1];
  const close = (value: string | boolean | null) => {
    top?.resolve(value);
    setStack((s) => s.slice(0, -1));
  };

  return (
    <Ctx.Provider value={api}>
      {children}
      {top && createPortal(<DialogView key={stack.length} req={top} onClose={close} />, document.body)}
    </Ctx.Provider>
  );
}

function DialogView({ req, onClose }: { req: Request; onClose: (v: string | boolean | null) => void }) {
  const [text, setText] = useState('');
  const first = useRef<HTMLButtonElement>(null);
  const cancelValue = req.input || req.choices ? null : false;

  useEffect(() => {
    // Take focus off the page behind so keys act on the dialog.
    if (!req.input) first.current?.focus();
  }, [req.input]);

  return (
    <div className="fixed inset-0 z-[100] flex items-center justify-center bg-ink-950/75 p-4 backdrop-blur-sm animate-fade-in" onClick={() => req.cancelLabel !== null && onClose(cancelValue)}>
      <div
        role="dialog"
        aria-modal="true"
        aria-label={req.title}
        data-nav-scope
        className="glass-solid w-full max-w-md p-6 shadow-2xl shadow-black/60 animate-pop"
        onClick={(e) => e.stopPropagation()}
      >
        <h2 className="t-display text-3xl text-white">{req.title}</h2>
        {req.body && <div className="mt-3 font-body text-mist-200 leading-relaxed">{req.body}</div>}
        {req.input && (
          <form
            className="mt-4"
            onSubmit={(e) => {
              e.preventDefault();
              if (text.trim()) onClose(text.trim());
            }}
          >
            <label className="t-label mb-1 block" htmlFor="dialog-input">
              {req.input.label}
            </label>
            <input id="dialog-input" data-autofocus autoFocus className="field" value={text} maxLength={req.input.maxLength ?? 500} placeholder={req.input.placeholder} onChange={(e) => setText(e.target.value)} />
          </form>
        )}
        <div className="mt-6 flex flex-wrap justify-end gap-3">
          {req.cancelLabel !== null && (
            <Btn data-back variant="ghost" onClick={() => onClose(cancelValue)}>
              {req.cancelLabel ?? 'Cancel'}
            </Btn>
          )}
          {req.choices ? (
            req.choices.map((c, i) => (
              <Btn key={c.id} ref={i === 0 ? first : undefined} variant={c.tone ?? 'primary'} onClick={() => onClose(c.id)}>
                {c.label}
              </Btn>
            ))
          ) : (
            <Btn
              ref={first}
              variant={req.tone === 'danger' ? 'danger' : 'primary'}
              disabled={!!req.input && !text.trim()}
              onClick={() => onClose(req.input ? text.trim() : true)}
            >
              {req.confirmLabel ?? 'OK'}
            </Btn>
          )}
        </div>
      </div>
    </div>
  );
}
