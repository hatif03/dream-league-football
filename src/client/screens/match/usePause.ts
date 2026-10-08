import { useEffect, useRef } from 'react';

/** Esc and the controller's Start button toggle the pause menu while a match is on (P is a game key in the WASD layout). */
export function usePauseKeys(active: boolean, toggle: () => void) {
  const fn = useRef(toggle);
  fn.current = toggle;
  useEffect(() => {
    if (!active) return;
    const onKey = (e: KeyboardEvent) => {
      if (e.code === 'Escape') {
        if (e.repeat) return;
        e.preventDefault();
        fn.current();
      }
    };
    window.addEventListener('keydown', onKey);
    let raf = 0;
    let was = false;
    const poll = () => {
      const pad = [...(navigator.getGamepads?.() ?? [])].find((g) => g && g.connected);
      const now = !!pad?.buttons[9]?.pressed;
      if (now && !was) fn.current();
      was = now;
      raf = requestAnimationFrame(poll);
    };
    raf = requestAnimationFrame(poll);
    return () => {
      window.removeEventListener('keydown', onKey);
      cancelAnimationFrame(raf);
    };
  }, [active]);
}
