// A player's club: a crest and a kit, saved on their account (UserProfile.club as JSON).
import type { Kit, TeamData } from './teams/types';

export type CrestShape = 'shield' | 'round' | 'diamond' | 'hex';
export type CrestIcon = 'star' | 'ball' | 'bolt' | 'crown' | 'none';

export interface Club {
  name: string;
  crest: { shape: CrestShape; icon: CrestIcon; c1: string; c2: string };
  kit: { shirt: string; sleeve: string; shorts: string };
  /** Wear this kit in solo matches and friendlies. */
  useKit: boolean;
}

export const CREST_SHAPES: CrestShape[] = ['shield', 'round', 'diamond', 'hex'];
export const CREST_ICONS: CrestIcon[] = ['star', 'ball', 'bolt', 'crown', 'none'];

export const DEFAULT_CLUB: Club = {
  name: 'My Club',
  crest: { shape: 'shield', icon: 'star', c1: '#1d4ed8', c2: '#fbbf24' },
  kit: { shirt: '#1d4ed8', sleeve: '#fbbf24', shorts: '#0b0933' },
  useKit: false,
};

const HEX = /^#[0-9a-fA-F]{6}$/;
const color = (v: unknown, d: string) => (typeof v === 'string' && HEX.test(v) ? v : d);

/** Reads the saved JSON, repairing anything missing or invalid. Null when the player has no club yet. */
export function parseClub(json?: string | null): Club | null {
  if (!json) return null;
  try {
    const o = JSON.parse(json) as Partial<Club> & { crest?: Partial<Club['crest']>; kit?: Partial<Club['kit']> };
    const d = DEFAULT_CLUB;
    return {
      name: typeof o.name === 'string' && o.name.trim() ? o.name.trim().slice(0, 20) : d.name,
      crest: {
        shape: CREST_SHAPES.includes(o.crest?.shape as CrestShape) ? (o.crest!.shape as CrestShape) : d.crest.shape,
        icon: CREST_ICONS.includes(o.crest?.icon as CrestIcon) ? (o.crest!.icon as CrestIcon) : d.crest.icon,
        c1: color(o.crest?.c1, d.crest.c1),
        c2: color(o.crest?.c2, d.crest.c2),
      },
      kit: { shirt: color(o.kit?.shirt, d.kit.shirt), sleeve: color(o.kit?.sleeve, d.kit.sleeve), shorts: color(o.kit?.shorts, d.kit.shorts) },
      useKit: o.useKit === true,
    };
  } catch {
    return null;
  }
}

/** A darker shade of a #rrggbb colour, still #rrggbb (the renderer parses kit colours as hex). */
function darken(hex: string, f: number): string {
  const n = parseInt(hex.slice(1), 16);
  const c = (v: number) => Math.round(v * f).toString(16).padStart(2, '0');
  return `#${c((n >> 16) & 255)}${c((n >> 8) & 255)}${c(n & 255)}`;
}

/** The club's kit in the shape the game draws. */
export function clubKit(club: Club): Kit {
  const { shirt, sleeve, shorts } = club.kit;
  return { shirt, sleeve, shorts, outline: darken(shirt, 0.55) };
}

/** The player's team wearing their own kit, if they chose to. */
export function applyClubKit(team: TeamData, club: Club | null): TeamData {
  return club?.useKit ? { ...team, kit: clubKit(club) } : team;
}
