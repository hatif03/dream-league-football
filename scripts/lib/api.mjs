// Shared helpers for the smoke tests against a locally running Serverpod (dev mode).
// Dev mode prints email verification codes to the server log, so this reads them
// from SERVER_LOG.
import { readFileSync } from 'node:fs';
import assert from 'node:assert/strict';

const BASE = process.env.API ?? 'http://localhost:8080';
const LOG = process.env.SERVER_LOG;
if (!LOG) throw new Error('set SERVER_LOG to the server stdout log file');

export async function call(path, body = {}, jwt) {
  const res = await fetch(`${BASE}/${path}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json', ...(jwt ? { Authorization: `Bearer ${jwt}` } : {}) },
    body: JSON.stringify(body),
  });
  const text = await res.text();
  const data = text ? JSON.parse(text) : null;
  if (!res.ok) {
    const err = new Error(data?.data?.message ?? `${res.status} ${text}`);
    err.status = res.status;
    throw err;
  }
  return data;
}

export async function register(email, password = 'Passw0rd!x') {
  const id = await call('emailIdp/startRegistration', { email });
  await new Promise((r) => setTimeout(r, 300));
  const log = readFileSync(LOG, 'utf8');
  const matches = [...log.matchAll(new RegExp(`Registration code for ${email}: <(\\d+)>`, 'g'))];
  const code = matches.at(-1)?.[1];
  assert.ok(code, 'verification code not found in server log');
  const token = await call('emailIdp/verifyRegistrationCode', { accountRequestId: id, verificationCode: code });
  const auth = await call('emailIdp/finishRegistration', { registrationToken: token, password });
  return auth;
}



