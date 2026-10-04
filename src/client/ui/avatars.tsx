// 24 pre-made footballer avatars, drawn as SVG from a number so there is nothing to download.
// The id (0-23) is what the server stores in UserProfile.avatar; it must stay below AVATAR_COUNT
// (the same limit lives in the server's `avatarCount`).

export const AVATAR_COUNT = 24;

const SKIN = ['#f6d3b4', '#e8b88f', '#c98f65', '#a56b46', '#7b4a2e', '#5a3420'];
const HAIR = ['#17171b', '#4a2c17', '#8a5a2b', '#d9ad4e', '#b8402a'];
const SHIRT = ['#e63946', '#2a9df4', '#2ecc71', '#f5c518', '#ff7a1a', '#a259ff', '#f4f3ff', '#14b8a6'];
const BG: [string, string][] = [
  ['#1d2b64', '#4a43c4'],
  ['#0b6e4f', '#28e4ff'],
  ['#6a1b9a', '#ff3d8b'],
  ['#b45309', '#ffc83a'],
  ['#0f3d6e', '#3aa0ff'],
  ['#7f1d1d', '#ff6b4a'],
  ['#134e4a', '#3df08a'],
  ['#3b0764', '#a78bfa'],
];

/** The pieces an avatar id is built from. The ids are spread so that all 24 look different. */
function parts(id: number) {
  const i = ((Math.trunc(id) % AVATAR_COUNT) + AVATAR_COUNT) % AVATAR_COUNT;
  return {
    i,
    style: i % 6,
    bg: BG[i % 8],
    skin: SKIN[(i * 5 + 1) % 6],
    hair: HAIR[(i * 3) % 5],
    shirt: SHIRT[(i * 7 + 2) % 8],
    band: i % 4 === 1,
    smile: i % 3,
  };
}

export function AvatarArt({ id, size = 40 }: { id: number; size?: number }) {
  const p = parts(id);
  const gid = `av${p.i}`;
  const dark = 'rgba(0,0,0,0.22)';
  const hairFront = {
    0: <path d="M20.5 29c-.5-9 4.5-14 11.5-14s12 5 11.5 14c-2-5-6-8-11.5-8s-9.5 3-11.5 8z" fill={p.hair} />, // short
    1: <path d="M21 27c0-7 4.5-11 11-11s11 4 11 11c-2.5-4-6.5-6-11-6s-8.5 2-11 6z" fill={p.hair} />, // buzz cut
    2: null, // afro: drawn behind the head
    3: null, // long: drawn behind the head
    4: <path d="M29 18c0-5 1-8 3-9.5 2 1.5 3 4.5 3 9.5-1-1.5-2-2-3-2s-2 .5-3 2z" fill={p.hair} />, // mohawk
    5: null, // bald with a beard
  }[p.style];
  return (
    <svg viewBox="0 0 64 64" width={size} height={size} role="img" aria-label={`Avatar ${p.i + 1}`} style={{ display: 'block' }}>
      <defs>
        <linearGradient id={gid} x1="0" y1="0" x2="1" y2="1">
          <stop offset="0" stopColor={p.bg[0]} />
          <stop offset="1" stopColor={p.bg[1]} />
        </linearGradient>
        <clipPath id={`${gid}c`}>
          <circle cx="32" cy="32" r="32" />
        </clipPath>
      </defs>
      <g clipPath={`url(#${gid}c)`}>
        <rect width="64" height="64" fill={`url(#${gid})`} />
        {/* hair behind the head */}
        {p.style === 2 && <circle cx="32" cy="24" r="16" fill={p.hair} />}
        {p.style === 3 && <path d="M18 30c-1-11 5-17 14-17s15 6 14 17l1 20H17z" fill={p.hair} />}
        {/* shoulders and shirt */}
        <path d="M6 66c1-14 10-20 26-20s25 6 26 20z" fill={p.shirt} />
        <path d="M26 47l6 8 6-8" fill="none" stroke={dark} strokeWidth="2.4" strokeLinejoin="round" />
        <path d="M6 66c1-4 2-7 4-10M58 66c-1-4-2-7-4-10" stroke="rgba(255,255,255,0.35)" strokeWidth="2" fill="none" />
        {/* neck and head */}
        <rect x="27.5" y="38" width="9" height="11" rx="3" fill={p.skin} />
        <rect x="27.5" y="38" width="9" height="5" rx="2" fill={dark} />
        <ellipse cx="21" cy="31" rx="2.2" ry="3" fill={p.skin} />
        <ellipse cx="43" cy="31" rx="2.2" ry="3" fill={p.skin} />
        <ellipse cx="32" cy="29.5" rx="11" ry="12.5" fill={p.skin} />
        {p.style === 5 && <path d="M21.5 33c1 8 5 12 10.5 12s9.5-4 10.5-12c-2 3-5 4-10.5 4s-8.5-1-10.5-4z" fill={p.hair} />}
        {hairFront}
        {p.band && <rect x="20.5" y="23" width="23" height="3.2" rx="1.2" fill={p.shirt === '#f4f3ff' ? '#e63946' : '#f4f3ff'} />}
        {/* face */}
        <ellipse cx="27.3" cy="30" rx="1.5" ry="1.9" fill="#1b1b1f" />
        <ellipse cx="36.7" cy="30" rx="1.5" ry="1.9" fill="#1b1b1f" />
        <path d="M24.5 26.4q2.8-1.6 5.6 0M33.9 26.4q2.8-1.6 5.6 0" stroke={p.style === 5 ? p.hair : dark} strokeWidth="1.3" fill="none" strokeLinecap="round" />
        {p.smile === 0 && <path d="M28 37q4 3.4 8 0" stroke="#1b1b1f" strokeWidth="1.5" fill="none" strokeLinecap="round" />}
        {p.smile === 1 && <path d="M28.5 36.6q3.5 4 7 0z" fill="#fff" stroke="#1b1b1f" strokeWidth="1.2" strokeLinejoin="round" />}
        {p.smile === 2 && <path d="M28.5 37.4h7" stroke="#1b1b1f" strokeWidth="1.5" strokeLinecap="round" />}
      </g>
    </svg>
  );
}

/** A grid to choose from. `value` is the current avatar id, if any. */
export function AvatarPicker({ value, onPick, disabled, wide }: { value?: number | null; onPick: (id: number) => void; disabled?: boolean; wide?: boolean }) {
  return (
    <div role="radiogroup" aria-label="Choose your avatar" className={`grid grid-cols-6 gap-2 ${wide ? 'sm:grid-cols-8 md:grid-cols-12' : ''}`}>
      {Array.from({ length: AVATAR_COUNT }, (_, id) => (
        <button
          key={id}
          role="radio"
          aria-checked={value === id}
          aria-label={`Avatar ${id + 1}`}
          disabled={disabled}
          onClick={() => onPick(id)}
          className={`rounded-full p-0.5 transition-transform hover:scale-105 focus-visible:scale-105 ${value === id ? 'bg-neon-400 shadow-[0_0_14px_#28e4ff]' : 'bg-white/10'}`}
        >
          <AvatarArt id={id} size={wide ? 52 : 44} />
        </button>
      ))}
    </div>
  );
}
