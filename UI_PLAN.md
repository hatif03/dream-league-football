# UI plan: make it feel like a football game

Benchmark: the FIFA / EA FC front end. Reference screens from the brief: FIFA 18 (dark slate, tall photo tiles, red team accent), FIFA 15 Ultimate Team (charcoal and gold, dense panels), FIFA 21 (purple to blue gradient, block tiles, white focus outline, pink and cyan accents). We borrow the structure and feel, not their assets.

## What is wrong today

1. It is a web page, not a game: black with lime text, white form cards on the auth pages, overlays stacked on a canvas, a legend of keyboard keys under the pitch.
2. No sense of place. There is no persistent frame, no top navigation, no profile chip, no footer of button prompts. Every mode is a different screen with different rules.
3. Menus work with a mouse or one fixed key map. A controller cannot move through them, and a phone gets desktop menus.
4. Creating and sharing a match is clumsy: a small code, a link that needs a click to copy, no QR or share sheet, an invite list hidden behind the lobby, no message when the friend arrives or leaves.
5. Leaving is silent: nothing tells the other player, and the match stayed `live` on the server. (Fixed on the server; the UI must show it.)
6. `window.confirm` and `window.prompt` for quitting and reporting. Errors are toasts that vanish. Invites are only visible on the front screen.
7. The match HUD is fine but the surroundings are not: no pause menu, no pre-match screen, a full-time panel that looks like a modal, no portrait handling on phones.

## Design system ("Matchday Night")

- **Background:** a deep indigo to royal blue gradient with a faint diagonal hatch and giant pitch markings. Never plain black.
- **Surfaces:** translucent glass panels with a 1 px light border. Tiles have a cut corner (clip-path) and a coloured top bar that takes the team or mode colour.
- **Accents:** cyan (primary action and focus), magenta (live, invitations), gold (World Cup, trophies), green and red for results. Text is white on dark; muted text keeps 4.5:1 contrast.
- **Type:** Barlow Condensed, bold, uppercase and slightly italic for titles and numbers; Barlow for body. Large numerals for scores.
- **Focus:** one rule everywhere. A focused tile scales up, gets a white outline and a cyan glow. Mouse hover moves the focus too, like a console cursor.
- **Buttons:** skewed parallelogram, primary = cyan fill with navy text, secondary = glass. Every screen has exactly one primary action.
- **Motion:** short slide and fade on screen change, tile scale on focus, count-in before kickoff. All of it respects `prefers-reduced-motion`.
- **Sound:** small synthesised sounds for move, select, back, whistle, goal. A mute switch in settings.

## Structure

- **App shell** on every menu screen: logo, tabs (Home, World Cup, Online, Practice, Settings), notification bell with a count, profile chip with an online dot, and a footer of button prompts that switches between keyboard, controller and touch glyphs. On phones the tabs become a bottom bar and the footer hides.
- **Navigation:** arrow keys, D-pad and left stick move focus spatially between tiles and fields; Enter or A confirms; Esc or B goes back; Q/E or LB/RB switch tabs. Mouse and touch work the same elements.
- **Routes:** `/` home, `/world-cup`, `/online`, `/practice`, `/match`, `/settings`, `/profile`, `/login`, `/signup`, `/welcome`, `/reset-password`, plus terms and privacy. `/match` without an active game goes home.
- **Dialogs:** one styled dialog component for confirm, prompt and choice. No browser dialogs.

## Screens

1. **Home:** a row of tall tiles (World Cup with the live run or "Start", Play a Friend with friends online and any invite, Practice, Profile and record). Signed out: a prominent Sign in tile and a short pitch.
2. **World Cup:** team select as a grid of flags with search and confederation filters, a detail panel (kit, squad rating, group and opening opponents), difficulty chooser. The run screen has a hero "Next match" card, a visual knockout bracket and group tables.
3. **Online:** a hub with Create room, a five-box code entry, friends with online dots and Invite, pending invites, recent matches. The lobby is a versus screen: two big team panels, who is in, ready state, nation picker, chat, and a share block (large code, Copy link, Share sheet, QR). A 3-2-1 count-in starts the match when both are ready.
4. **Pre-match:** both teams, kits, formation and the controls for the player's device. Enter to kick off.
5. **Match:** the existing canvas, full viewport, with a broadcast-style scoreboard, a pause button and a pause menu (resume, controls, settings, quit with confirm). Online matches never pause for the opponent.
6. **Full time:** score banner, stats bars, cards, then Continue, Rematch, Report. In knockouts, extra time and penalties keep their own banners.
7. **Settings:** a full screen with tabs for keyboard, controller, touch, gameplay (CPU difficulty) and audio.
8. **Auth and profile:** the same shell and glass panels. Sign up is one wizard (email, code, password, name) with inline checks, show-password and a live name check.

## Friction fixes (checked off as built)

- One-tap room creation; the code, link, share sheet and QR appear immediately.
- The joiner pastes or types the code into five boxes; a shared link joins with no extra step.
- Both players see joins, leaves, nation changes and readiness the moment they happen (toast plus lobby state).
- Leaving a lobby or a match tells the other player at once with a clear dialog, and the server status updates (done on the server; closing the tab also reports it).
- Invites and presence are global: bell, toast, join button on any screen.
- Quit, report and delete use real dialogs. Errors show where they happen, with a retry.
- Sign-in returns the player to where they were; the email is remembered.
- A first-time controls card before the first match; the footer prompts match the active device.
- Phones: landscape match with a rotate prompt in portrait, `100dvh`, safe-area insets, larger touch targets, no pinch zoom, optional fullscreen.

## Status (3 Oct 2026)

All seven steps are built, audited at desktop (1440x900), phone portrait (390x844) and phone landscape (844x390), covered by the browser tests, deployed and checked live. Landscape-phone fixes from the audit: a `desk` Tailwind variant (wide AND tall) switches the top nav/footer hints, short screens use the bottom tab bar in a compact row, touch devices default to touch prompts and hide the name plates (the joystick sits there), and the intro/result overlays use `m-auto` so they scroll instead of clipping. Invites are toasted even when they arrive before the first poll; a closing tab frees a waiting lobby; old `/?room=CODE` links redirect to `/online?join=CODE`.

## Order of work

1. Foundation: theme, shell, spatial navigation, dialogs, flags, sounds.
2. Home, auth, profile.
3. World Cup screens.
4. Online hub, lobby, notifications, leave handling.
5. Match screen, pause menu, full time, mobile layout.
6. Settings and practice.
7. Audit on desktop and phone sizes, fix, update the browser tests, deploy, check live.
