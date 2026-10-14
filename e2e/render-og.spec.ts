import { join } from 'node:path';

import { expect, test, type Page } from '@playwright/test';

// Renders the site's share image and home-screen icon from HTML that uses the
// site's own tokens.css and site.css, so the ticket in the image is the
// ticket on the site. Run with `npm run og` against a running server.

const IMG_DIR = join(__dirname, '..', 'docket_server', 'web', 'site', 'img');

const MARK_PATH =
  'M5 0h14a5 5 0 0 1 5 5v2.5a3.5 3.5 0 0 0 0 7V25a5 5 0 0 1-5 5H5a5 5 0 0 1-5-5V14.5a3.5 3.5 0 0 0 0-7V5a5 5 0 0 1 5-5z';

const MARK_SVG = `<svg class="mark" viewBox="0 0 24 30" aria-hidden="true"><path class="mark-ticket" d="${MARK_PATH}"/><circle class="mark-dots" cx="8" cy="11" r="1.2"/><circle class="mark-dots" cx="12" cy="11" r="1.2"/><circle class="mark-dots" cx="16" cy="11" r="1.2"/></svg>`;

function pageHtml(styles: string, body: string): string {
  return `<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<link rel="stylesheet" href="/site/css/tokens.css">
<link rel="stylesheet" href="/site/css/site.css">
<style>*, *::before { transition: none !important; } ${styles}</style>
</head>
<body>${body}</body>
</html>`;
}

const OG_STYLES = `
  body { min-height: 0; display: block; overflow: hidden; }
  .og {
    width: 1200px;
    height: 630px;
    display: grid;
    grid-template-columns: 1fr 380px;
    align-items: center;
    column-gap: var(--space-64);
    padding: var(--space-64) var(--space-96) var(--space-64) var(--space-64);
  }
  .og .wordmark { font-size: 2rem; }
  .og h1 { margin-block-start: var(--space-48); font-size: 7.25rem; }
  .og .ticket { max-width: 380px; }
`;

const OG_BODY = `
<div class="og">
  <div>
    <span class="wordmark">${MARK_SVG}<span>Docket</span></span>
    <h1>Wait anywhere.</h1>
  </div>
  <div class="ticket ticket-hero" data-state="heads-up">
    <div class="ticket-stub">
      <p class="ticket-line">Consultation</p>
      <p class="ticket-label">C-031</p>
    </div>
    <div class="ticket-body">
      <div class="ticket-step" data-active>
        <p class="ticket-headline">Start heading back</p>
        <p class="ticket-copy">You're next after C-030.</p>
      </div>
    </div>
  </div>
</div>`;

const ICON_STYLES = `
  body { min-height: 0; display: grid; place-items: center; width: 180px; height: 180px; background: var(--color-register); }
  .mark { width: 92px; height: auto; }
`;

// The page is served under the site's own origin, so the fonts it loads from
// /site/fonts/ are same-origin.
async function render(page: Page, baseUrl: string | undefined, html: string): Promise<void> {
  if (!baseUrl) throw new Error('Set BASE_URL to a running Docket web server');
  const url = `${baseUrl}/__render-og`;
  await page.route(url, (route) => route.fulfill({ body: html, contentType: 'text/html' }));
  await page.goto(url, { waitUntil: 'load' });
  await page.evaluate(async () => {
    await document.fonts.ready;
  });
}

test.use({ colorScheme: 'light', reducedMotion: 'reduce', deviceScaleFactor: 1 });

test('Open Graph image, 1200 by 630', async ({ page, baseURL }) => {
  await page.setViewportSize({ width: 1200, height: 630 });
  await render(page, baseURL, pageHtml(OG_STYLES, OG_BODY));
  const fontLoaded = await page.evaluate(() => document.fonts.check('800 16px "Atkinson Hyperlegible Next"'));
  expect(fontLoaded, 'Atkinson Hyperlegible Next loaded from the site').toBe(true);
  await page.screenshot({ path: join(IMG_DIR, 'og.png') });
});

test('apple-touch-icon, 180 by 180', async ({ page, baseURL }) => {
  await page.setViewportSize({ width: 180, height: 180 });
  await render(page, baseURL, pageHtml(ICON_STYLES, MARK_SVG));
  await page.screenshot({ path: join(IMG_DIR, 'apple-touch-icon.png') });
});
