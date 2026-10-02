import { useCallback, useEffect, useRef, useState, type FormEvent, type ReactNode } from 'react';
import { Link, Navigate, useNavigate } from 'react-router-dom';
import { Eye, EyeOff } from 'lucide-react';
import { Btn } from '@/client/ui/controls';
import { Flag } from '@/client/ui/Flag';
import {
  createProfile,
  finishPasswordReset,
  finishRegistration,
  signIn,
  startPasswordReset,
  startRegistration,
  useSession,
} from '@/client/api/session';
import { call } from '@/client/api/http';
import { TEAMS, nationId } from '@/client/game/teams';
import { useHints } from '@/client/ui/hints';

const EMAIL_KEY = 'wc2026.lastEmail';
const rememberedEmail = () => {
  try {
    return localStorage.getItem(EMAIL_KEY) ?? '';
  } catch {
    return '';
  }
};

function AuthCard({ title, sub, step, children, footer }: { title: string; sub?: string; step?: [number, number]; children: ReactNode; footer?: ReactNode }) {
  return (
    <div className="mx-auto flex min-h-full w-full max-w-md flex-col justify-center px-4 py-8">
      <div className="glass-solid p-6 shadow-2xl shadow-black/50 animate-screen-in md:p-8">
        {step && (
          <ol className="mb-4 flex items-center gap-2" aria-label={`Step ${step[0]} of ${step[1]}`}>
            {Array.from({ length: step[1] }, (_, i) => (
              <li key={i} className={`h-1.5 flex-1 rounded-full ${i < step[0] ? 'bg-neon-400' : 'bg-white/15'}`} />
            ))}
          </ol>
        )}
        <h1 className="t-display text-4xl text-white">{title}</h1>
        {sub && <p className="mt-2 font-body text-mist-300">{sub}</p>}
        <div className="mt-6">{children}</div>
      </div>
      {footer && <div className="mt-4 text-center font-body text-sm text-mist-300">{footer}</div>}
    </div>
  );
}

function Field({ label, error, hint, children }: { label: string; error?: string | null; hint?: string; children: ReactNode }) {
  return (
    <label className="mb-4 block">
      <span className="t-label mb-1 block">{label}</span>
      {children}
      {error ? (
        <span role="alert" className="mt-1 block font-body text-sm text-loss">{error}</span>
      ) : hint ? (
        <span className="mt-1 block font-body text-xs text-mist-400">{hint}</span>
      ) : null}
    </label>
  );
}

function PasswordInput({ value, onChange, autoComplete, id, autoFocus }: { value: string; onChange: (v: string) => void; autoComplete: string; id?: string; autoFocus?: boolean }) {
  const [show, setShow] = useState(false);
  return (
    <div className="relative">
      <input id={id} className="field pr-12" type={show ? 'text' : 'password'} value={value} autoComplete={autoComplete} autoFocus={autoFocus} onChange={(e) => onChange(e.target.value)} required minLength={8} />
      <button type="button" onClick={() => setShow((s) => !s)} aria-label={show ? 'Hide password' : 'Show password'} className="absolute right-2 top-1/2 -translate-y-1/2 rounded p-2 text-mist-300 hover:text-white">
        {show ? <EyeOff size={18} /> : <Eye size={18} />}
      </button>
    </div>
  );
}

const errText = (e: unknown) => (e as Error)?.message || 'Something went wrong. Try again.';

// ---- sign in ------------------------------------------------------------------

export function LoginScreen() {
  const [email, setEmail] = useState(rememberedEmail);
  const [password, setPassword] = useState('');
  const [error, setError] = useState<string | null>(null);
  const [busy, setBusy] = useState(false);
  useHints([{ kb: 'Enter', pad: 'A', label: 'Sign in' }]);

  const submit = async (e: FormEvent) => {
    e.preventDefault();
    setBusy(true);
    setError(null);
    try {
      await signIn(email.trim(), password);
      try {
        localStorage.setItem(EMAIL_KEY, email.trim());
      } catch {
        /* storage unavailable */
      }
    } catch (err) {
      setError(errText(err));
    } finally {
      setBusy(false);
    }
  };

  return (
    <AuthCard
      title="Sign in"
      sub="Welcome back. Your World Cup and your friends are waiting."
      footer={
        <>
          New here? <Link to="/signup" className="font-semibold text-neon-400 hover:underline">Create an account</Link>
        </>
      }
    >
      <form onSubmit={submit} noValidate={false}>
        <Field label="Email">
          <input className="field" type="email" autoComplete="email" inputMode="email" autoFocus={!email} value={email} onChange={(e) => setEmail(e.target.value)} required />
        </Field>
        <Field label="Password" error={error}>
          <PasswordInput value={password} onChange={setPassword} autoComplete="current-password" autoFocus={!!email} />
        </Field>
        <div className="mb-5 text-right">
          <Link to="/reset-password" className="font-body text-sm text-mist-300 hover:text-white">Forgot password?</Link>
        </div>
        <Btn type="submit" variant="primary" size="lg" className="w-full" disabled={busy}>{busy ? 'Signing in…' : 'Sign in'}</Btn>
      </form>
    </AuthCard>
  );
}

// ---- sign up: email, code and password, then a player name on /welcome ------------

export function SignupScreen() {
  const [stage, setStage] = useState<'email' | 'verify'>('email');
  const [requestId, setRequestId] = useState('');
  const [email, setEmail] = useState(rememberedEmail);
  const [code, setCode] = useState('');
  const [password, setPassword] = useState('');
  const [password2, setPassword2] = useState('');
  const [error, setError] = useState<string | null>(null);
  const [busy, setBusy] = useState(false);
  const [cooldown, setCooldown] = useState(0);

  useEffect(() => {
    if (cooldown <= 0) return;
    const t = setTimeout(() => setCooldown((c) => c - 1), 1000);
    return () => clearTimeout(t);
  }, [cooldown]);

  const send = async (e?: FormEvent) => {
    e?.preventDefault();
    setBusy(true);
    setError(null);
    try {
      setRequestId(await startRegistration(email.trim()));
      setStage('verify');
      setCooldown(30);
    } catch (err) {
      setError(errText(err));
    } finally {
      setBusy(false);
    }
  };

  const strength = password.length >= 12 ? 3 : password.length >= 10 ? 2 : password.length >= 8 ? 1 : 0;
  const finish = async (e: FormEvent) => {
    e.preventDefault();
    if (password !== password2) return setError('The two passwords do not match.');
    setBusy(true);
    setError(null);
    try {
      await finishRegistration(requestId, code.trim(), password);
      try {
        localStorage.setItem(EMAIL_KEY, email.trim());
      } catch {
        /* storage unavailable */
      }
    } catch (err) {
      setError(errText(err));
    } finally {
      setBusy(false);
    }
  };

  return (
    <AuthCard
      title={stage === 'email' ? 'Create your account' : 'Check your email'}
      sub={stage === 'email' ? 'Free, takes a minute. We email you a code to confirm it is you.' : `We sent a code to ${email}. It can take a minute to arrive.`}
      step={[stage === 'email' ? 1 : 2, 3]}
      footer={
        <>
          Already have an account? <Link to="/login" className="font-semibold text-neon-400 hover:underline">Sign in</Link>
        </>
      }
    >
      {stage === 'email' ? (
        <form onSubmit={send}>
          <Field label="Email" error={error}>
            <input className="field" type="email" autoComplete="email" inputMode="email" autoFocus value={email} onChange={(e) => setEmail(e.target.value)} required />
          </Field>
          <Btn type="submit" variant="primary" size="lg" className="w-full" disabled={busy}>{busy ? 'Sending…' : 'Send me a code'}</Btn>
        </form>
      ) : (
        <form onSubmit={finish}>
          <Field label="Verification code" hint="Paste the code from the email.">
            <input className="field text-center font-display text-3xl tracking-[0.3em]" inputMode="numeric" autoComplete="one-time-code" autoFocus value={code} onChange={(e) => setCode(e.target.value.replace(/\s/g, ''))} required />
          </Field>
          <Field label="Choose a password" hint="At least 8 characters. Longer is stronger.">
            <PasswordInput value={password} onChange={setPassword} autoComplete="new-password" />
            <div className="mt-2 flex gap-1" aria-hidden="true">
              {[1, 2, 3].map((n) => (
                <span key={n} className={`h-1 flex-1 rounded-full ${strength >= n ? (strength === 3 ? 'bg-win' : strength === 2 ? 'bg-gold-400' : 'bg-hot-500') : 'bg-white/15'}`} />
              ))}
            </div>
          </Field>
          <Field label="Repeat the password" error={error}>
            <PasswordInput value={password2} onChange={setPassword2} autoComplete="new-password" />
          </Field>
          <Btn type="submit" variant="primary" size="lg" className="w-full" disabled={busy}>{busy ? 'Creating…' : 'Create account'}</Btn>
          <div className="mt-4 flex items-center justify-between font-body text-sm">
            <button type="button" className="text-mist-300 hover:text-white" onClick={() => { setStage('email'); setError(null); }}>Use a different email</button>
            <button type="button" className="text-neon-400 hover:underline disabled:text-mist-500 disabled:no-underline" disabled={cooldown > 0 || busy} onClick={() => send()}>
              {cooldown > 0 ? `Resend in ${cooldown}s` : 'Resend code'}
            </button>
          </div>
        </form>
      )}
    </AuthCard>
  );
}

// ---- reset password ------------------------------------------------------------

export function ResetPasswordScreen() {
  const navigate = useNavigate();
  const [requestId, setRequestId] = useState('');
  const [email, setEmail] = useState(rememberedEmail);
  const [code, setCode] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState<string | null>(null);
  const [busy, setBusy] = useState(false);

  const go = async (fn: () => Promise<void>) => {
    setBusy(true);
    setError(null);
    try {
      await fn();
    } catch (e) {
      setError(errText(e));
    } finally {
      setBusy(false);
    }
  };

  return (
    <AuthCard title="Reset your password" sub={requestId ? 'Enter the code we emailed and a new password.' : 'We will email you a code.'} footer={<Link to="/login" className="font-semibold text-neon-400 hover:underline">Back to sign in</Link>}>
      {!requestId ? (
        <form onSubmit={(e) => { e.preventDefault(); void go(async () => setRequestId(await startPasswordReset(email.trim()))); }}>
          <Field label="Email" error={error}>
            <input className="field" type="email" autoComplete="email" autoFocus value={email} onChange={(e) => setEmail(e.target.value)} required />
          </Field>
          <Btn type="submit" variant="primary" size="lg" className="w-full" disabled={busy}>Send code</Btn>
        </form>
      ) : (
        <form onSubmit={(e) => { e.preventDefault(); void go(async () => { await finishPasswordReset(requestId, code.trim(), password); navigate('/login'); }); }}>
          <Field label="Code from your email">
            <input className="field text-center font-display text-3xl tracking-[0.3em]" inputMode="numeric" autoComplete="one-time-code" autoFocus value={code} onChange={(e) => setCode(e.target.value.replace(/\s/g, ''))} required />
          </Field>
          <Field label="New password" error={error}>
            <PasswordInput value={password} onChange={setPassword} autoComplete="new-password" />
          </Field>
          <Btn type="submit" variant="primary" size="lg" className="w-full" disabled={busy}>Change password</Btn>
        </form>
      )}
    </AuthCard>
  );
}

// ---- player name -----------------------------------------------------------------

export function WelcomeScreen() {
  const session = useSession();
  const navigate = useNavigate();
  const [name, setName] = useState('');
  const [fav, setFav] = useState('');
  const [terms, setTerms] = useState(false);
  const [avail, setAvail] = useState<'idle' | 'checking' | 'ok' | 'taken' | 'bad'>('idle');
  const [error, setError] = useState<string | null>(null);
  const [busy, setBusy] = useState(false);
  const seq = useRef(0);

  // Check the name as the player types, so a clash shows before they press the button.
  const check = useCallback(async (v: string) => {
    const mine = ++seq.current;
    if (!/^[A-Za-z0-9_-]{3,16}$/.test(v)) return setAvail(v ? 'bad' : 'idle');
    setAvail('checking');
    try {
      const ok = await call<boolean>('profile/isNameAvailable', { displayName: v });
      if (mine === seq.current) setAvail(ok ? 'ok' : 'taken');
    } catch {
      if (mine === seq.current) setAvail('idle');
    }
  }, []);
  useEffect(() => {
    const t = setTimeout(() => void check(name), 350);
    return () => clearTimeout(t);
  }, [name, check]);

  if (session.status === 'in') return <Navigate to="/" replace />;
  if (session.status === 'out') return <Navigate to="/login" replace />;

  const submit = async (e: FormEvent) => {
    e.preventDefault();
    setBusy(true);
    setError(null);
    try {
      await createProfile(name.trim());
      if (fav) await call('profile/updateProfile', { region: null, favouriteNation: fav });
      navigate('/', { replace: true });
    } catch (err) {
      setError(errText(err));
    } finally {
      setBusy(false);
    }
  };

  const hint =
    avail === 'ok' ? '✓ Available' : avail === 'taken' ? 'That name is taken.' : avail === 'bad' ? '3–16 letters, digits, _ or -.' : avail === 'checking' ? 'Checking…' : 'Friends add you by this exact name.';

  return (
    <AuthCard title="Choose your player name" sub="This is what other players see." step={[3, 3]}>
      <form onSubmit={submit}>
        <Field label="Display name" error={avail === 'taken' || avail === 'bad' ? hint : error} hint={avail === 'ok' ? undefined : hint}>
          <input className="field" autoFocus maxLength={16} autoComplete="nickname" value={name} aria-invalid={avail === 'taken' || avail === 'bad'} onChange={(e) => setName(e.target.value)} required />
          {avail === 'ok' && <span className="mt-1 block font-body text-sm text-win">{hint}</span>}
        </Field>
        <Field label="Favourite nation (optional)">
          <div className="flex items-center gap-3">
            {fav && <Flag nation={fav} className="h-9 w-12" />}
            <select className="field" value={fav} onChange={(e) => setFav(e.target.value)}>
              <option value="">Choose later</option>
              {TEAMS.map((t) => <option key={nationId(t)} value={nationId(t)}>{t.name}</option>)}
            </select>
          </div>
        </Field>
        <label className="mb-5 flex items-start gap-3 font-body text-sm text-mist-200">
          <input type="checkbox" className="mt-1 h-5 w-5 accent-cyan-400" checked={terms} onChange={(e) => setTerms(e.target.checked)} required />
          <span>
            I accept the <Link to="/terms" target="_blank" className="text-neon-400 underline">Terms</Link> and the <Link to="/privacy" target="_blank" className="text-neon-400 underline">Privacy notice</Link>.
          </span>
        </label>
        <Btn type="submit" variant="primary" size="lg" className="w-full" disabled={busy || avail !== 'ok' || !terms}>{busy ? 'Saving…' : "Let's play"}</Btn>
      </form>
    </AuthCard>
  );
}
