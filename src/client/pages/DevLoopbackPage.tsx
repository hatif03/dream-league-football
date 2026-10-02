// Dev-only harness (route /dev/loopback): a host engine and a guest view in one
// page, wired together in memory with a fake network delay. Used by
// scripts/e2e-loopback.mjs to exercise the two-human code without WebRTC.

import { useEffect, useRef, useState } from 'react';
import { PitchKickGame, CANVAS_W, CANVAS_H, type HudState } from '@/client/game/engine';
import { GuestView } from '@/client/game/guestView';
import { TEAMS } from '@/client/game/teams';

const EMPTY: HudState = {
  homeScore: 0, awayScore: 0, clock: 0, message: '', possession: 'none',
  homePlayer: null, awayPlayer: null, charge: null, finished: false,
};

export default function DevLoopbackPage() {
  const hostCanvas = useRef<HTMLCanvasElement>(null);
  const guestCanvas = useRef<HTMLCanvasElement>(null);
  const [hostHud, setHostHud] = useState(EMPTY);
  const [guestHud, setGuestHud] = useState(EMPTY);

  useEffect(() => {
    const latency = Number(new URLSearchParams(location.search).get('latency') ?? 40);
    const hostTeam = TEAMS.find((t) => t.name === 'Brazil') ?? TEAMS[0];
    const guestTeam = TEAMS.find((t) => t.name === 'Germany') ?? TEAMS[1];
    const host = new PitchKickGame(hostCanvas.current!, setHostHud, hostTeam, guestTeam, { guestSeat: true });
    const guest = new GuestView(guestCanvas.current!, setGuestHud, hostTeam, guestTeam, (m) => {
      const copy = JSON.parse(JSON.stringify(m));
      setTimeout(() => host.guestInput(copy.held, copy.pressed, copy.released), latency);
    });
    host.setSnapshotSink((s) => {
      const copy = JSON.parse(JSON.stringify(s));
      setTimeout(() => guest.pushSnapshot(copy), latency);
    });
    // Keyboard goes to the guest only; the host is driven from the test through the API.
    host.suspendInput(true);
    host.start();
    host.enableBackgroundTicks();
    guest.start();
    (window as any).__loop = { host, guest };
    return () => {
      host.stop();
      guest.stop();
    };
  }, []);

  return (
    <div className="p-2 grid gap-2 bg-night-950 min-h-full">
      <div className="text-white text-xs">
        host {hostHud.homeScore}-{hostHud.awayScore} {hostHud.clock}s | guest view {guestHud.homeScore}-{guestHud.awayScore} {guestHud.clock}s
      </div>
      <canvas ref={hostCanvas} width={CANVAS_W} height={CANVAS_H} className="w-full border border-night-700" data-testid="host" />
      <canvas ref={guestCanvas} width={CANVAS_W} height={CANVAS_H} className="w-full border border-night-700" data-testid="guest" />
    </div>
  );
}
