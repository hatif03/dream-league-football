// What the host sends the guest about 30 times a second. Positions are in the
// HOST's frame (host attacks right); the guest view mirrors them so the guest
// also attacks right. Rows are plain number arrays to keep each packet small.

/** Player row indices. Rows 0-10 are the host's team (home), 11-21 the guest's (away). */
export const P = {
  X: 0,
  Y: 1,
  VX: 2,
  VY: 3,
  FX: 4,
  FY: 5,
  ANIM: 6,
  KICK: 7,
  DIVE: 8,
  DIVE_DIR: 9,
  SLIDE: 10,
  SLIDE_X: 11,
  SLIDE_Y: 12,
  /** bit 0 celebrating, bit 1 throwing */
  FLAGS: 13,
  /** Squad slot, and which team: 0 host, 1 guest. Rows can be missing after a red card. */
  IDX: 14,
  TEAM: 15,
  LEN: 16,
} as const;

export interface Snapshot {
  /** Sender's performance.now() when built; the receiver interpolates on it. */
  t: number;
  seq: number;
  cam: [number, number];
  /** x, y, z, vx, vy, vz */
  ball: [number, number, number, number, number, number];
  p: number[][];
  /** host controlled, host hint, guest controlled, guest hint (row index or -1) */
  sel: [number, number, number, number];
  /** host goals, guest goals */
  score: [number, number];
  /** match clock in display seconds (0-5400) */
  clock: number;
  msg: string;
  /** who has the ball: 0 nobody, 1 host, 2 guest */
  poss: 0 | 1 | 2;
  /** power gauge 0-1 for the host and for the guest, or -1 */
  charge: [number, number];
  /** net ripple, left then right goal, in the host's frame */
  ripple: [number, number];
  /** full time has been blown */
  fin: boolean;
  /** minutes of added time announced at 90 (0 before that) */
  added?: number;
  /** Final numbers as [host, guest] pairs, present once `fin` is true. */
  stats?: { poss: [number, number]; shots: [number, number]; onTarget: [number, number]; saves: [number, number]; yellow: [number, number]; red: [number, number] };
}

/** Messages on the guest → host input channel. Codes are canonical (default-binding) key codes. */
export interface InputMsg {
  type: 'in';
  held: string[];
  pressed: string[];
  released: string[];
}
