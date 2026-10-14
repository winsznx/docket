import { mkdirSync } from 'node:fs';
import { join } from 'node:path';

import { expect, type APIRequestContext, type Locator, type Page } from '@playwright/test';

// Shared by desk.spec.ts and offline.spec.ts. The desk runs against the real
// local API server, so every check below reads the server's own answer.

export const API_URL = (process.env.DOCKET_API_URL ?? 'http://localhost:8080').replace(/\/$/, '');

export const SCREENS_DIR = join(__dirname, 'screens', 'desk');
mkdirSync(SCREENS_DIR, { recursive: true });

export type Sandbox = {
  clinicId: string;
  clinicSlug: string;
  sandboxToken: string;
  boardUrl: string;
  joinUrl: string;
};

export type TicketView = { id: string; label: string; displayName: string; state: string; isDemo: boolean };
export type LineView = { id: string; name: string; code: string; tickets: TicketView[] };
export type DeskView = { clinicName: string; lines: LineView[]; rooms: { id: string; name: string; lineId: string }[] };

/** Calls a Serverpod endpoint the way the generated client does. */
export async function api<T>(
  request: APIRequestContext,
  endpoint: string,
  method: string,
  args: Record<string, unknown>,
): Promise<T> {
  const response = await request.post(`${API_URL}/${endpoint}/${method}`, { data: args });
  const body = await response.text();
  if (!response.ok()) throw new Error(`${endpoint}.${method} ${response.status()}: ${body}`);
  return JSON.parse(body) as T;
}

/**
 * Flutter draws to a canvas. Turning on its semantics tree gives every
 * control a DOM node with its accessible name, which is what the checks use.
 */
export async function enableSemantics(page: Page): Promise<void> {
  const toggle = page.locator('flt-semantics-placeholder');
  await toggle.waitFor({ state: 'attached', timeout: 30_000 });
  await toggle.evaluate((node) => (node as HTMLElement).click());
  await expect(page.locator('flt-semantics').first()).toBeAttached();
}

/**
 * Text Flutter exposes either as a text node or as an element's accessible
 * name, depending on how it merges into its semantics node.
 */
export function said(page: Page, text: string | RegExp): Locator {
  return page.getByText(text).or(page.getByLabel(text)).first();
}

export function button(page: Page, name: string | RegExp): Locator {
  return page.getByRole('button', { name, exact: typeof name === 'string' });
}

/** Scrolls the Flutter page until [target] is on screen, then clicks it. */
export async function reveal(page: Page, target: Locator): Promise<Locator> {
  for (let i = 0; i < 12; i++) {
    if ((await target.count()) > 0 && (await target.first().isVisible())) {
      const box = await target.first().boundingBox();
      const viewport = page.viewportSize();
      if (box && viewport && box.y >= 0 && box.y + box.height <= viewport.height) return target.first();
    }
    const viewport = page.viewportSize() ?? { width: 1280, height: 800 };
    await page.mouse.move(viewport.width / 2, viewport.height / 2);
    await page.mouse.wheel(0, 300);
    await page.waitForTimeout(150);
  }
  return target.first();
}

export async function scrollToTop(page: Page): Promise<void> {
  const viewport = page.viewportSize() ?? { width: 1280, height: 800 };
  await page.mouse.move(viewport.width / 2, viewport.height / 2);
  for (let i = 0; i < 6; i++) await page.mouse.wheel(0, -2000);
  await page.waitForTimeout(200);
}

export async function noHorizontalScroll(page: Page): Promise<void> {
  const overflow = await page.evaluate(
    () => document.documentElement.scrollWidth - window.innerWidth,
  );
  expect(overflow).toBeLessThanOrEqual(0);
}

/**
 * Presses [target] until [done] shows. The API server allows six sandbox
 * calls a minute from one address, and other test runs on this machine share
 * that budget, so a refusal waits the minute out and presses again. The same
 * goes for a moment when the local API server is restarting.
 */
export async function pressWithinQuota(page: Page, target: Locator, done: Locator): Promise<void> {
  const refused = said(page, 'Too many tries. Wait a minute and try again.').or(
    said(page, "Couldn't reach Docket. Check the connection and try again."),
  );
  for (let attempt = 0; attempt < 4; attempt++) {
    await target.click();
    await expect(done.or(refused).first()).toBeAttached({ timeout: 30_000 });
    if ((await done.count()) > 0) return;
    await page.waitForTimeout(61_000);
  }
  throw new Error('The API server kept refusing sandbox calls.');
}

/** `/try` to a sandbox desk, the path a judge takes. */
export async function openSandboxDesk(page: Page): Promise<Sandbox> {
  await page.goto('/try');
  await enableSemantics(page);
  const refused = said(page, 'Too many tries. Wait a minute and try again.').or(
    said(page, "Couldn't reach Docket. Check the connection and try again."),
  );
  for (let attempt = 0; attempt < 4 && !page.url().endsWith('/desk'); attempt++) {
    await button(page, 'Open my sandbox desk').click();
    await expect
      .poll(async () => page.url().endsWith('/desk') || (await refused.count()) > 0, { timeout: 30_000 })
      .toBe(true);
    if (!page.url().endsWith('/desk')) await page.waitForTimeout(61_000);
  }
  await expect(page).toHaveURL(/\/desk$/);
  // The local API server may be restarting under other work, and the desk
  // keeps retrying its stream until it's back.
  await expect(button(page, 'Add 5 demo walk-ins')).toBeAttached({ timeout: 90_000 });
  const raw = await page.evaluate(() => window.localStorage.getItem('docket.sandbox'));
  expect(raw).not.toBeNull();
  return JSON.parse(raw!) as Sandbox;
}

export async function deskView(request: APIRequestContext, sandbox: Sandbox): Promise<DeskView> {
  return api<DeskView>(request, 'desk', 'getView', {
    clinicId: sandbox.clinicId,
    sandboxToken: sandbox.sandboxToken,
  });
}

/** The state of the ticket labelled [label] on the server, or undefined. */
export async function serverState(
  request: APIRequestContext,
  sandbox: Sandbox,
  label: string,
): Promise<string | undefined> {
  const view = await deskView(request, sandbox);
  return view.lines.flatMap((l) => l.tickets).find((t) => t.label === label)?.state;
}

export async function shot(page: Page, name: string): Promise<void> {
  await page.waitForTimeout(400);
  await page.screenshot({ path: join(SCREENS_DIR, `${name}.png`) });
}
