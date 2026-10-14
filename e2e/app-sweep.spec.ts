import { mkdirSync, readFileSync } from 'node:fs';
import { join } from 'node:path';

import AxeBuilder from '@axe-core/playwright';
import { expect, test, type Page } from '@playwright/test';

import { FIXTURE_FILE } from './app-setup';

const SCREENS = join(__dirname, 'screens', 'app');
mkdirSync(SCREENS, { recursive: true });

const SIZES: Array<[number, number]> = [
  [360, 800], [390, 844], [430, 932], [768, 1024], [1024, 768],
  [1280, 800], [1440, 900], [1920, 1080], [844, 390],
];

type Fixture = { sandboxRaw: string; slug: string; ticketToken: string; boardToken: string };

function loadFixture(): Fixture {
  return JSON.parse(readFileSync(FIXTURE_FILE, 'utf8')) as Fixture;
}

async function enableSemantics(page: Page): Promise<void> {
  const placeholder = page.locator('flt-semantics-placeholder');
  await placeholder.waitFor({ state: 'attached', timeout: 30_000 });
  await placeholder.evaluate((node) => (node as HTMLElement).click());
  await expect(page.locator('flt-semantics').first()).toBeAttached();
}

const ROUTES: Array<{ name: string; path: (f: Fixture) => string; sandbox?: boolean }> = [
  { name: 'try', path: () => '/try' },
  { name: 'join', path: (f) => `/j/${f.slug}` },
  { name: 'ticket', path: (f) => `/t/${f.ticketToken}` },
  { name: 'desk', path: () => '/desk', sandbox: true },
  { name: 'board', path: (f) => `/b/${f.boardToken}` },
  { name: 'owner', path: () => '/owner' },
  { name: 'owner-sandbox', path: () => '/owner', sandbox: true },
  { name: 'invite', path: () => '/invite/not-a-real-invite-code-123' },
  { name: 'not-found', path: () => '/no-such-page' },
];

for (const scheme of ['light', 'dark'] as const) {
  for (const [width, height] of SIZES) {
    test.describe(`${scheme} ${width}x${height}`, () => {
      test.use({ viewport: { width, height }, colorScheme: scheme });
      for (const route of ROUTES) {
        test(route.name, async ({ page }, info) => {
          const f = loadFixture();
          if (route.sandbox) {
            await page.addInitScript((raw) => window.localStorage.setItem('docket.sandbox', raw), f.sandboxRaw);
          }
          await page.goto(route.path(f));
          await enableSemantics(page);
          await page.waitForTimeout(1500);
          const overflow = await page.evaluate(() => document.documentElement.scrollWidth - window.innerWidth);
          expect(overflow).toBeLessThanOrEqual(0);
          await page.screenshot({
            path: join(SCREENS, `${info.project.name}-${scheme}-${width}x${height}-${route.name}.png`),
          });
          const results = await new AxeBuilder({ page }).analyze();
          const serious = results.violations.filter((v) => v.impact === 'serious' || v.impact === 'critical');
          expect(serious.map((v) => `${v.id}: ${v.help}`)).toEqual([]);
        });
      }
    });
  }
}
