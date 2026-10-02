import { FLAG_URL } from './flags';
import { teamById } from '@/client/game/teams';

/** A nation's flag, with a coloured abbreviation badge as a fallback. */
export function Flag({
  nation,
  className = 'h-6 w-9',
  rounded = true,
}: {
  nation: string;
  className?: string;
  rounded?: boolean;
}) {
  const url = FLAG_URL[nation];
  const team = teamById(nation);
  if (!url) {
    return (
      <span
        className={`${className} inline-flex items-center justify-center bg-ink-600 text-[10px] font-bold ${rounded ? 'rounded-sm' : ''}`}
        style={{ backgroundColor: team?.color }}
      >
        {team?.abbr ?? '?'}
      </span>
    );
  }
  return (
    <img
      src={url}
      alt=""
      loading="lazy"
      draggable={false}
      className={`${className} object-cover shadow-[0_0_0_1px_rgba(255,255,255,0.25)] ${rounded ? 'rounded-[3px]' : ''}`}
    />
  );
}
