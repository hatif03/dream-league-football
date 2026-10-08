// Core engine-domain types shared across the simulation and renderer.
// (Team data types — TeamData, Kit — live in ./teams/types.)

import type { Ratings } from './teams/types';

export type Vec = { x: number; y: number };
export type Team = 'home' | 'away';
export type Role = 'GK' | 'DF' | 'MF' | 'ST';

export interface PlayerEntity {
  x: number;
  y: number;
  vx: number;
  vy: number;
  r: number;
  team: Team;
  /** Formation anchor in field coordinates. */
  anchor: Vec;
  facing: Vec;
  /** Run-cycle phase, advanced by distance travelled. */
  animPhase: number;
  /** > 0 while playing the kick pose. */
  kickTimer: number;
  hair: string;
  skin: string;
  isGK: boolean;
  role: Role;
  /** Squad slot (0 = keeper). Stable when a teammate is sent off and the arrays shrink. */
  idx: number;
  /** Yellow cards shown so far; a second one is a red. */
  yellows?: number;
  /** Shirt number, shown on the back of the jersey. */
  num: number;
  /** Surname, shown in the FIFA-style selected-player indicator. */
  name: string;
  /** FIFA-style attribute card driving this player's in-game ability. */
  ratings: Ratings;
  /** > 0 while playing the goal-celebration pose (arms raised). */
  celebrating?: boolean;
  /** > 0 while a keeper is playing the dive/save pose (full-body lay-out). */
  diveTimer?: number;
  /** Direction of the current dive along the goal mouth (world-y sign). */
  diveDir?: number;
  /** Lockout so a keeper doesn't re-trigger a dive every frame. */
  diveCooldown?: number;
  /** > 0 while playing the grounded sliding-tackle pose (full-body lay-out). */
  slideTimer?: number;
  /** Direction the slide is committed along, in field coordinates. */
  slideDir?: Vec;
  /** The ball-carrier this player's slide made body contact with (a foul unless he won the ball). */
  slideHit?: PlayerEntity | null;
  /** True while this player is holding the ball overhead for a throw-in. */
  throwing?: boolean;
}

/** End-of-match numbers, each as [home, away] from the viewer's side. */
export interface MatchStats {
  /** Possession in percent (adds to 100). */
  possession: [number, number];
  shots: [number, number];
  onTarget: [number, number];
  saves: [number, number];
  yellow: [number, number];
  red: [number, number];
}

export interface HudState {
  homeScore: number;
  awayScore: number;
  /** In-game match seconds elapsed (counts UP, 0 -> 5400 = 90:00). */
  clock: number;
  message: string;
  possession: Team | 'none';
  /** Active player per side, for the bottom-corner broadcast lower-thirds. */
  homePlayer: { num: number; name: string } | null;
  awayPlayer: { num: number; name: string } | null;
  /** 0..1 charge of the in-progress home kick, or null when not charging. */
  charge: number | null;
  /** True once the full-time whistle has gone (never in practice). */
  finished: boolean;
  /** True once the game has gone to extra time (knockouts only). */
  extraTime?: boolean;
  /** Filled once the final whistle has gone. */
  stats?: MatchStats;
  /** A goal replay is playing (any key skips it). */
  replay?: boolean;
  /** Minutes of added time announced at 90', once announced. */
  added?: number;
}

/** Things that happen in a match, for the commentary and the crowd (see ui/commentary.ts and ui/crowd.ts). */
export type GameEventKind = 'goal' | 'save' | 'shot' | 'foul' | 'yellow' | 'red' | 'offside' | 'corner' | 'goalkick' | 'throwin' | 'penalty' | 'halftime' | 'fulltime' | 'added' | 'extratime';
export interface GameEvent {
  kind: GameEventKind;
  /** The team the event is about: the scorer, the keeper who saved, the player who fouled. */
  team?: Team;
  name?: string;
  /** The score "2-1" for a goal, the minutes for added time. */
  extra?: string;
}

export type StateListener = (s: HudState) => void;
