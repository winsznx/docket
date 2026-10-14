import { expect, test, type APIRequestContext, type Page } from '@playwright/test';
import path from 'node:path';

// The patient's join page and live ticket against the real local server
// (PRD 17.1, 17.2). Run with `npx playwright test -c patient.config.ts`.
//
// It makes a sandbox through the API, joins from /j/<slug> on a phone-sized
// page, and checks the ticket shows its label and place. When the desk
// surface is there, a second page at /desk presses Call next and the phone
// has to turn to "Your turn".

const API = process.env.API_URL ?? 'http://localhost:8080';
const SCREENS = path.join(__dirname, 'screens', 'patient');
const PHONE = { width: 390, height: 844 };

type SandboxStart = {
  clinicId: string;
  clinicSlug: string;
  sandboxToken: string;
};

type PatientView = {
  label: string;
  lineName: string;
  position: number | null;
  state: string;
};

async function post<T>(request: APIRequestContext, route: string, data: unknown): Promise<T> {
  // The server allows six sandboxes a minute per address, shared with every
  // other check running on this machine.
  for (let attempt = 0; attempt < 3; attempt++) {
    const response = await request.post(`${API}/${route}`, { data });
    if (response.status() === 429) {
      await new Promise((resolve) => setTimeout(resolve, 61_000));
      continue;
    }
    expect(response.ok(), `${route} answered ${response.status()}`).toBeTruthy();
    const text = await response.text();
    return (text ? JSON.parse(text) : null) as T;
  }
  throw new Error(`${route} kept answering 429`);
}

/** Flutter draws to a canvas. Its semantics tree is what tests can read. */
async function enableSemantics(page: Page) {
  await page.locator('flt-semantics-placeholder').waitFor({ state: 'attached' });
  await page.evaluate(() =>
    (document.querySelector('flt-semantics-placeholder') as HTMLElement | null)?.click(),
  );
}

/** "C-031" as the page speaks it, "C 31". */
function spoken(label: string) {
  const match = /^([A-Za-z]+)-0*(\d+)$/.exec(label);
  return match ? `${match[1]} ${match[2]}` : label;
}

function ordinal(n: number) {
  const lastTwo = n % 100;
  if (lastTwo >= 11 && lastTwo <= 13) return `${n}th`;
  return `${n}${['th', 'st', 'nd', 'rd'][n % 10] ?? 'th'}`;
}

async function noHorizontalScroll(page: Page) {
  const fits = await page.evaluate(
    () => document.documentElement.scrollWidth <= window.innerWidth,
  );
  expect(fits).toBeTruthy();
}

for (const colorScheme of ['light', 'dark'] as const) {
  test(`join, wait and get called, ${colorScheme}`, async ({ browser, request }) => {
    test.setTimeout(240_000);
    const shot = (name: string) => path.join(SCREENS, `${name}-${colorScheme}.png`);

    const sandbox = await post<SandboxStart>(request, 'sandbox/start', {});
    const clinic = await post<{ lines: { id: string; code: string }[] }>(
      request,
      'publicClinic/getClinic',
      { slug: sandbox.clinicSlug },
    );
    const consultation = clinic.lines.find((line) => line.code === 'C')!;
    // Three DEMO walk-ins ahead, so the ticket has a place to show.
    await post(request, 'sandbox/addDemoWalkIns', {
      sandboxToken: sandbox.sandboxToken,
      lineId: consultation.id,
      count: 3,
    });

    const context = await browser.newContext({
      viewport: PHONE,
      deviceScaleFactor: 2,
      isMobile: true,
      hasTouch: true,
      colorScheme,
    });
    const phone = await context.newPage();

    await phone.goto(`/j/${sandbox.clinicSlug}`);
    await enableSemantics(phone);
    const line = phone.getByRole('radio', { name: /Consultation/ });
    await expect(line).toBeVisible({ timeout: 30_000 });
    await expect(line).toHaveAccessibleName(/3 waiting/);
    await expect(phone.getByText(/sandbox clinic for trying Docket/)).toBeVisible();
    await noHorizontalScroll(phone);
    await phone.waitForTimeout(400);
    await phone.screenshot({ path: shot('join') });

    await line.click();
    await phone.getByRole('textbox', { name: /Initials or first name/ }).fill('AO');
    await phone.getByRole('button', { name: 'Join the line' }).click();
    await phone.waitForURL(/\/t\/[A-Za-z0-9_-]+$/);
    const token = phone.url().split('/t/')[1];

    const view = await post<PatientView>(request, 'ticket/get', { token });
    expect(view.state).toBe('waiting');
    expect(view.position).toBe(4);
    await expect(phone.getByText(spoken(view.label), { exact: true })).toBeVisible();
    await expect(
      phone.getByRole('heading', {
        name: `You're ${ordinal(view.position!)} in line for ${view.lineName}.`,
      }),
    ).toBeVisible();
    await expect(phone.getByRole('button', { name: 'Get alerts' })).toBeVisible();
    await expect(phone.getByRole('button', { name: 'Leave line' })).toBeVisible();
    await expect(
      phone.getByText('Anyone with this link can see and cancel this ticket.'),
    ).toBeVisible();
    await noHorizontalScroll(phone);
    await phone.waitForTimeout(600);
    await phone.screenshot({ path: shot('waiting') });

    // The desk, when its surface is built, in the same browser so it finds
    // the sandbox the way /try leaves it.
    const desk = await context.newPage();
    await desk.setViewportSize({ width: 1280, height: 800 });
    await desk.addInitScript(
      ([key, value]) => window.localStorage.setItem(key, value),
      ['docket.sandbox', JSON.stringify(sandbox)],
    );
    await desk.goto('/desk');
    await enableSemantics(desk);
    const room = desk.getByRole('button', { name: /Room 1, calls from Consultation/ });
    const callNext = desk.getByRole('button', { name: /^Call next/ });
    const ready = await Promise.race([
      room.waitFor({ timeout: 30_000 }).then(() => 'room'),
      callNext.waitFor({ timeout: 30_000 }).then(() => 'call'),
    ]).catch(() => 'none');
    if (ready === 'none') {
      test.info().annotations.push({
        type: 'note',
        description: 'No desk at /desk, so only the waiting state was checked.',
      });
      await context.close();
      return;
    }
    if (ready === 'room') await room.click();

    // Three walk-ins ahead: three calls from Room 1 and Room 2 bring this
    // ticket to the front, the fourth calls it. Finishing between calls
    // keeps the rooms free.
    for (let call = 0; call < 4; call++) {
      await expect(callNext).toBeEnabled({ timeout: 15_000 });
      await callNext.click();
      if (call < 3) {
        await desk.getByRole('button', { name: /^Start service/ }).click();
        await desk.getByRole('button', { name: /^Finish/ }).click();
      }
    }

    await expect(phone.getByRole('heading', { name: /^Your turn\. Go to Room 1\.$/ })).toBeVisible({
      timeout: 15_000,
    });
    await expect(phone.getByText(/^\d:\d\d to confirm$/)).toBeVisible();
    await expect(phone.getByRole('button', { name: "I'm coming" })).toBeVisible();
    await phone.waitForTimeout(600);
    await phone.screenshot({ path: shot('called') });

    await phone.getByRole('button', { name: "I'm coming" }).click();
    await expect(phone.getByRole('heading', { name: 'Room 1 is expecting you' })).toBeVisible();
    await phone.waitForTimeout(600);
    await phone.screenshot({ path: shot('confirmed') });
    await context.close();
  });
}
