#!/usr/bin/env node
// Checks the shootout rules (shootoutWinner) against hand-worked sequences.
import { build } from 'esbuild';
import assert from 'node:assert/strict';
import { mkdtempSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join, resolve } from 'node:path';
import { pathToFileURL } from 'node:url';

const out = join(mkdtempSync(join(tmpdir(), 'so-')), 'so.mjs');
await build({ entryPoints: [resolve(import.meta.dirname, '../src/client/game/shootout.ts')], bundle: true, format: 'esm', platform: 'node', outfile: out, logLevel: 'error' });
const { shootoutWinner: w } = await import(pathToFileURL(out).href);

// "H1 A0" = home scored, away missed; sequence alternates home first.
const seq = (s) => s.split(' ').map((t, i) => ({ team: i % 2 === 0 ? 'home' : 'away', scored: t === '1' }));
assert.equal(w(seq('1 0 1 0 1 0')), 'home', 'three up with two kicks left each is decided: 3 > 0 + 2');
assert.equal(w(seq('1 0 1 0 1')), null, 'cannot be decided before the away side has had the chance');
assert.equal(w(seq('1 1 1 1 1 1 1 1 1 1')), null, '5-5 goes to sudden death');
assert.equal(w(seq('1 1 1 1 1 1 1 1 1 1 1 0')), 'home', 'sudden death: scored, then missed');
assert.equal(w(seq('1 1 1 1 1 1 1 1 1 1 0 1')), 'away', 'sudden death the other way');
assert.equal(w(seq('1 1 1 1 1 1 1 1 1 1 1 1')), null, 'sudden death continues while level');
assert.equal(w(seq('0 1 0 1 0 1 0 1 0')), 'away', 'away three up with one kick left each: 4 > 0 + 1 once decided');
assert.equal(w(seq('1 0 0 1 1 0 0 1 1 0')), 'home', 'normal five each, 3-2');
assert.equal(w(seq('1 1 0 0 1 1 0 0')), null, 'two each with one to go: open');
assert.equal(w([]), null);
console.log('shootout rules ok');
