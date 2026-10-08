# User interface

The interface follows the structure of the FIFA / EA FC front end: a persistent frame, a few big tiles, one primary action per screen, console-style navigation and a footer of button prompts. The reasoning and the checklist of friction fixes are in [UI_PLAN.md](../UI_PLAN.md); this page describes what is built.

| Home | World Cup run |
| --- | --- |
| ![Home](img/home.png) | ![World Cup hub](img/world-cup-hub.png) |

| Online | Lobby |
| --- | --- |
| ![Online hub](img/online.png) | ![Lobby](img/lobby.png) |

## Design system: "Matchday Night"

Defined in `src/client/index.css` as Tailwind v4 theme tokens.

- **Colour.** An indigo-to-royal-blue gradient background (`.app-bg`) with a faint diagonal hatch, translucent glass panels (`.glass`, `.glass-solid`), cyan as the primary and focus colour, magenta for live things and invitations, gold for the World Cup, green and red for results. Surface tokens are `ink-950…500`, text tints `mist-100…500`, accents `neon-*`, `hot-*`, `gold-*`.
- **Type.** Barlow Condensed (bold, uppercase, italic) for titles and numbers (`.t-display`, `.t-label`), Barlow for body text.
- **Tiles** (`.tile`, `<Tile>`): a coloured top bar from the team or mode colour; focus scales the tile up with a white outline and cyan glow.
- **Buttons** (`.btn`, `<Btn>`): skewed parallelograms. Primary = cyan, secondary = glass, danger = red. Each screen has one primary action.
- **Motion** is short (slide/fade on screen change, tile scale, the count-in) and disabled with `prefers-reduced-motion`.
- **Sound.** `ui/sfx.ts` synthesises move, select, back, notify, tick and whistle with the Web Audio API (no audio files), and `ui/crowd.ts` the stadium crowd; a mute switch lives in Settings.
- **Flags** come from the `flag-icons` package (the 48 nations used are bundled in `ui/flags.ts`).

## Avatars

Players pick one of 24 pre-made footballer avatars (`ui/avatars.tsx`): the pieces (skin, hair, kit, background) are chosen from the id, so there is nothing to download, and the id is stored on the server (`UserProfile.avatar`). The picker is on the sign-up screen (one is preselected) and behind the avatar on the profile. Avatars show in the header chip, the friends list, invites, the bell and the lobby.

## Club, tutorial, install and sharing

- **Club editor** (`/club`): crest shape, emblem and colours, club name, kit colours with swatches and a free colour picker, and a live preview. Saved with `profile/saveClub`.
- **Tutorial** (`screens/match/Tutorial.tsx`): a coach card on the pitch that watches counters from the engine (`tutorialProbe`: distance run, sprint time, kicks by type) and advances as you do each thing.
- **Install** (`ui/install.tsx`, `public/manifest.json`, icons made by `scripts/make-icons.mjs`): an install card in Settings (Chrome and Edge show a button; iPhone shows the Add to Home Screen steps).
- **Result card** (`ui/resultCard.ts`): the score drawn on a canvas as a 1200×630 image. Signed in, "Share result" uploads it to Serverpod cloud storage and shares the link `/r/<id>` (an Open Graph preview page).
- **Broadcast layer** (`ui/Commentary.tsx`, `ui/crowd.ts`, the REPLAY badge in `ui/MatchHud.tsx`): commentary captions under the pitch, the synthesised crowd, and the replay badge with its skip hint.
- **Live socket** (`net/live.ts`): `useLive(topics, handler)` runs a handler when the server pushes a change, so rooms, chat, friends and duels update without fast polling.
- **Leaderboard** (`/leaderboard`) and **achievements** (on the profile).
- **Quick chat**: the Chat button at the bottom of an online match.

## Notifications

Toasts close themselves after their duration (invites after 10 s) through `ToastReaper`, because react-hot-toast pauses a toast while the pointer is over it and on a phone a tap counts as hovering forever.

## Navigation

`ui/MenuNav.tsx` implements spatial focus: the arrow keys, the D-pad and the left stick move focus to the nearest focusable element in that direction; Enter or A activates; Esc or B goes back (any element marked `data-back`); Q/E or LB/RB switch tabs; mouse hover moves focus like a console cursor. Dialogs and menus set `data-nav-scope` so focus stays inside them.

`ui/hints.tsx` holds the **footer prompts**. A screen calls `useHints([...])` to add its own (for example "Sign in") in front of the defaults (Move, Select, Back, Tabs); the bar shows keyboard keys, controller glyphs or nothing (touch) depending on the device used last (`useLastDevice`, which defaults to touch on coarse-pointer devices).

`ui/Dialog.tsx` provides promise-based `confirm`, `alert`, `prompt` and `choose` dialogs; the app never uses `window.confirm` or `window.prompt`.

## Screens

| Route | Screen | Notes |
| --- | --- | --- |
| `/` | Home | Tiles: World Cup (the live run or "Start"), Play a friend, Practice, Your record. Signed out: Sign in |
| `/login`, `/signup`, `/reset-password`, `/welcome` | Account | Sign-up is a wizard (email → code → password → player name) with a live name-availability check, show-password, resend cooldown; the email is remembered |
| `/world-cup` | World Cup | Nation grid with search and confederation filters and a detail panel; then the run hub: next match card, My group / All groups / Knockouts tabs |
| `/online` | Online | A **Game** switch (11 v 11 match or penalty duel), **Find a match** (matchmaking with a search timer and cancel), create a room, enter a 5-character code, the **daily challenge** card with streak, friends with online dots and Invite, recent matches; the lobby is a versus screen with team panels, nation picker, ready state, chat and a share block (code, copy link, share sheet, QR) |
| `/practice` | Practice | Choose Practice, an 11 v 11 friendly or a penalty shootout, pick both teams, start |
| `/settings` | Settings | Tabs: Keyboard (with a **Layout** switch: FIFA classic, EA FC WASD, Custom), Controller (EA FC layout), Touch, Gameplay (CPU difficulty, match length, goal replays, commentary), Audio; opens on the tab for the device in use |
| `/profile` | Profile | Name, **rating**, favourite nation, record, head-to-head, recent matches, achievements, sign out, delete account |
| `/leaderboard` | Leaderboard | Rank by **Rating** or **Points** |
| `/match` | Match | Full viewport, outside the shell. A match: intro card (teams and controls for your device) → play → pause menu → result panel. A **penalty duel** (`DuelStage`): a goal with six zone buttons, a countdown bar, the kick dots of both sides, a reveal of every kick, and a result panel with the rating change, rematch and share |
| `/terms`, `/privacy` | Legal | |

The match screen's HUD (`ui/MatchHud.tsx`) is a broadcast-style scoreboard with flags, name plates for the active players, and a charge bar; stats bars and card counts appear in the result panel.

## Phones and small screens

- Matches run in **landscape**; in portrait a rotate prompt covers the pitch (dismissible with "Play anyway"). The page uses `100dvh`, safe-area insets, no pinch-zoom, and offers fullscreen with an orientation lock where the browser allows it.
- A custom Tailwind variant `desk:` (`src/client/index.css`) means "wide **and** tall" (min 768 × 520). A phone held sideways is wide but short, so it **keeps the mobile layout**: bottom tab bar in a compact row, no footer prompts, a compact intro card.
- On touch devices the name plates are hidden (the thumb stick sits there) and the charge bar moves to the top centre.
- Touch controls: a floating stick and seven buttons, swappable in Settings.
- Touch targets are generously sized; the header logo shrinks rather than pushing the profile chip off screen.

## Accessibility

- Every interactive element is a real `button`, `a` or form control with an accessible name; the pitch canvas has a label.
- Focus is always visible and follows one rule everywhere.
- Colour is never the only signal (results have text; presence has a dot and label).
- Errors appear where they happen (`role="alert"`), and toasts use `role="status"`.
- Reduced-motion preference is honoured; muted text is designed to keep at least 4.5:1 contrast (a contrast audit with a tool has not been run).
- A "Skip to content" link is the first focusable element in the shell.

## Reviewing the UI

`scripts/shots.mjs` captures every screen at desktop (1440×900) and phone portrait (390×844), and `scripts/shots-landscape.mjs` the match flow at phone landscape (844×390), into `.e2e-shots/ui/`. The browser tests (`e2e-ui`, `e2e-knockout`, `e2e-input`, `e2e-friend`) drive the real screens, so a broken flow fails them.
