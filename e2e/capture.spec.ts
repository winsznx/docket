import { mkdirSync, renameSync, writeFileSync } from 'node:fs';
import { join } from 'node:path';

import { expect, test, type Browser, type BrowserContext, type Page } from '@playwright/test';

import { button, enableSemantics, openSandboxDesk } from './desk-helpers';

const OUT = join(__dirname, 'videos');
mkdirSync(OUT, { recursive: true });

/** A visible cursor and a ring on each click, since Flutter draws to a canvas. */
const CURSOR = `
  addEventListener('DOMContentLoaded', () => {
    const dot = document.createElement('div');
    dot.style.cssText = 'position:fixed;z-index:99999;width:22px;height:22px;margin:-11px 0 0 -11px;border-radius:50%;background:rgba(24,44,112,.35);border:2px solid #182C70;pointer-events:none;left:-40px;top:-40px;transition:transform .12s';
    document.body.appendChild(dot);
    addEventListener('mousemove', (e) => { dot.style.left = e.clientX + 'px'; dot.style.top = e.clientY + 'px'; }, true);
    addEventListener('mousedown', () => { dot.style.transform = 'scale(1.8)'; }, true);
    addEventListener('mouseup', () => { dot.style.transform = 'scale(1)'; }, true);
  });
`;

async function recorded(browser: Browser, name: string, width: number, height: number, mobile: boolean): Promise<{ context: BrowserContext; page: Page }> {
  const context = await browser.newContext({
    viewport: { width, height },
    deviceScaleFactor: 2,
    isMobile: mobile,
    hasTouch: mobile,
    recordVideo: { dir: join(OUT, 'raw', name), size: { width, height } },
  });
  await context.addInitScript(CURSOR);
  return { context, page: await context.newPage() };
}

/** Event marks: seconds since the scene started, for captions and the edit. */
function marker(scene: string) {
  const start = Date.now();
  const marks: string[] = [];
  return {
    mark: (what: string) => marks.push(`${((Date.now() - start) / 1000).toFixed(2)}\t${what}`),
    save: () => writeFileSync(join(OUT, `${scene}-marks.tsv`), marks.join('\n') + '\n'),
  };
}

async function finish(context: BrowserContext, page: Page, file: string): Promise<void> {
  const video = page.video();
  await context.close();
  if (video) renameSync(await video.path(), join(OUT, file));
}

async function joinFromPhone(phone: Page, joinUrl: string, name: string): Promise<void> {
  await phone.goto(joinUrl);
  await enableSemantics(phone);
  await phone.getByRole('radio', { name: /^Consultation/ }).click();
  await phone.getByRole('textbox').first().fill(name);
  await button(phone, 'Join the line').click();
  await expect(phone).toHaveURL(/\/t\//, { timeout: 30_000 });
}

test('desk tap moves the phone: join, heads-up, called, coming', async ({ browser }) => {
  const marks = marker('desk-to-phone');
  const desk = await recorded(browser, 'desk-to-phone-desk', 1280, 800, false);
  const phone = await recorded(browser, 'desk-to-phone-phone', 390, 844, true);
  const sandbox = await openSandboxDesk(desk.page);
  marks.mark('desk open');
  await button(desk.page, 'Add 5 demo walk-ins').click();
  await desk.page.waitForTimeout(2000);
  await joinFromPhone(phone.page, sandbox.joinUrl, 'Ada');
  marks.mark('phone joined');
  const spoken = phone.page.locator('flt-semantics-host');
  await phone.page.waitForTimeout(2500);
  // Five demo patients joined ahead of Ada. The desk sees each in turn,
  // so her phone climbs the line, then the sixth call is hers.
  for (let i = 0; i < 5; i++) {
    await button(desk.page, 'Call next').click();
    marks.mark(`call next ${i + 1}`);
    await desk.page.waitForTimeout(2500);
    await button(desk.page, 'Start service').first().click({ timeout: 10_000 });
    await desk.page.waitForTimeout(900);
    await button(desk.page, 'Finish').first().click({ timeout: 10_000 });
    await desk.page.waitForTimeout(1500);
  }
  await button(desk.page, 'Call next').click();
  marks.mark('call next 6');
  await expect(spoken).toContainText(/Your turn/, { timeout: 20_000 });
  marks.mark('phone called');
  await phone.page.waitForTimeout(3000);
  await button(phone.page, "I'm coming").click();
  marks.mark('patient taps coming');
  await expect(spoken).toContainText(/expecting you/, { timeout: 20_000 });
  await phone.page.waitForTimeout(3000);
  marks.save();
  await finish(desk.context, desk.page, 'desk-to-phone-desk.webm');
  await finish(phone.context, phone.page, 'desk-to-phone-phone.webm');
});

test('the desk keeps calling offline and every phone catches up', async ({ browser }) => {
  const marks = marker('offline-sync');
  const desk = await recorded(browser, 'offline-sync-desk', 1280, 800, false);
  const phone = await recorded(browser, 'offline-sync-phone', 390, 844, true);
  const sandbox = await openSandboxDesk(desk.page);
  await button(desk.page, 'Add 5 demo walk-ins').click();
  await desk.page.waitForTimeout(2000);
  await joinFromPhone(phone.page, sandbox.joinUrl, 'Bisi');
  await phone.page.waitForTimeout(2500);
  marks.mark('desk goes offline');
  await desk.context.setOffline(true);
  await desk.page.waitForTimeout(6000);
  for (let i = 0; i < 2; i++) {
    await button(desk.page, 'Call next').click();
    marks.mark(`offline call ${i + 1}`);
    await desk.page.waitForTimeout(2500);
  }
  await desk.page.waitForTimeout(2000);
  marks.mark('desk back online');
  await desk.context.setOffline(false);
  await expect(phone.page.locator('flt-semantics-host')).toContainText(/3rd|4th|You're next|heading back/, { timeout: 40_000 });
  marks.mark('phone caught up');
  await phone.page.waitForTimeout(4000);
  marks.save();
  await finish(desk.context, desk.page, 'offline-sync-desk.webm');
  await finish(phone.context, phone.page, 'offline-sync-phone.webm');
});
