import { writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';

import { request } from '@playwright/test';

export const FIXTURE_FILE = join(tmpdir(), 'docket-app-sweep-fixture.json');

/**
 * One sandbox and one ticket for the whole sweep, made through the real API
 * once, so parallel workers don't each start a sandbox and run into the
 * per-address limit on sandbox starts.
 */
export default async function globalSetup(): Promise<void> {
  const api = (process.env.APP_API_URL ?? 'http://localhost:8080').replace(/\/$/, '');
  const context = await request.newContext();
  async function call<T>(endpoint: string, method: string, args: object): Promise<T> {
    const response = await context.post(`${api}/${endpoint}/${method}`, { data: args });
    const body = await response.text();
    if (!response.ok()) throw new Error(`${endpoint}.${method} ${response.status()}: ${body}`);
    return JSON.parse(body) as T;
  }
  const sandbox = await call<Record<string, string>>('sandbox', 'start', {});
  const info = await call<{ lines: Array<{ id: string }> }>('publicClinic', 'getClinic', {
    slug: sandbox.clinicSlug,
  });
  await call('sandbox', 'addDemoWalkIns', {
    sandboxToken: sandbox.sandboxToken,
    lineId: info.lines[0].id,
    count: 3,
  });
  const joined = await call<{ ticketToken: string }>('publicClinic', 'join', {
    request: { clinicSlug: sandbox.clinicSlug, lineId: info.lines[0].id, displayName: 'Sweep', smsConsent: false },
  });
  writeFileSync(
    FIXTURE_FILE,
    JSON.stringify({
      sandboxRaw: JSON.stringify(sandbox),
      slug: sandbox.clinicSlug,
      ticketToken: joined.ticketToken,
      boardToken: new URL(sandbox.boardUrl).pathname.split('/').pop(),
    }),
  );
  await context.dispose();
}
