import { Check, ChevronLeft, ChevronRight } from 'lucide-react';
import type { TeamData } from '@/client/game/teams';

export function TeamCrest({
  team,
  tag,
  active,
  locked,
  useAwayKit = false,
}: {
  team: TeamData;
  tag: string;
  active: boolean;
  locked: boolean;
  useAwayKit?: boolean;
}) {
  return (
    <div className="flex flex-col items-center gap-4 w-56 sm:w-64">
      <span
        className={`font-heading uppercase tracking-[0.3em] text-sm ${
          active ? 'text-volt-400' : 'text-night-300'
        }`}
      >
        {tag}
      </span>
      <div className="flex items-center gap-2 sm:gap-3">
        <ChevronLeft
          size={36}
          className={`shrink-0 transition-opacity ${
            active ? 'text-volt-500 animate-pulse' : 'text-transparent'
          }`}
        />
        <div
          className={`relative flex flex-col items-center justify-center overflow-hidden rounded-2xl w-40 h-48 sm:w-44 sm:h-52 transition-all ${
            active
              ? 'ring-4 ring-volt-500 scale-105 shadow-xl shadow-black/40'
              : locked
                ? 'ring-2 ring-volt-700/60 opacity-90'
                : 'ring-1 ring-night-700 opacity-70'
          }`}
          style={{
            backgroundImage: `radial-gradient(circle at 50% 38%, ${team.color}33, rgba(10,12,18,0.96) 72%), linear-gradient(160deg, #1b2030, #0c0f17)`,
          }}
        >
          {locked && (
            <span className="absolute top-2 right-2 bg-volt-500 text-night-950 rounded-full p-1 z-10">
              <Check size={18} strokeWidth={3} />
            </span>
          )}
          <KitJersey kit={useAwayKit ? team.awayKit : team.kit} />
        </div>
        <ChevronRight
          size={36}
          className={`shrink-0 transition-opacity ${
            active ? 'text-volt-500 animate-pulse' : 'text-transparent'
          }`}
        />
      </div>
      <span className="font-heading uppercase tracking-wider text-2xl sm:text-3xl text-white text-center leading-tight">
        {team.name}
      </span>
    </div>
  );
}

/** A football shirt illustration drawn from the team's kit colours. */
export function KitJersey({
  kit,
}: {
  kit: { shirt: string; sleeve: string; outline: string; shorts?: string };
}) {
  const shorts = kit.shorts ?? kit.sleeve;
  return (
    <svg
      viewBox="0 0 200 236"
      className="w-32 h-40 sm:w-36 sm:h-44 drop-shadow-[0_5px_8px_rgba(0,0,0,0.5)]"
      aria-hidden="true"
    >
      <g stroke={kit.outline} strokeWidth={4} strokeLinejoin="round" strokeLinecap="round">
        {/* shorts (drawn first so the shirt hem overlaps the waistband) */}
        <path
          d="M66 150 L134 150 L140 214 L108 214 L100 178 L92 214 L60 214 Z"
          fill={shorts}
        />
        {/* shirt body silhouette */}
        <path
          d="M84 36 L58 44 L20 62 L31 104 L66 94 L64 166 L136 166 L134 94 L169 104 L180 62 L142 44 L116 36 Q100 56 84 36 Z"
          fill={kit.shirt}
        />
        {/* left sleeve */}
        <path d="M58 44 L20 62 L31 104 L66 94 Z" fill={kit.sleeve} />
        {/* right sleeve */}
        <path d="M142 44 L180 62 L169 104 L134 94 Z" fill={kit.sleeve} />
        {/* collar */}
        <path d="M84 36 Q100 56 116 36" fill="none" strokeWidth={4} />
      </g>
    </svg>
  );
}
