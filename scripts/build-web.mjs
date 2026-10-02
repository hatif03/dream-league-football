#!/usr/bin/env node
// Builds the React app and copies it into the Serverpod server package, where the
// web server serves it (football/football_server/web/spa). Run before `scloud deploy`.
import { build } from 'vite';
import { cpSync, existsSync, mkdirSync, rmSync } from 'node:fs';
import { resolve } from 'node:path';

const root = resolve(import.meta.dirname, '..');
await build({ configFile: resolve(root, 'vite.config.ts') });

const dist = resolve(root, 'dist');
const dest = resolve(root, 'football/football_server/web/spa');
if (!existsSync(dist)) throw new Error('vite build produced no dist/');
rmSync(dest, { recursive: true, force: true });
mkdirSync(dest, { recursive: true });
cpSync(dist, dest, { recursive: true });
console.log(`copied ${dist} -> ${dest}`);
