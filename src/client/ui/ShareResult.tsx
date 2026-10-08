import { useState } from 'react';
import { Share2 } from 'lucide-react';
import { toast } from 'react-hot-toast';
import type { TeamData } from '@/client/game/teams';
import type { HudState } from '@/client/game/types';
import { Btn } from './controls';
import { shareResultCard, type CardInfo } from './resultCard';

/** Everything the card needs, from a finished match. `note` is e.g. a shootout line. */
export function cardFor(home: TeamData, away: TeamData, hud: HudState, label: string, headline: string, note?: string): CardInfo {
  return {
    headline,
    label,
    homeName: home.name,
    awayName: away.name,
    homeScore: hud.homeScore,
    awayScore: hud.awayScore,
    homeColor: home.color,
    awayColor: away.color,
    note,
    possession: hud.stats?.possession,
    shots: hud.stats?.shots,
  };
}

/** "Share result": the phone's share sheet with a picture of the score, or a download on a computer. */
export function ShareResultBtn({ info }: { info: CardInfo }) {
  const [busy, setBusy] = useState(false);
  return (
    <Btn
      size="lg"
      disabled={busy}
      onClick={async () => {
        setBusy(true);
        try {
          const how = await shareResultCard(info);
          if (how === 'saved') toast.success('Result image saved');
          if (how === 'linked') toast.success('Link copied. Paste it in a chat to show the score.');
        } catch (e) {
          toast.error((e as Error).message);
        } finally {
          setBusy(false);
        }
      }}
    >
      <Share2 size={18} /> Share result
    </Btn>
  );
}
