import { expect, test, type Locator, type Page } from '@playwright/test';

import {
  button,
  enableSemantics,
  noHorizontalScroll,
  openSandboxDesk,
  pressWithinQuota,
  reveal,
  said,
  scrollToTop,
  serverState,
  shot,
} from './desk-helpers';

// The judge path on the desk (PRD 17.3, 17.6 and 26): `/try` opens a sandbox
// desk, demo patients join, then Call next, Start service and Finish. Every
// step is checked against the server, and screenshots land in
// e2e/screens/desk/ for review against DESIGN.md section 2.
//
// The API server allows six sandbox calls a minute from one address, so one
// sandbox serves every viewport and color scheme: each variant calls,
// starts and finishes the next demo patient.

const VARIANTS = [
  { tag: 'laptop-light', width: 1280, height: 800, colorScheme: 'light' },
  { tag: 'laptop-dark', width: 1280, height: 800, colorScheme: 'dark' },
  { tag: 'phone-light', width: 390, height: 844, colorScheme: 'light' },
  { tag: 'phone-dark', width: 390, height: 844, colorScheme: 'dark' },
] as const;

/** The queue heading, which carries the line's waiting count. */
function waiting(page: Page, count: number): Locator {
  return page.getByRole('heading', { name: `Consultation ${count} waiting` });
}

async function useVariant(page: Page, variant: (typeof VARIANTS)[number]): Promise<void> {
  await page.setViewportSize({ width: variant.width, height: variant.height });
  await page.emulateMedia({ colorScheme: variant.colorScheme, reducedMotion: 'reduce' });
  await page.waitForTimeout(300);
  await scrollToTop(page);
}

test('judge path: /try, demo walk-ins, call, start and finish', async ({ page, request }) => {
  // #given a sandbox desk opened from /try
  await page.setViewportSize({ width: 1280, height: 800 });
  const sandbox = await openSandboxDesk(page);

  // #then the empty desk says why it can't call
  for (const variant of VARIANTS) {
    await useVariant(page, variant);
    await expect(button(page, 'No one is waiting')).toBeAttached();
    await noHorizontalScroll(page);
    await shot(page, `${variant.tag}-01-empty`);
  }

  // #when five demo patients join through the real join path
  await useVariant(page, VARIANTS[0]);
  await pressWithinQuota(
    page,
    await reveal(page, button(page, 'Add 5 demo walk-ins')),
    waiting(page, 5),
  );
  await expect.poll(() => serverState(request, sandbox, 'C-005')).toBe('waiting');

  for (const [i, variant] of VARIANTS.entries()) {
    const label = `C-00${i + 1}`;
    await useVariant(page, variant);
    await expect(button(page, 'Call next')).toBeEnabled();
    await noHorizontalScroll(page);
    await shot(page, `${variant.tag}-02-queue`);

    // #when the desk calls next
    const pressed = Date.now();
    await button(page, 'Call next').click();
    await expect(button(page, 'Start service')).toBeAttached();
    test.info().annotations.push({
      type: `${variant.tag} call next on screen`,
      description: `${Date.now() - pressed} ms`,
    });

    // #then the server has the call and the desk counts down its grace window
    await expect.poll(() => serverState(request, sandbox, label)).toBe('called');
    await expect(said(page, /to confirm/)).toBeAttached();
    await shot(page, `${variant.tag}-03-called`);

    // #when service starts, #then the ticket is in service on the server
    await button(page, 'Start service').click();
    await expect(button(page, 'Finish')).toBeAttached();
    await expect.poll(() => serverState(request, sandbox, label)).toBe('inService');
    await shot(page, `${variant.tag}-04-in-service`);

    // #when the desk finishes, #then the room is free and the ticket is served
    await button(page, 'Finish').click();
    await expect(said(page, /Room 1 is free\./)).toBeAttached();
    await expect.poll(() => serverState(request, sandbox, label)).toBeUndefined();
    await expect(await reveal(page, waiting(page, 4 - i))).toBeAttached();
    await scrollToTop(page);
    await noHorizontalScroll(page);
    await shot(page, `${variant.tag}-05-finished`);
  }
});

test('try page holds one decision', async ({ page }) => {
  for (const variant of VARIANTS) {
    await page.setViewportSize({ width: variant.width, height: variant.height });
    await page.emulateMedia({ colorScheme: variant.colorScheme, reducedMotion: 'reduce' });
    await page.goto('/try');
    await enableSemantics(page);
    await expect(
      said(page, "This makes a throwaway clinic for you. It's deleted after 24 hours."),
    ).toBeAttached();
    await expect(button(page, 'Open my sandbox desk')).toBeAttached();
    await noHorizontalScroll(page);
    await shot(page, `try-${variant.tag}`);
  }
});
