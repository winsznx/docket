import { appendFileSync, mkdirSync } from 'node:fs';
import { join } from 'node:path';

import { expect, test } from '@playwright/test';

const API_URL = (process.env.MEASURE_API_URL ?? 'https://docket.api.serverpod.space').replace(/\/$/, '');
const DIR = join(__dirname, '..', 'docs', 'measurements');
mkdirSync(DIR, { recursive: true });

// Chrome DevTools' Fast 3G profile.
const FAST_3G = { offline: false, latency: 562.5, downloadThroughput: 180_000, uploadThroughput: 84_375 };

test('first paint of a ticket on Fast 3G, 5 cold runs', async ({ browser, request }) => {
  const start = await (await request.post(`${API_URL}/sandbox/start`, { data: {} })).json();
  const info = await (await request.post(`${API_URL}/publicClinic/getClinic`, { data: { slug: start.clinicSlug } })).json();
  const joined = await (
    await request.post(`${API_URL}/publicClinic/join`, {
      data: { request: { clinicSlug: start.clinicSlug, lineId: info.lines[0].id, displayName: 'Paint', smsConsent: false } },
    })
  ).json();
  const results: number[] = [];
  for (let run = 0; run < 5; run++) {
    const context = await browser.newContext({ viewport: { width: 390, height: 844 }, isMobile: true });
    const page = await context.newPage();
    const cdp = await context.newCDPSession(page);
    await cdp.send('Network.enable');
    await cdp.send('Network.setCacheDisabled', { cacheDisabled: true });
    await cdp.send('Network.emulateNetworkConditions', FAST_3G);
    const begun = Date.now();
    await page.goto(`/t/${joined.ticketToken}`, { waitUntil: 'commit' });
    await expect(page.locator('#fp-label')).toHaveText(/C-\d{3}/, { timeout: 30_000 });
    results.push(Date.now() - begun);
    await context.close();
  }
  const stamp = new Date().toISOString();
  appendFileSync(
    join(DIR, 'first-paint.tsv'),
    results.map((ms, i) => `${stamp}\t${test.info().project.name}\trun ${i + 1}\tfast-3g\t${ms} ms`).join('\n') + '\n',
  );
  console.log(`first paint on Fast 3G: ${results.join(', ')} ms`);
});
