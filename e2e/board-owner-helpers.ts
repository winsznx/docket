import { mkdirSync } from 'node:fs';
import { join } from 'node:path';

import AxeBuilder from '@axe-core/playwright';
import { expect, type APIRequestContext, type Locator, type Page } from '@playwright/test';

// Shared by board.spec.ts and owner.spec.ts. Both run against the real local
// API server, so every check reads the server's own answer.

export const API_URL = (process.env.DOCKET_API_URL ?? 'http://localhost:8080').replace(/\/$/, '');

export function screensDir(surface: 'board' | 'owner'): string {
  const dir = join(__dirname, 'screens', surface);
  mkdirSync(dir, { recursive: true });
  return dir;
}

const TOO_MANY = /Too many tries/;

/**
 * Calls a Serverpod endpoint with the JSON body the generated client sends:
 * POST `/<endpoint>/<method>` with the named arguments. The API server
 * limits sandbox calls per minute, so a rate-limit refusal waits and tries
 * again.
 */
export async function api<T>(
  request: APIRequestContext,
  endpoint: string,
  method: string,
  args: Record<string, unknown>,
): Promise<T> {
  for (let attempt = 0; attempt < 4; attempt++) {
    const response = await request.post(`${API_URL}/${endpoint}/${method}`, { data: args });
    const body = await response.text();
    if (response.ok()) return (body ? JSON.parse(body) : undefined) as T;
    if (!TOO_MANY.test(body) && response.status() !== 429) {
      throw new Error(`${endpoint}.${method} ${response.status()}: ${body}`);
    }
    await new Promise((resolve) => setTimeout(resolve, 61_000));
  }
  throw new Error(`${endpoint}.${method} kept being rate limited.`);
}

/**
 * Flutter draws to a canvas. Turning on its semantics tree gives every
 * control a DOM node with its accessible name, which is what the checks use.
 */
export async function enableSemantics(page: Page): Promise<void> {
  const placeholder = page.locator('flt-semantics-placeholder');
  await placeholder.waitFor({ state: 'attached', timeout: 60_000 });
  await placeholder.evaluate((node) => (node as HTMLElement).click());
  await expect(page.locator('flt-semantics').first()).toBeAttached();
}

export function button(page: Page, name: string | RegExp): Locator {
  return page.getByRole('button', { name, exact: typeof name === 'string' });
}

export async function noHorizontalScroll(page: Page): Promise<void> {
  const overflow = await page.evaluate(
    () => document.documentElement.scrollWidth - window.innerWidth,
  );
  expect(overflow).toBeLessThanOrEqual(0);
}

/**
 * Moves a link the server made, which points at the public web server, onto
 * the app under test, keeping its path.
 */
export function onApp(baseURL: string, url: string): string {
  const target = new URL(url);
  return `${new URL(baseURL).origin}${target.pathname}${target.search}`;
}

/** Scrolls the Flutter page until [target] is on screen. */
export async function reveal(page: Page, target: Locator): Promise<Locator> {
  for (let i = 0; i < 20; i++) {
    if ((await target.count()) > 0) {
      const box = await target.first().boundingBox();
      const viewport = page.viewportSize();
      if (box && viewport && box.y >= 0 && box.y + box.height <= viewport.height) return target.first();
    }
    const viewport = page.viewportSize() ?? { width: 1280, height: 800 };
    await page.mouse.move(viewport.width / 2, viewport.height / 2);
    await page.mouse.wheel(0, 320);
    await page.waitForTimeout(150);
  }
  return target.first();
}

export async function scrollToTop(page: Page): Promise<void> {
  const viewport = page.viewportSize() ?? { width: 1280, height: 800 };
  await page.mouse.move(viewport.width / 2, viewport.height / 2);
  for (let i = 0; i < 8; i++) await page.mouse.wheel(0, -3000);
  await page.waitForTimeout(250);
}

/**
 * Runs axe-core on [page], which needs Flutter semantics on, and fails on
 * any serious or critical violation (DESIGN.md section 7).
 */
export async function axeClean(page: Page, where: string): Promise<void> {
  const result = await new AxeBuilder({ page }).analyze();
  const bad = result.violations.filter((v) => v.impact === 'serious' || v.impact === 'critical');
  expect(
    bad.map((v) => `${v.id}: ${v.help} (${v.nodes.map((n) => n.target.join(' ')).join(', ')})`),
    `axe on ${where}`,
  ).toEqual([]);
}
