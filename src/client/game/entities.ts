// Builds the static part of a player entity from a squad entry. Shared by the
// simulation (engine.ts) and the guest renderer (guestView.ts) so both sides
// draw identical people.

import type { SquadPlayer } from './teams/types';
import type { PlayerEntity, Team, Vec } from './types';
import { FIELD_W, FIELD_H, PLAYER_R, HAIR_COLORS, SKIN_TONES } from './constants';

/** `frac` is the formation slot as a fraction of the pitch, already mirrored for the away side. */
export function makePlayerEntity(team: Team, frac: Vec, i: number, squad: SquadPlayer): PlayerEntity {
  return {
    x: frac.x * FIELD_W,
    y: frac.y * FIELD_H,
    vx: 0,
    vy: 0,
    r: PLAYER_R,
    team,
    anchor: { x: frac.x * FIELD_W, y: frac.y * FIELD_H },
    facing: { x: team === 'home' ? 1 : -1, y: 0 },
    animPhase: Math.random() * Math.PI * 2,
    kickTimer: 0,
    hair: HAIR_COLORS[(i + (team === 'away' ? 2 : 0)) % HAIR_COLORS.length],
    skin: SKIN_TONES[(i + (team === 'away' ? 1 : 0)) % SKIN_TONES.length],
    isGK: i === 0,
    idx: i,
    role: i === 0 ? 'GK' : i <= 4 ? 'DF' : i <= 8 ? 'MF' : 'ST',
    num: squad.num,
    name: squad.name,
    ratings: squad.ratings,
  };
}
