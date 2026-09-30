import { useEffect, useRef } from 'react';
import { DEFAULT_BINDINGS } from '@/client/game/keybindings';
import { TOUCH_ACTIONS, type KeySink, type TouchLayout } from '@/client/game/inputDevices';

const R = 64; // joystick radius in px
const DEAD = 0.3;

/** Keeps receiving a finger's events after it slides off the button. Best effort. */
function capture(el: HTMLElement, id: number) {
  try {
    el.setPointerCapture(id);
  } catch {
    /* an unknown pointer id; the press still counts */
  }
}

const label = (action: string) => TOUCH_ACTIONS.find((a) => a.action === action)?.label ?? action;

/** On-screen thumb stick and buttons. They press the same canonical keys the keyboard does. */
export function TouchControls({ sink, layout }: { sink: () => KeySink | null; layout: TouchLayout }) {
  const down = useRef(new Set<string>());
  const stick = useRef<{ id: number; cx: number; cy: number } | null>(null);
  const knob = useRef<HTMLDivElement>(null);

  const press = (code: string) => {
    if (down.current.has(code)) return;
    down.current.add(code);
    sink()?.pressKey(code);
  };
  const release = (code: string) => {
    if (!down.current.delete(code)) return;
    sink()?.releaseKey(code);
  };
  useEffect(() => {
    const held = down.current;
    return () => {
      for (const c of held) sink()?.releaseKey(c);
      held.clear();
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  const arrows = [DEFAULT_BINDINGS.moveUp, DEFAULT_BINDINGS.moveDown, DEFAULT_BINDINGS.moveLeft, DEFAULT_BINDINGS.moveRight];
  const moveStick = (e: React.PointerEvent) => {
    const s = stick.current;
    if (!s || e.pointerId !== s.id) return;
    let dx = e.clientX - s.cx;
    let dy = e.clientY - s.cy;
    const len = Math.hypot(dx, dy);
    if (len > R) {
      dx = (dx / len) * R;
      dy = (dy / len) * R;
    }
    if (knob.current) knob.current.style.transform = `translate(${dx}px, ${dy}px)`;
    const want = new Set<string>();
    if (Math.hypot(dx, dy) > R * DEAD) {
      if (dy < -R * DEAD) want.add(DEFAULT_BINDINGS.moveUp);
      if (dy > R * DEAD) want.add(DEFAULT_BINDINGS.moveDown);
      if (dx < -R * DEAD) want.add(DEFAULT_BINDINGS.moveLeft);
      if (dx > R * DEAD) want.add(DEFAULT_BINDINGS.moveRight);
    }
    for (const a of arrows) (want.has(a) ? press : release)(a);
  };
  const endStick = (e: React.PointerEvent) => {
    if (stick.current?.id !== e.pointerId) return;
    stick.current = null;
    if (knob.current) knob.current.style.transform = '';
    for (const a of arrows) release(a);
  };

  const btn = (slot: number, size: string) => {
    const action = layout[slot];
    const code = DEFAULT_BINDINGS[action];
    return (
      <button
        key={slot}
        type="button"
        aria-label={label(action)}
        onPointerDown={(e) => {
          e.preventDefault();
          capture(e.target as HTMLElement, e.pointerId);
          press(code);
        }}
        onPointerUp={() => release(code)}
        onPointerCancel={() => release(code)}
        onContextMenu={(e) => e.preventDefault()}
        className={`${size} rounded-full bg-night-900/70 ring-2 ring-volt-500/70 text-white font-heading uppercase text-[11px] tracking-wide active:bg-volt-500 active:text-night-950 select-none touch-none`}
      >
        {label(action)}
      </button>
    );
  };

  return (
    <div className="absolute inset-x-0 bottom-0 flex items-end justify-between p-3 pointer-events-none select-none touch-none">
      <div
        className="pointer-events-auto relative rounded-full bg-night-900/50 ring-2 ring-night-500/60 touch-none"
        style={{ width: R * 2, height: R * 2 }}
        onPointerDown={(e) => {
          const rect = e.currentTarget.getBoundingClientRect();
          stick.current = { id: e.pointerId, cx: rect.left + rect.width / 2, cy: rect.top + rect.height / 2 };
          capture(e.currentTarget, e.pointerId);
          moveStick(e);
        }}
        onPointerMove={moveStick}
        onPointerUp={endStick}
        onPointerCancel={endStick}
        aria-label="Move"
      >
        <div
          ref={knob}
          className="absolute left-1/2 top-1/2 -ml-6 -mt-6 h-12 w-12 rounded-full bg-volt-500/80 shadow-lg"
        />
      </div>

      <div className="pointer-events-auto flex flex-col items-end gap-2 touch-none">
        <div className="flex gap-2">{[btn(3, 'h-12 w-12'), btn(2, 'h-12 w-12')]}</div>
        <div className="flex gap-2">{[btn(1, 'h-14 w-14'), btn(0, 'h-16 w-16')]}</div>
        <div className="flex gap-2">{[btn(6, 'h-10 w-14'), btn(5, 'h-10 w-14'), btn(4, 'h-10 w-14')]}</div>
      </div>
    </div>
  );
}
