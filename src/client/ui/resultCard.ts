// A shareable image of a finished match, drawn on a canvas. Signed-in players can also share a link to it
// (the picture is stored with Serverpod cloud storage and the link opens a preview page).

import { getAuth } from '@/client/api/http';
import { createSharedResult } from '@/client/api/duel';

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

/** The host that serves the /r/<id> preview pages (the web server, which is where the relay lives too). */
const WEB_BASE: string = import.meta.env.VITE_RELAY_URL
  ? import.meta.env.VITE_RELAY_URL.replace(/^ws/, 'http')
  : location.origin;

/** Uploads the card to Serverpod's cloud storage and returns its public page (with an Open Graph preview). */
async function publishCard(blob: Blob, i: CardInfo): Promise<string | null> {
  try {
    if (!getAuth()) return null;
    const bytes = new Uint8Array(await blob.arrayBuffer());
    let bin = '';
    for (let k = 0; k < bytes.length; k += 0x8000) bin += String.fromCharCode(...bytes.subarray(k, k + 0x8000));
    const title = `${i.homeName} ${i.homeScore}–${i.awayScore} ${i.awayName}`;
    const link = await createSharedResult(btoa(bin), title, [i.headline, i.label].filter(Boolean).join(' · ').slice(0, 150));
    return `${WEB_BASE}/r/${link.id}`;
  } catch {
    return null; // not signed in or offline: fall back to the picture itself
  }
}

/**
 * Share the result. Signed in, the picture is stored with Serverpod and a link to its preview page is
 * shared (a phone's share sheet, or the clipboard on a computer). Otherwise the picture itself is shared
 * or downloaded. Returns what happened.
 */
export async function shareResultCard(i: CardInfo): Promise<'shared' | 'saved' | 'linked'> {
  const blob = await makeResultCard(i);
  const text = `${i.homeName} ${i.homeScore}–${i.awayScore} ${i.awayName} on Dream League Football`;
  const touch = window.matchMedia('(pointer: coarse)').matches; // phones get the share sheet, computers a link or download
  const url = await publishCard(blob, i);
  if (url) {
    if (touch && navigator.share) {
      try {
        await navigator.share({ title: 'Dream League Football', text, url });
        return 'shared';
      } catch (e) {
        if ((e as Error).name === 'AbortError') return 'shared';
      }
    }
    try {
      await navigator.clipboard.writeText(url);
      return 'linked';
    } catch {
      /* clipboard blocked: fall through to the picture */
    }
  }
  const file = new File([blob], 'dream-league-football-result.png', { type: 'image/png' });
  if (touch && navigator.canShare?.({ files: [file] })) {
    try {
      await navigator.share({ files: [file], title: 'Dream League Football', text });
      return 'shared';
    } catch (e) {
      if ((e as Error).name === 'AbortError') return 'shared';
    }
  }
  const obj = URL.createObjectURL(blob);
  const a = document.createElement('a');
  a.href = obj;
  a.download = file.name;
  a.click();
  setTimeout(() => URL.revokeObjectURL(obj), 5000);
  return 'saved';
}
