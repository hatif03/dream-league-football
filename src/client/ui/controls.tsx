import { forwardRef, type ButtonHTMLAttributes, type ReactNode } from 'react';
import { Link, type LinkProps } from 'react-router-dom';

type Variant = 'primary' | 'ghost' | 'danger' | 'hot';
type Size = 'sm' | 'md' | 'lg';

const cls = (variant: Variant, size: Size, extra?: string) =>
  [
    'btn',
    variant === 'primary' && 'btn-primary',
    variant === 'danger' && 'btn-danger',
    variant === 'hot' && 'btn-hot',
    size === 'lg' && 'btn-lg',
    size === 'sm' && 'btn-sm',
    extra,
  ]
    .filter(Boolean)
    .join(' ');

/** The skewed game button. One primary per screen. */
export const Btn = forwardRef<
  HTMLButtonElement,
  ButtonHTMLAttributes<HTMLButtonElement> & { variant?: Variant; size?: Size }
>(function Btn({ variant = 'ghost', size = 'md', className, children, type = 'button', ...rest }, ref) {
  return (
    <button ref={ref} type={type} className={cls(variant, size, className)} {...rest}>
      <span>{children}</span>
    </button>
  );
});

export function LinkBtn({
  variant = 'ghost',
  size = 'md',
  className,
  children,
  ...rest
}: LinkProps & { variant?: Variant; size?: Size; children: ReactNode }) {
  return (
    <Link className={cls(variant, size, className)} {...rest}>
      <span>{children}</span>
    </Link>
  );
}

/** A block menu tile. `accent` colours the top bar and the focus glow. */
export const Tile = forwardRef<
  HTMLButtonElement,
  ButtonHTMLAttributes<HTMLButtonElement> & { accent?: string }
>(function Tile({ accent = '#28e4ff', className = '', style, children, type = 'button', ...rest }, ref) {
  return (
    <button
      ref={ref}
      type={type}
      className={`tile ${/flex-row/.test(className) ? '' : 'flex-col'} ${className}`}
      style={{ ['--accent' as string]: accent, ...style }}
      {...rest}
    >
      {children}
    </button>
  );
});

export function Spinner({ label = 'Loading' }: { label?: string }) {
  return (
    <div role="status" aria-label={label} className="flex items-center justify-center gap-3 text-mist-300">
      <span className="h-6 w-6 animate-spin rounded-full border-2 border-mist-500 border-t-neon-400" />
      <span className="t-label">{label}</span>
    </div>
  );
}

/** Small coloured pill. */
export function Badge({ tone = 'neon', children }: { tone?: 'neon' | 'hot' | 'gold' | 'win' | 'mute'; children: ReactNode }) {
  const c = {
    neon: 'bg-neon-400/20 text-neon-300 ring-neon-400/50',
    hot: 'bg-hot-500/25 text-hot-400 ring-hot-500/60',
    gold: 'bg-gold-400/20 text-gold-400 ring-gold-400/50',
    win: 'bg-win/20 text-win ring-win/50',
    mute: 'bg-white/10 text-mist-300 ring-white/20',
  }[tone];
  return <span className={`inline-flex items-center rounded-sm px-2 py-0.5 font-display text-[0.8rem] font-bold uppercase tracking-[0.14em] ring-1 ${c}`}>{children}</span>;
}

/** Initials in a coloured circle, with an optional online dot. */
export function Avatar({ name, online, size = 36 }: { name: string; online?: boolean; size?: number }) {
  const hue = [...name].reduce((h, ch) => (h * 31 + ch.charCodeAt(0)) % 360, 7);
  return (
    <span className="relative inline-flex shrink-0 items-center justify-center rounded-full font-display text-sm font-bold text-white ring-2 ring-white/30" style={{ width: size, height: size, background: `hsl(${hue} 70% 42%)` }} aria-hidden="true">
      {name.slice(0, 2).toUpperCase()}
      {online !== undefined && (
        <span className={`absolute -bottom-0.5 -right-0.5 h-3 w-3 rounded-full ring-2 ring-ink-900 ${online ? 'bg-win' : 'bg-mist-500'}`} />
      )}
    </span>
  );
}
