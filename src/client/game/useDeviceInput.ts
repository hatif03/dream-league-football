import { useEffect, useRef } from 'react';
import { GamepadInput, type KeySink, type PadBindings } from './inputDevices';

/** Runs controller polling while a match is on screen; feeds the sink the engine or guest view. */
export function useDeviceInput(
  getSink: () => KeySink | null,
  active: boolean,
  suspended: boolean,
  pad: PadBindings,
) {
  const padRef = useRef(pad);
  padRef.current = pad;
  const sinkRef = useRef(getSink);
  sinkRef.current = getSink;
  const input = useRef<GamepadInput | null>(null);

  useEffect(() => {
    if (!active) return;
    const g = new GamepadInput(() => sinkRef.current(), () => padRef.current);
    input.current = g;
    g.start();
    return () => {
      g.stop();
      input.current = null;
    };
  }, [active]);

  useEffect(() => {
    input.current?.suspend(suspended);
  }, [suspended, active]);
}
