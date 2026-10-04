import { useEffect, useState } from 'react';
import { Download } from 'lucide-react';
import { Btn } from './controls';

interface InstallPromptEvent extends Event {
  prompt(): Promise<void>;
  userChoice: Promise<{ outcome: 'accepted' | 'dismissed' }>;
}

// Chrome and Edge offer installation through an event that fires once; keep it until the player asks.
let deferred: InstallPromptEvent | null = null;
const subs = new Set<() => void>();
if (typeof window !== 'undefined') {
  window.addEventListener('beforeinstallprompt', (e) => {
    e.preventDefault();
    deferred = e as InstallPromptEvent;
    subs.forEach((s) => s());
  });
  window.addEventListener('appinstalled', () => {
    deferred = null;
    subs.forEach((s) => s());
  });
}

const standalone = () => typeof window !== 'undefined' && (window.matchMedia('(display-mode: standalone)').matches || (navigator as unknown as { standalone?: boolean }).standalone === true);
const isIos = () => /iphone|ipad|ipod/i.test(navigator.userAgent);

/** "Install the app" for Settings: the install button where the browser supports it, instructions on iPhone. */
export function InstallCard() {
  const [, tick] = useState(0);
  useEffect(() => {
    const f = () => tick((n) => n + 1);
    subs.add(f);
    return () => void subs.delete(f);
  }, []);
  if (standalone()) return null;
  const canPrompt = deferred !== null;
  if (!canPrompt && !isIos()) return null;
  return (
    <div className="glass mb-4 flex flex-wrap items-center gap-3 p-4">
      <Download size={22} className="text-neon-400" aria-hidden="true" />
      <div className="min-w-0 flex-1">
        <div className="font-display text-xl font-bold uppercase text-white">Install the app</div>
        <p className="font-body text-sm text-mist-300">
          {canPrompt ? 'Add Dream League Football to your home screen. It opens full screen, like a game.' : 'On iPhone: tap the Share button, then "Add to Home Screen".'}
        </p>
      </div>
      {canPrompt && (
        <Btn
          variant="primary"
          onClick={async () => {
            await deferred?.prompt();
            await deferred?.userChoice;
            deferred = null;
            subs.forEach((s) => s());
          }}
        >
          Install
        </Btn>
      )}
    </div>
  );
}
