#!/usr/bin/env node
// The relay must refuse a connection that cannot prove it is in the match.
//   WS=ws://localhost:8082 node scripts/smoke-relay.mjs      (or wss://football.serverpod.space)
import assert from 'node:assert/strict';

const WS = process.env.WS ?? 'ws://localhost:8082';
const id = '01a0ff35-0000-7000-8000-000000000000';

function attempt(first) {
  return new Promise((resolve, reject) => {
    const ws = new WebSocket(`${WS}/relay/${id}`);
    const t = setTimeout(() => reject(new Error('the relay never closed the socket')), 15000);
    ws.onopen = () => first !== null && ws.send(first);
    ws.onclose = (e) => {
      clearTimeout(t);
      resolve(e.code);
    };
  });
}

assert.equal(await attempt(JSON.stringify({ token: 'not-a-token' })), 4003, 'a bad token is refused');
assert.equal(await attempt('garbage'), 4003, 'a malformed first frame is refused');
assert.equal(await attempt(null), 4008, 'a silent client times out');
console.log('relay refuses strangers ok');
