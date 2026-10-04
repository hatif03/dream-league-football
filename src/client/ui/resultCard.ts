// A shareable image of a finished match, drawn on a canvas (nothing is uploaded anywhere).

export interface CardInfo {
  headline: string; // Victory, Defeat, Draw
  label: string; // "World Cup · Group C · Matchday 1"
  homeName: string;
  awayName: string;
  homeScore: number;
  awayScore: number;
  homeColor: string;
  awayColor: string;
  /** "Brazil win 4-3 on penalties", when it went to a shootout. */
  note?: string;
  possession?: [number, number];
  shots?: [number, number];
}

const W = 1200;
const H = 630;

function fit(ctx: CanvasRenderingContext2D, text: string, maxW: number, font: (px: number) => string, start: number): number {
  let px = start;
  ctx.font = font(px);
  while (ctx.measureText(text).width > maxW && px > 24) {
    px -= 4;
    ctx.font = font(px);
  }
  return px;
}

export async function makeResultCard(i: CardInfo): Promise<Blob> {
  try {
    await document.fonts.load('italic 800 80px "Barlow Condensed"');
  } catch {
    /* fall back to the system font */
  }
  const c = document.createElement('canvas');
  c.width = W;
  c.height = H;
  const ctx = c.getContext('2d')!;
  const disp = (px: number) => `italic 800 ${px}px "Barlow Condensed", "Arial Narrow", sans-serif`;
  const body = (px: number) => `600 ${px}px Barlow, system-ui, sans-serif`;

  const g = ctx.createLinearGradient(0, 0, W, H);
  g.addColorStop(0, '#0b0933');
  g.addColorStop(1, '#2a2397');
  ctx.fillStyle = g;
  ctx.fillRect(0, 0, W, H);
  ctx.save();
  ctx.globalAlpha = 0.07;
  ctx.strokeStyle = '#fff';
  ctx.lineWidth = 2;
  for (let x = -H; x < W; x += 46) {
    ctx.beginPath();
    ctx.moveTo(x, H);
    ctx.lineTo(x + H, 0);
    ctx.stroke();
  }
  ctx.restore();

  // team colour bars
  ctx.fillStyle = i.homeColor;
  ctx.fillRect(0, 0, 18, H);
  ctx.fillStyle = i.awayColor;
  ctx.fillRect(W - 18, 0, 18, H);

  ctx.textAlign = 'center';
  ctx.fillStyle = '#28e4ff';
  ctx.font = disp(34);
  ctx.fillText('DREAM LEAGUE FOOTBALL', W / 2, 70);

  ctx.fillStyle = '#fff';
  ctx.font = disp(120);
  ctx.fillText(i.headline.toUpperCase(), W / 2, 200);

  // score
  ctx.font = disp(210);
  ctx.fillText(`${i.homeScore}`, W / 2 - 150, 410);
  ctx.fillStyle = '#7a75b8';
  ctx.fillText('–', W / 2, 400);
  ctx.fillStyle = '#fff';
  ctx.fillText(`${i.awayScore}`, W / 2 + 150, 410);

  // team names
  ctx.fillStyle = '#fff';
  fit(ctx, i.homeName.toUpperCase(), 360, disp, 70);
  ctx.fillText(i.homeName.toUpperCase(), 230, 330);
  fit(ctx, i.awayName.toUpperCase(), 360, disp, 70);
  ctx.fillText(i.awayName.toUpperCase(), W - 230, 330);

  ctx.fillStyle = '#bcb8f0';
  ctx.font = body(30);
  ctx.fillText(i.label, W / 2, 470);
  if (i.note) {
    ctx.fillStyle = '#ffc83a';
    ctx.fillText(i.note, W / 2, 510);
  }
  if (i.possession && i.shots) {
    ctx.fillStyle = '#dcd9ff';
    ctx.font = body(26);
    ctx.fillText(`Possession ${i.possession[0]}–${i.possession[1]}%   ·   Shots ${i.shots[0]}–${i.shots[1]}`, W / 2, i.note ? 552 : 530);
  }
  ctx.fillStyle = '#7a75b8';
  ctx.font = body(24);
  ctx.fillText('football.serverpod.space', W / 2, 604);

  return new Promise((resolve, reject) => c.toBlob((b) => (b ? resolve(b) : reject(new Error('Could not draw the card.'))), 'image/png'));
}

/** Share the card with the phone's share sheet, or download it. Returns what happened. */
export async function shareResultCard(i: CardInfo): Promise<'shared' | 'saved'> {
  const blob = await makeResultCard(i);
  const file = new File([blob], 'dream-league-football-result.png', { type: 'image/png' });
  const text = `${i.homeName} ${i.homeScore}–${i.awayScore} ${i.awayName} on Dream League Football`;
  const touch = window.matchMedia('(pointer: coarse)').matches; // phones get the share sheet, computers a download
  if (touch && navigator.canShare?.({ files: [file] })) {
    try {
      await navigator.share({ files: [file], title: 'Dream League Football', text });
      return 'shared';
    } catch (e) {
      if ((e as Error).name === 'AbortError') return 'shared';
    }
  }
  const url = URL.createObjectURL(blob);
  const a = document.createElement('a');
  a.href = url;
  a.download = file.name;
  a.click();
  setTimeout(() => URL.revokeObjectURL(url), 5000);
  return 'saved';
}
