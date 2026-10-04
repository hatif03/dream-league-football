import type { Club, CrestIcon, CrestShape } from '@/client/game/club';

const SHAPES: Record<CrestShape, string> = {
  shield: 'M8 5h48v26c0 15-10 23-24 29C18 54 8 46 8 31z',
  round: 'M32 3a29 29 0 1 1 0 58a29 29 0 1 1 0-58z',
  diamond: 'M32 3l27 29-27 29L5 32z',
  hex: 'M32 3l24 14v30L32 61 8 47V17z',
};

function Icon({ icon, fill }: { icon: CrestIcon; fill: string }) {
  switch (icon) {
    case 'star':
      return <path d="M32 18l4.2 8.8 9.6 1.3-7 6.7 1.7 9.6L32 39.7 23.5 44.4l1.7-9.6-7-6.7 9.6-1.3z" fill={fill} />;
    case 'ball':
      return (
        <g>
          <circle cx="32" cy="32" r="12" fill={fill} />
          <path d="M32 25l5.5 4-2.1 6.4h-6.8L26.5 29z" fill="#0b0933" />
        </g>
      );
    case 'bolt':
      return <path d="M35 14L22 34h9l-3 16 14-22h-9z" fill={fill} />;
    case 'crown':
      return <path d="M18 42V24l8 8 6-12 6 12 8-8v18z" fill={fill} />;
    default:
      return null;
  }
}

/** A club crest drawn from its settings. */
export function Crest({ crest, size = 64 }: { crest: Club['crest']; size?: number }) {
  const id = `cr${crest.shape}${crest.c1.slice(1)}${crest.c2.slice(1)}`;
  return (
    <svg viewBox="0 0 64 64" width={size} height={size} role="img" aria-label="Club crest" style={{ display: 'block' }}>
      <defs>
        <clipPath id={id}>
          <path d={SHAPES[crest.shape]} />
        </clipPath>
      </defs>
      <path d={SHAPES[crest.shape]} fill={crest.c1} />
      <g clipPath={`url(#${id})`}>
        <rect x="24" y="0" width="16" height="64" fill={crest.c2} opacity="0.35" />
      </g>
      <path d={SHAPES[crest.shape]} fill="none" stroke={crest.c2} strokeWidth="3" strokeLinejoin="round" />
      <Icon icon={crest.icon} fill={crest.c2} />
    </svg>
  );
}
