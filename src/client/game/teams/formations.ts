// Shared formation position templates (fractions of the field, attacking
// RIGHT). Index 0 = GK, 1–4 = back line, then midfield, then attack. Real
// squads reference one of these so each country file only carries names,
// numbers and kit colours.
import type { TeamData, Vec } from './types';

// 4-3-3: [GK, RB, CB, CB, LB, DM, CM, CM, RW, ST, LW]
export const F_433: Vec[] = [
  { x: 0.045, y: 0.5 },
  { x: 0.17, y: 0.18 },
  { x: 0.13, y: 0.4 },
  { x: 0.13, y: 0.6 },
  { x: 0.17, y: 0.82 },
  { x: 0.27, y: 0.5 },
  { x: 0.37, y: 0.34 },
  { x: 0.37, y: 0.66 },
  { x: 0.5, y: 0.16 },
  { x: 0.55, y: 0.5 },
  { x: 0.5, y: 0.84 },
];

// 4-2-3-1: [GK, RB, CB, CB, LB, DM, DM, AM, RW, ST, LW]
export const F_4231: Vec[] = [
  { x: 0.045, y: 0.5 },
  { x: 0.17, y: 0.18 },
  { x: 0.13, y: 0.4 },
  { x: 0.13, y: 0.6 },
  { x: 0.17, y: 0.82 },
  { x: 0.27, y: 0.38 },
  { x: 0.27, y: 0.62 },
  { x: 0.4, y: 0.5 },
  { x: 0.47, y: 0.18 },
  { x: 0.56, y: 0.5 },
  { x: 0.47, y: 0.82 },
];

// 4-4-2: [GK, RB, CB, CB, LB, RM, CM, CM, LM, ST, ST]
export const F_442: Vec[] = [
  { x: 0.045, y: 0.5 },
  { x: 0.17, y: 0.18 },
  { x: 0.13, y: 0.4 },
  { x: 0.13, y: 0.6 },
  { x: 0.17, y: 0.82 },
  { x: 0.4, y: 0.16 },
  { x: 0.33, y: 0.42 },
  { x: 0.33, y: 0.58 },
  { x: 0.4, y: 0.84 },
  { x: 0.55, y: 0.42 },
  { x: 0.55, y: 0.58 },
];

// 3-5-2: [GK, CB, CB, CB, DM, RWB, CM, CM, LWB, ST, ST]
export const F_352: Vec[] = [
  { x: 0.045, y: 0.5 },
  { x: 0.14, y: 0.32 },
  { x: 0.12, y: 0.5 },
  { x: 0.14, y: 0.68 },
  { x: 0.27, y: 0.5 },
  { x: 0.34, y: 0.14 },
  { x: 0.4, y: 0.42 },
  { x: 0.4, y: 0.58 },
  { x: 0.34, y: 0.86 },
  { x: 0.56, y: 0.42 },
  { x: 0.56, y: 0.58 },
];

// 3-4-3: [GK, CB, CB, CB, RWB, CM, CM, LWB, RW, ST, LW]
export const F_343: Vec[] = [
  { x: 0.045, y: 0.5 },
  { x: 0.14, y: 0.32 },
  { x: 0.12, y: 0.5 },
  { x: 0.14, y: 0.68 },
  { x: 0.32, y: 0.14 },
  { x: 0.36, y: 0.42 },
  { x: 0.36, y: 0.58 },
  { x: 0.32, y: 0.86 },
  { x: 0.52, y: 0.2 },
  { x: 0.57, y: 0.5 },
  { x: 0.52, y: 0.8 },
];

/** The formations a player can pick before a match. Positions keep each shirt on the same slot. */
export const FORMATIONS: { id: string; label: string; pos: Vec[] }[] = [
  { id: '433', label: '4-3-3', pos: F_433 },
  { id: '4231', label: '4-2-3-1', pos: F_4231 },
  { id: '442', label: '4-4-2', pos: F_442 },
  { id: '352', label: '3-5-2', pos: F_352 },
  { id: '343', label: '3-4-3', pos: F_343 },
];

/** The same team lined up in another formation (a team's own default if the id is unknown). */
export function applyFormation(team: TeamData, id: string | null): TeamData {
  const f = FORMATIONS.find((x) => x.id === id);
  if (!f) return team;
  return { ...team, formation: f.label, players: team.players.map((p, i) => ({ ...p, pos: f.pos[i] ?? p.pos })) };
}

const FORMATION_KEY = 'wc2026.formation';
export function loadFormation(): string | null {
  try {
    const v = localStorage.getItem(FORMATION_KEY);
    return FORMATIONS.some((f) => f.id === v) ? v : null;
  } catch {
    return null;
  }
}
export function saveFormation(id: string | null) {
  try {
    if (id) localStorage.setItem(FORMATION_KEY, id);
    else localStorage.removeItem(FORMATION_KEY);
    window.dispatchEvent(new Event('wc2026:settings'));
  } catch {
    /* storage unavailable */
  }
}
