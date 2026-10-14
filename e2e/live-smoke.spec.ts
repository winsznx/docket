import { mkdirSync, appendFileSync } from 'node:fs';
import { join } from 'node:path';

import { expect, test } from '@playwright/test';

import { button, enableSemantics, openSandboxDesk, said } from './desk-helpers';

const API_URL = (process.env.LIVE_API_URL ?? 'https://docket.api.serverpod.space').replace(/\/$/, '');
const SCREENS = join(__dirname, 'screens', 'live');
const LOG = join(__dirname, 'screens', 'live', 'latency.log');
mkdirSync(SCREENS, { recursive: true });

test('the home page says what Docket does', async ({ page }) => {
  await page.goto('/');
  await expect(page.getByRole('heading', { level: 1 })).toHaveText('Wait anywhere.');
  await expect(page.getByRole('link', { name: 'Try a live clinic' }).first()).toBeVisible();
  await page.screenshot({ path: join(SCREENS, 'home.png') });
});

test('the API answers its liveness probe', async ({ request }) => {
  const response = await request.get(`${API_URL}/livez`);
  expect(response.status()).toBe(200);
});

test('a stranger goes from /try to a called phone without an account', async ({ browser }) => {
  const deskContext = await browser.newContext({ viewport: { width: 1280, height: 800 } });
  const desk = await deskContext.newPage();
  const sandbox = await openSandboxDesk(desk);

  const phoneContext = await browser.newContext({
    viewport: { width: 390, height: 844 },
    deviceScaleFactor: 2,
    isMobile: true,
    hasTouch: true,
  });
  const phone = await phoneContext.newPage();
  await phone.goto(sandbox.joinUrl);
  await enableSemantics(phone);
  await phone.getByRole('radio', { name: /^Consultation/ }).click();
  await phone.getByRole('textbox').first().fill('Ada');
  await button(phone, 'Join the line').click();
  await expect(phone).toHaveURL(/\/t\/[A-Za-z0-9_-]+$/, { timeout: 30_000 });
  // The ticket reads its label the way it's spoken, "C 1".
  const spoken = phone.locator('flt-semantics-host');
  await expect(spoken).toContainText(/C 1\s*Consultation|C-001/, { timeout: 30_000 });
  await phone.screenshot({ path: join(SCREENS, 'phone-waiting.png') });

  const callNext = button(desk, 'Call next');
  await expect(callNext).toBeEnabled({ timeout: 30_000 });
  const pressed = Date.now();
  await callNext.click();
  await expect(spoken).toContainText(/Your turn\. Go to /, { timeout: 15_000 });
  const seen = Date.now() - pressed;
  appendFileSync(LOG, `${new Date().toISOString()} ${test.info().project.name} desk click to phone text ${seen} ms\n`);
  await phone.screenshot({ path: join(SCREENS, 'phone-called.png') });
  await desk.screenshot({ path: join(SCREENS, 'desk-called.png') });

  await deskContext.close();
  await phoneContext.close();
});
