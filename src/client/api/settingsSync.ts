// Settings follow the player: the keys, controller and touch layouts, difficulty, match length,
// formation, sound and tutorial flag are kept in localStorage as before and copied to the account
// (UserProfile.settings) so a new browser or phone starts with them.
import { call, getAuth } from './http';

const KEYS = [
  'wc2026.keybindings',
  'wc2026.padbindings',
  'wc2026.touch',
  'wc2026.difficulty',
  'wc2026.matchSecs',
  'wc2026.replays',
  'wc2026.commentary',
  'wc2026.formation',
  'wc2026.sound',
  'wc2026.tutorialDone',
];
/** Fired by anything that just changed a saved setting. */
export const SETTINGS_CHANGED = 'wc2026:settings';
/** Fired after the account's settings were written to this browser, so the UI can reload them. */
export const SETTINGS_REMOTE = 'wc2026:settings-remote';

function collect(): Record<string, string> {
  const out: Record<string, string> = {};
  for (const k of KEYS) {
    try {
      const v = localStorage.getItem(k);
      if (v !== null) out[k] = v;
    } catch {
      /* storage unavailable */
    }
  }
  return out;
}

let timer = 0;
export function scheduleSettingsSave() {
  if (!getAuth()) return;
  window.clearTimeout(timer);
  timer = window.setTimeout(() => {
    call('profile/saveSettings', { json: JSON.stringify(collect()) }).catch(() => {
      /* the next change tries again */
    });
  }, 1500);
}
if (typeof window !== 'undefined') window.addEventListener(SETTINGS_CHANGED, scheduleSettingsSave);

let adoptedFor = '';
/**
 * On sign-in: if the account has saved settings this browser takes them; if it has none yet but this
 * browser has customised something, they are uploaded.
 */
export function adoptAccountSettings(userId: string, json?: string | null) {
  if (adoptedFor === userId) return;
  adoptedFor = userId;
  if (json) {
    try {
      const saved = JSON.parse(json) as Record<string, unknown>;
      let changed = false;
      for (const k of KEYS) {
        const v = saved[k];
        if (typeof v === 'string' && localStorage.getItem(k) !== v) {
          localStorage.setItem(k, v);
          changed = true;
        }
      }
      if (changed) window.dispatchEvent(new Event(SETTINGS_REMOTE));
    } catch {
      /* ignore a damaged copy */
    }
  } else if (Object.keys(collect()).length > 0) {
    scheduleSettingsSave();
  }
}
