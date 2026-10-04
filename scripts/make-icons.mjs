#!/usr/bin/env node
// Renders the app icons (PNG) into src/client/public with the installed Chrome. Run once; the PNGs are committed.
import { chromium } from 'playwright-core';
import { existsSync, mkdirSync } from 'node:fs';

const OUT = 'src/client/public';
mkdirSync(OUT, { recursive: true });
const exe = ['C:/Program Files/Google/Chrome/Application/chrome.exe', 'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe'].find(existsSync);
const browser = await chromium.launch({ executablePath: exe, headless: true });

const ball = (pad) => `
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" width="512" height="512">
  <defs><linearGradient id="g" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#0b0933"/><stop offset="1" stop-color="#3b2fc0"/></linearGradient></defs>
  <rect width="512" height="512" fill="url(#g)"/>
  <g transform="translate(256 256) scale(${1 - pad}) translate(-256 -256)">
    <circle cx="256" cy="256" r="170" fill="#fff"/>
    <path d="M256 160l60 44-23 70h-74l-23-70z" fill="#0b0933"/>
    <path d="M256 160V96M316 204l58-20M293 274l36 52M219 274l-36 52M196 204l-58-20" stroke="#0b0933" stroke-width="14" fill="none" stroke-linecap="round"/>
    <circle cx="256" cy="256" r="170" fill="none" stroke="#28e4ff" stroke-width="16"/>
  </g>
</svg>`;

async function render(name, size, pad) {
  const page = await browser.newPage({ viewport: { width: size, height: size } });
  await page.setContent(`<style>html,body{margin:0}svg{width:${size}px;height:${size}px;display:block}</style>${ball(pad)}`);
  await page.screenshot({ path: `${OUT}/${name}`, omitBackground: false });
  await page.close();
}
await render('icon-192.png', 192, 0.08);
await render('icon-512.png', 512, 0.08);
await render('icon-maskable-512.png', 512, 0.22); // extra margin so round masks do not crop the ball
await render('apple-touch-icon.png', 180, 0.1);
await browser.close();
console.log('icons written to', OUT);
