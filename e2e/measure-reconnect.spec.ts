import { appendFileSync, mkdirSync } from 'node:fs';
import { join } from 'node:path';

import { expect, test } from '@playwright/test';

const API_URL = (process.env.MEASURE_API_URL ?? 'https://docket.api.serverpod.space').replace(/\/$/, '');
const DIR = join(__dirname, '..', 'docs', 'measurements');
mkdirSync(DIR, { recursive: true });

test('network back to a fresh view on the phone, 5 runs', async ({ browser, request }) => {
  const start = await (await request.post(`${API_URL}/sandbox/start`, { data: {} })).json();
  const info = await (await request.post(`${API_URL}/publicClinic/getClinic`, { data: { slug: start.clinicSlug } })).json();
  const line = info.lines[0].id;
  await request.post(`${API_URL}/sandbox/addDemoWalkIns`, { data: { sandboxToken: start.sandboxToken, lineId: line, count: 8 } });
  const joined = await (
    await request.post(`${API_URL}/publicClinic/join`, {
      data: { request: { clinicSlug: start.clinicSlug, lineId: line, displayName: 'Net', smsConsent: false } },
    })
  ).json();
  const desk = await (await request.post(`${API_URL}/desk/getView`, { data: { clinicId: start.clinicId, sandboxToken: start.sandboxToken } })).json();
  const room = desk.rooms.find((r: { lineId: string }) => r.lineId === line);
  const deviceId = crypto.randomUUID();

  const context = await browser.newContext({ viewport: { width: 390, height: 844 }, isMobile: true });
  const page = await context.newPage();
  await page.goto(`/t/${joined.ticketToken}`);
  const placeholder = page.locator('flt-semantics-placeholder');
  await placeholder.waitFor({ state: 'attached', timeout: 30_000 });
  await placeholder.evaluate((node) => (node as HTMLElement).click());
  const spoken = page.locator('flt-semantics-host');
  await expect(spoken).toContainText(/9th in line/, { timeout: 30_000 });

  const results: number[] = [];
  for (let run = 0; run < 5; run++) {
    await context.setOffline(true);
    await page.waitForTimeout(8_000);
    const before = (await spoken.textContent()) ?? '';
    const call = await request.post(`${API_URL}/desk/act`, {
      data: {
        action: {
          __className__: 'CallNextAction',
          actionId: crypto.randomUUID(),
          deviceId,
          seq: run + 1,
          issuedAtLocal: new Date().toISOString(),
          roomId: room.id,
        },
        sandboxToken: start.sandboxToken,
      },
    });
    expect(call.ok()).toBe(true);
    const expected = `${8 - run}th in line`.replace(/^1th/, '1st').replace(/^2th/, '2nd').replace(/^3th/, '3rd');
    const back = Date.now();
    await context.setOffline(false);
    await expect(spoken).toContainText(expected, { timeout: 60_000 });
    results.push(Date.now() - back);
    expect(before).not.toContain(expected);
  }
  await context.close();
  const stamp = new Date().toISOString();
  appendFileSync(
    join(DIR, 'reconnect.tsv'),
    results.map((ms, i) => `${stamp}\trun ${i + 1}\toffline 8 s\t${ms} ms`).join('\n') + '\n',
  );
  console.log(`network back to fresh view: ${results.join(', ')} ms`);
});
