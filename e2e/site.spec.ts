import { mkdirSync } from 'node:fs';
import { join } from 'node:path';
import { gzipSync } from 'node:zlib';

import AxeBuilder from '@axe-core/playwright';
import { expect, test, type Page } from '@playwright/test';

// DESIGN.md section 7 checks for every page of the server-rendered site.

const SITE_PAGES = [
  { path: '/', slug: 'home' },
  { path: '/problem', slug: 'problem' },
  { path: '/how-it-works', slug: 'how-it-works' },
  { path: '/patients', slug: 'patients' },
  { path: '/clinics', slug: 'clinics' },
  { path: '/reliability', slug: 'reliability' },
  { path: '/under-the-hood', slug: 'under-the-hood' },
  { path: '/privacy', slug: 'privacy' },
] as const;

const VIEWPORTS = [
  { width: 360, height: 800 },
  { width: 390, height: 844 },
  { width: 430, height: 932 },
  { width: 768, height: 1024 },
  { width: 1024, height: 768 },
  { width: 1280, height: 800 },
  { width: 1440, height: 900 },
  { width: 1920, height: 1080 },
  { width: 844, height: 390 },
] as const;

const COLOR_SCHEMES = ['light', 'dark'] as const;

const SCREENS_DIR = join(__dirname, 'screens', 'site');

// DESIGN.md 4.4: HTML, CSS and JS together, gzipped, fonts and images aside.
const PAGE_BUDGET_BYTES = 60 * 1024;

mkdirSync(SCREENS_DIR, { recursive: true });

async function openPage(page: Page, path: string): Promise<void> {
  await page.goto(path);
  await page.evaluate(async () => {
    await document.fonts.ready;
  });
}

function describeViolations(
  violations: Awaited<ReturnType<AxeBuilder['analyze']>>['violations'],
): string {
  return violations
    .map((v) => `${v.impact} ${v.id}: ${v.help}\n  ${v.nodes.map((n) => n.target.join(' ')).join('\n  ')}`)
    .join('\n');
}

for (const colorScheme of COLOR_SCHEMES) {
  for (const viewport of VIEWPORTS) {
    test.describe(`${colorScheme} ${viewport.width}x${viewport.height}`, () => {
      // Reduced motion holds the home ticket on its first state, so every
      // screenshot shows the same thing.
      test.use({ viewport, colorScheme, reducedMotion: 'reduce' });

      for (const sitePage of SITE_PAGES) {
        test(sitePage.path, async ({ page, browserName }) => {
          await openPage(page, sitePage.path);

          const widths = await page.evaluate(() => ({
            scrollWidth: document.documentElement.scrollWidth,
            innerWidth: window.innerWidth,
          }));
          expect(widths.scrollWidth, 'no horizontal scroll').toBeLessThanOrEqual(widths.innerWidth);

          await expect(page.locator('h1')).toHaveCount(1);

          const { violations } = await new AxeBuilder({ page }).analyze();
          const blocking = violations.filter((v) => v.impact === 'serious' || v.impact === 'critical');
          expect(blocking, describeViolations(blocking)).toEqual([]);

          await page.screenshot({
            path: join(
              SCREENS_DIR,
              `${browserName}-${colorScheme}-${viewport.width}x${viewport.height}-${sitePage.slug}.png`,
            ),
            fullPage: true,
          });
        });
      }
    });
  }
}

test.describe('menu sheet', () => {
  test.use({ viewport: { width: 390, height: 844 } });

  test('opens, keeps focus inside and closes with Esc', async ({ page, browserName }) => {
    await openPage(page, '/problem');
    const toggle = page.locator('[data-menu-open]');
    const sheet = page.locator('#menu');

    await toggle.click();
    await expect(sheet).toBeVisible();
    await expect(toggle).toHaveAttribute('aria-expanded', 'true');
    await expect(sheet.locator('a[aria-current="page"]')).toHaveText('The problem');
    await sheet.evaluate((el) => Promise.all(el.getAnimations().map((a) => a.finished)));
    await page.screenshot({ path: join(SCREENS_DIR, `${browserName}-menu-open-390x844.png`) });

    for (let i = 0; i < 15; i++) {
      await page.keyboard.press('Tab');
      const inside = await page.evaluate(() => document.getElementById('menu')?.contains(document.activeElement));
      expect(inside, `focus stays in the sheet after ${i + 1} tabs`).toBe(true);
    }

    await page.keyboard.press('Escape');
    await expect(sheet).toBeHidden();
    await expect(toggle).toHaveAttribute('aria-expanded', 'false');
    await expect(toggle).toBeFocused();
    await expect(page).toHaveURL(/\/problem$/);
  });

  test('closes with the back button and stays on the page', async ({ page }) => {
    await openPage(page, '/');
    await openPage(page, '/problem');
    await page.locator('[data-menu-open]').click();
    await expect(page.locator('#menu')).toBeVisible();

    await page.goBack();
    await expect(page.locator('#menu')).toBeHidden();
    await expect(page).toHaveURL(/\/problem$/);
  });

  test('a link in the sheet leaves no extra history entry', async ({ page }) => {
    await openPage(page, '/');
    await openPage(page, '/problem');
    await page.locator('[data-menu-open]').click();
    await page.locator('#menu a', { hasText: 'Privacy' }).click();
    await expect(page).toHaveURL(/\/privacy$/);

    await page.goBack();
    await expect(page).toHaveURL(/\/problem$/);
    await expect(page.locator('#menu')).toBeHidden();
  });

  test('without JS, Menu jumps to the footer list of every page', async ({ browser }) => {
    const context = await browser.newContext({ javaScriptEnabled: false, viewport: { width: 390, height: 844 } });
    const page = await context.newPage();
    await page.goto('/problem');
    await page.locator('[data-menu-open]').click();
    await expect(page).toHaveURL(/#site-footer$/);
    await expect(page.locator('.footer-pages a')).toHaveCount(9);
    await context.close();
  });
});

test.describe('home ticket', () => {
  test.use({ viewport: { width: 1280, height: 800 } });

  test('plays once, then Call next steps through it again', async ({ page }) => {
    await openPage(page, '/');
    const ticket = page.locator('[data-ticket]');
    await expect(ticket).toHaveAttribute('data-state', 'waiting');
    await expect(ticket).toHaveAttribute('data-state', 'heads-up', { timeout: 10_000 });
    await expect(ticket).toHaveAttribute('data-state', 'called', { timeout: 10_000 });
    await expect(ticket.locator('[data-step="called"] .countdown')).not.toHaveText('3:00', { timeout: 3_000 });
    await expect(ticket).toHaveAttribute('data-state', 'confirmed', { timeout: 10_000 });

    // The autoplay stops on the last state.
    await page.waitForTimeout(3_000);
    await expect(ticket).toHaveAttribute('data-state', 'confirmed');

    await page.getByRole('button', { name: 'Call next' }).click();
    await expect(ticket).toHaveAttribute('data-state', 'waiting');
    await expect(ticket.locator('[data-step][data-active]')).toContainText("You're 3rd in line");
    await expect(page.locator('[data-hero-status]')).toContainText("You're 3rd in line");
  });

  test('with reduced motion nothing plays on its own', async ({ browser }) => {
    const context = await browser.newContext({ reducedMotion: 'reduce' });
    const page = await context.newPage();
    await openPage(page, '/');
    await page.waitForTimeout(5_000);
    const ticket = page.locator('[data-ticket]');
    await expect(ticket).toHaveAttribute('data-state', 'waiting');
    await expect(ticket.locator('[data-step][data-active]')).toContainText("You're 3rd in line");

    await page.getByRole('button', { name: 'Call next' }).click();
    await expect(ticket.locator('[data-step][data-active]')).toContainText("You're 2nd in line");
    await context.close();
  });

  test('without JS it shows the first state and no button', async ({ browser }) => {
    const context = await browser.newContext({ javaScriptEnabled: false });
    const page = await context.newPage();
    await page.goto('/');
    await expect(page.locator('[data-step][data-active]')).toBeVisible();
    await expect(page.locator('[data-step][data-active]')).toContainText("You're 3rd in line");
    await expect(page.getByText('Your turn. Go to Room 2.')).toBeHidden();
    await expect(page.locator('[data-call-next]')).toBeHidden();
    await context.close();
  });
});

test.describe('page weight', () => {
  for (const sitePage of SITE_PAGES) {
    test(`${sitePage.path} stays under 60 KB of gzipped HTML, CSS and JS`, async ({ request, browserName }) => {
      test.skip(browserName !== 'chromium', 'byte counts are the same in every browser');
      const html = await (await request.get(sitePage.path)).text();
      const assetPaths = [
        ...html.matchAll(/<link rel="stylesheet" href="([^"]+)"/g),
        ...html.matchAll(/<script src="([^"]+)"/g),
      ].map((match) => match[1]);
      expect(assetPaths.length).toBe(3);

      let total = gzipSync(html).length;
      for (const assetPath of assetPaths) {
        const response = await request.get(assetPath);
        expect(response.ok(), assetPath).toBe(true);
        total += gzipSync(await response.body()).length;
      }
      expect(total).toBeLessThan(PAGE_BUDGET_BYTES);
    });
  }
});
