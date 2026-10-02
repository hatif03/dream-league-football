import { useEffect } from 'react';
import { noteDevice } from '@/client/game/inputDevices';
import { sfx } from './sfx';

// Console-style menu navigation: arrow keys, D-pad and the left stick move focus in the
// direction pressed, Enter/A confirms, Esc/B goes back, Q/E and LB/RB switch tabs. Works on
// whatever is on screen (the top dialog if there is one), so screens need no registration.

const FOCUSABLE =
  'button:not([disabled]), a[href], input:not([disabled]):not([type=hidden]), select:not([disabled]), textarea:not([disabled]), [data-nav]';

type Dir = 'left' | 'right' | 'up' | 'down';

function scope(): HTMLElement {
  const dialogs = document.querySelectorAll<HTMLElement>('[data-nav-scope]');
  return dialogs.length ? dialogs[dialogs.length - 1] : document.body;
}

function focusables(root: HTMLElement): HTMLElement[] {
  return [...root.querySelectorAll<HTMLElement>(FOCUSABLE)].filter((el) => {
    if (el.closest('[data-nav-skip]') || el.getAttribute('tabindex') === '-1') return false;
    const r = el.getBoundingClientRect();
    if (r.width < 4 || r.height < 4) return false;
    const cs = getComputedStyle(el);
    return cs.visibility !== 'hidden' && cs.display !== 'none';
  });
}

/** Moves focus to the best candidate in `dir`: near on the axis, little sideways drift. */
export function moveFocus(dir: Dir): boolean {
  const root = scope();
  const items = focusables(root);
  if (!items.length) return false;
  const cur = document.activeElement as HTMLElement | null;
  if (!cur || cur === document.body || !root.contains(cur) || !items.includes(cur)) {
    (items.find((e) => e.hasAttribute('data-autofocus')) ?? items[0]).focus();
    sfx.move();
    return true;
  }
  const a = cur.getBoundingClientRect();
  const ac = { x: a.left + a.width / 2, y: a.top + a.height / 2 };
  let best: HTMLElement | null = null;
  let bestScore = Infinity;
  for (const el of items) {
    if (el === cur) continue;
    const b = el.getBoundingClientRect();
    const bc = { x: b.left + b.width / 2, y: b.top + b.height / 2 };
    const dx = bc.x - ac.x;
    const dy = bc.y - ac.y;
    const along = dir === 'left' ? -dx : dir === 'right' ? dx : dir === 'up' ? -dy : dy;
    const across = dir === 'left' || dir === 'right' ? Math.abs(dy) : Math.abs(dx);
    // Must lie ahead (allow touching edges), and prefer a straight line over a near diagonal.
    const aheadEdge = dir === 'left' ? a.left - b.right : dir === 'right' ? b.left - a.right : dir === 'up' ? a.top - b.bottom : b.top - a.bottom;
    if (along <= 2 || aheadEdge < -Math.min(a.width, a.height) * 0.6) continue;
    const score = along + across * 2.4;
    if (score < bestScore) {
      bestScore = score;
      best = el;
    }
  }
  if (!best) return false;
  best.focus();
  sfx.move();
  return true;
}

function goBack() {
  const root = scope();
  const back = root.querySelector<HTMLElement>('[data-back]');
  if (back) {
    back.click();
    return;
  }
  if (root === document.body && location.pathname !== '/') history.back();
}

const isTextField = (el: Element | null) =>
  !!el && (el.tagName === 'TEXTAREA' || (el.tagName === 'INPUT' && !['checkbox', 'radio', 'button', 'submit'].includes((el as HTMLInputElement).type)));

export function MenuNav({ enabled }: { enabled: boolean }) {
  useEffect(() => {
    if (!enabled) return;

    const onKey = (e: KeyboardEvent) => {
      if (e.ctrlKey || e.metaKey || e.altKey) return;
      const t = document.activeElement;
      const typing = isTextField(t);
      const dir: Dir | null =
        e.key === 'ArrowLeft' ? 'left' : e.key === 'ArrowRight' ? 'right' : e.key === 'ArrowUp' ? 'up' : e.key === 'ArrowDown' ? 'down' : null;
      if (dir) {
        // In a text field only up/down leave it; left/right edit the text.
        if (typing && (dir === 'left' || dir === 'right')) return;
        if (t instanceof HTMLSelectElement && (dir === 'up' || dir === 'down')) return;
        if (t instanceof HTMLInputElement && t.type === 'range') return;
        e.preventDefault();
        moveFocus(dir);
        return;
      }
      if (e.key === 'Escape' || (e.key === 'Backspace' && !typing)) {
        if (e.key === 'Backspace') e.preventDefault();
        goBack();
        return;
      }
      if (!typing && (e.key === 'q' || e.key === 'Q' || e.key === 'e' || e.key === 'E')) {
        window.dispatchEvent(new CustomEvent('menu:tab', { detail: e.key.toLowerCase() === 'q' ? -1 : 1 }));
      }
    };

    // A mouse over a tile or button takes the focus, like a console cursor.
    const onOver = (e: PointerEvent) => {
      if (e.pointerType !== 'mouse') return;
      const el = (e.target as HTMLElement | null)?.closest<HTMLElement>('.tile, .btn');
      if (el && document.activeElement !== el && !isTextField(document.activeElement)) el.focus({ preventScroll: true });
    };
    const onClick = (e: MouseEvent) => {
      if ((e.target as HTMLElement | null)?.closest('.tile, .btn, [data-sfx]')) sfx.select();
    };
    const onFocusIn = () => noteDevice('keyboard');

    window.addEventListener('keydown', onKey);
    document.addEventListener('pointerover', onOver, { passive: true });
    document.addEventListener('click', onClick, true);
    document.addEventListener('focusin', onFocusIn);

    // Gamepad: edges from the D-pad / left stick with key-repeat, A confirms, B backs out.
    let raf = 0;
    let lastDir: Dir | null = null;
    let nextRepeat = 0;
    const was = new Set<number>();
    const poll = () => {
      const pad = [...(navigator.getGamepads?.() ?? [])].find((g) => g && g.connected);
      if (pad) {
        const x = pad.axes[0] ?? 0;
        const y = pad.axes[1] ?? 0;
        const b = (i: number) => !!pad.buttons[i]?.pressed;
        const d: Dir | null =
          b(14) || x < -0.6 ? 'left' : b(15) || x > 0.6 ? 'right' : b(12) || y < -0.6 ? 'up' : b(13) || y > 0.6 ? 'down' : null;
        const now = performance.now();
        if (d && (d !== lastDir || now >= nextRepeat)) {
          noteDevice('controller');
          moveFocus(d);
          nextRepeat = now + (d === lastDir ? 140 : 320);
        }
        lastDir = d;
        const edge = (i: number, fn: () => void) => {
          if (b(i)) {
            if (!was.has(i)) {
              was.add(i);
              noteDevice('controller');
              fn();
            }
          } else was.delete(i);
        };
        edge(0, () => (document.activeElement as HTMLElement | null)?.click());
        edge(1, goBack);
        edge(4, () => window.dispatchEvent(new CustomEvent('menu:tab', { detail: -1 })));
        edge(5, () => window.dispatchEvent(new CustomEvent('menu:tab', { detail: 1 })));
      }
      raf = requestAnimationFrame(poll);
    };
    raf = requestAnimationFrame(poll);

    return () => {
      window.removeEventListener('keydown', onKey);
      document.removeEventListener('pointerover', onOver);
      document.removeEventListener('click', onClick, true);
      document.removeEventListener('focusin', onFocusIn);
      cancelAnimationFrame(raf);
    };
  }, [enabled]);
  return null;
}
