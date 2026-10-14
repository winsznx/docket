import { readFileSync } from 'node:fs';
import { join } from 'node:path';

import { expect, test, type Browser, type Locator, type Page } from '@playwright/test';

import { api, axeClean, button, enableSemantics, noHorizontalScroll, onApp, reveal, screensDir, scrollToTop } from './board-owner-helpers';

// The owner console (PRD 17.5, component 12 in PRD 25): a new owner signs up
// through the real email flow, sets up a clinic with the wizard, invites a
// desk user who accepts, prints a poster, then works through every console
// section. In development the server prints each verification code to its
// log, which is where this spec reads it from.

const SCREENS = screensDir('owner');
const SERVER_LOG =
  process.env.DOCKET_SERVER_LOG ??
  '/private/tmp/claude-501/-Users-mac-docket/1b3a11f2-0661-4cfd-8465-11f34bb0a92c/scratchpad/server.log';
const PASSWORD = 'Docket-e2e-2026!';

const VARIANTS = [
  { tag: '1280-light', width: 1280, height: 800, colorScheme: 'light' },
  { tag: '1280-dark', width: 1280, height: 800, colorScheme: 'dark' },
  { tag: '390-light', width: 390, height: 844, colorScheme: 'light' },
  { tag: '390-dark', width: 390, height: 844, colorScheme: 'dark' },
] as const;

/** Screenshots [page] at every size and color scheme, then puts it back. */
async function shots(page: Page, name: string): Promise<void> {
  for (const v of VARIANTS) {
    await page.setViewportSize({ width: v.width, height: v.height });
    await page.emulateMedia({ colorScheme: v.colorScheme });
    await page.waitForTimeout(350);
    await scrollToTop(page);
    await noHorizontalScroll(page);
    await page.screenshot({ path: join(SCREENS, `${v.tag}-${name}.png`) });
  }
  await axeClean(page, name);
  await page.setViewportSize({ width: 1280, height: 800 });
  await page.emulateMedia({ colorScheme: 'light' });
  await page.waitForTimeout(300);
}

/** The newest registration code the server logged for [email]. */
async function registrationCode(email: string): Promise<string> {
  const pattern = new RegExp(`code for ${email.replace(/[.+]/g, '\\$&')}: <([^>]+)>`, 'g');
  let code: string | undefined;
  await expect
    .poll(
      () => {
        const matches = [...readFileSync(SERVER_LOG, 'utf8').matchAll(pattern)];
        code = matches.at(-1)?.[1];
        return code;
      },
      { timeout: 30_000, message: `no registration code for ${email} in ${SERVER_LOG}` },
    )
    .toBeTruthy();
  return code!;
}

/**
 * Types into a Flutter text field. Flutter edits through the DOM input that
 * has focus and renames a field once focused, so the field is clicked
 * first, then the focused input is filled and read back until it holds
 * exactly [text].
 */
async function typeInto(page: Page, field: Locator, text: string): Promise<void> {
  await field.click();
  const focused = page.locator(':focus');
  for (let attempt = 0; attempt < 4; attempt++) {
    await focused.fill(text);
    await page.waitForTimeout(200);
    if ((await focused.inputValue()) === text) return;
  }
  throw new Error(`The field kept a different value than ${text}`);
}

/** Creates an account through SignInWidget's email flow. */
async function signUp(page: Page, email: string): Promise<void> {
  // The widget opens on sign-up when this browser has never signed in, and
  // on sign-in otherwise.
  const email_ = page.getByRole('textbox', { name: 'Email' });
  await expect(email_).toBeAttached({ timeout: 30_000 });
  if ((await button(page, 'Continue').count()) === 0) await button(page, 'Sign up').click();
  await typeInto(page, email_, email);
  await button(page, 'Continue').click();
  const code = await registrationCode(email);
  const pin = page.getByRole('textbox').first();
  await pin.click();
  await page.keyboard.type(code, { delay: 30 });
  const verify = button(page, 'Verify');
  if ((await verify.count()) > 0 && (await verify.isEnabled())) await verify.click();
  // The password field loses its accessible name once focused, so it's
  // found as the only text field on the step.
  await expect(page.getByText('Set account password').first()).toBeAttached({ timeout: 30_000 });
  const password = page.getByRole('textbox').first();
  const signUpButton = button(page, 'Sign up');
  await typeInto(page, password, PASSWORD);
  await expect(signUpButton).toBeEnabled();
  await signUpButton.click();
}

async function newPage(browser: Browser, baseURL: string): Promise<Page> {
  const context = await browser.newContext({ baseURL, viewport: { width: 1280, height: 800 } });
  return context.newPage();
}

test('a new owner sets up a clinic, invites the desk and prints a poster', async ({
  page,
  browser,
  request,
  baseURL,
}) => {
  const stamp = Date.now().toString(36);
  const ownerEmail = `owner-${stamp}@docket.test`;
  const deskEmail = `desk-${stamp}@docket.test`;
  const clinicName = `Ikeja Test ${stamp.toUpperCase()}`;

  // #given a stranger on /owner
  await page.setViewportSize({ width: 1280, height: 800 });
  await page.goto('/owner');
  await enableSemantics(page);
  await expect(page.getByText('Set up and run your clinic').first()).toBeAttached({ timeout: 60_000 });
  await shots(page, '01-sign-in');

  // #when they sign up with a code from their email
  await signUp(page, ownerEmail);

  // #then they land on an empty clinic picker
  await expect(button(page, 'Set up a new clinic')).toBeAttached({ timeout: 30_000 });
  await shots(page, '02-picker');

  await test.step('the wizard sets up the clinic', async () => {
    await button(page, 'Set up a new clinic').click();
    await typeInto(page, page.getByRole('textbox', { name: 'Clinic name' }), clinicName);
    await expect(page.getByText(`/j/ikeja-test-${stamp}`).first()).toBeAttached();
    await shots(page, '03-wizard-clinic');
    await button(page, 'Next').click();

    // Flutter only mirrors a field's value into the DOM while it has focus,
    // so the defaults are checked on the review step instead.
    await expect(page.getByRole('textbox', { name: 'Opens' })).toBeAttached();
    await button(page, 'Next').click();

    await (await reveal(page, button(page, 'Add a line'))).click();
    await typeInto(page, page.getByRole('textbox', { name: 'Line name' }).nth(1), 'Lab');
    await shots(page, '04-wizard-lines');
    await (await reveal(page, button(page, 'Next'))).click();

    await (await reveal(page, button(page, 'Add a room'))).click();
    await (await reveal(page, button(page, 'Lab').nth(1))).click();
    await (await reveal(page, button(page, 'Next'))).click();

    await expect(page.getByText('Room 2 calls from Lab').first()).toBeAttached();
    await expect(page.getByText('Lab, code L, about 8 min per patient').first()).toBeAttached();
    await expect(page.getByText('Opens 08:00, last join 17:00, closes 18:00').first()).toBeAttached();
    await shots(page, '05-wizard-review');
    await (await reveal(page, button(page, 'Set up the clinic'))).click();
    await expect(page.getByText(`${clinicName} is ready`).first()).toBeAttached({ timeout: 30_000 });
    await shots(page, '06-ready');
  });

  let inviteUrl = '';
  await test.step('the poster is a real PDF and the desk invite is a link', async () => {
    const [poster] = await Promise.all([
      page.waitForEvent('popup'),
      (await reveal(page, button(page, 'Open the Consultation poster'))).click(),
    ]);
    const posterUrl = poster.url();
    await poster.close();
    expect(posterUrl).toMatch(new RegExp(`/api/poster/ikeja-test-${stamp}\\?line=C$`));
    // Soft, so a poster failure is reported without hiding the rest of the
    // owner's path behind it.
    const pdf = await request.get(posterUrl);
    expect.soft(pdf.status(), 'the poster route answers 200').toBe(200);
    expect.soft((await pdf.body()).subarray(0, 4).toString('latin1'), 'the poster is a PDF').toBe('%PDF');

    await (await reveal(page, button(page, 'Create a desk invite'))).click();
    const link = page.getByText(/\/invite\//);
    await expect(link).toBeAttached({ timeout: 15_000 });
    inviteUrl = (await link.first().textContent())!.trim();
    expect(inviteUrl).toMatch(/^https?:\/\/.+\/invite\/[A-Za-z0-9_-]{16,}$/);
    await expect(page.getByText(/^Works once, until /).first()).toBeAttached();
  });

  await test.step('the invited person signs up and joins as desk staff', async () => {
    const desk = await newPage(browser, baseURL!);
    await desk.goto(onApp(baseURL!, inviteUrl));
    await enableSemantics(desk);
    await expect(desk.getByText("Join your clinic's staff").first()).toBeAttached({ timeout: 60_000 });
    await shots(desk, '07-invite-sign-in');
    await signUp(desk, deskEmail);
    await expect(desk.getByText(`You're on the staff at ${clinicName} as desk staff.`).first()).toBeAttached({
      timeout: 30_000,
    });
    await expect(button(desk, 'Open the desk')).toBeAttached();
    await shots(desk, '08-invite-accepted');

    // #and the same invite can't be used twice
    await desk.goto(onApp(baseURL!, inviteUrl));
    await enableSemantics(desk);
    await expect(desk.getByText(/invite/i).last()).toBeAttached({ timeout: 30_000 });
    await desk.context().close();
  });

  await test.step('the console shows today, settings and staff', async () => {
    await (await reveal(page, button(page, 'Open the console'))).click();
    await expect(page.getByText('Open today').or(page.getByText('Not opened yet today')).first()).toBeAttached({
      timeout: 30_000,
    });
    await expect(page.getByText('Consultation').first()).toBeAttached();
    await shots(page, '09-today');

    await button(page, 'Staff').click();
    await expect(page.getByText('Desk', { exact: true }).last()).toBeAttached({ timeout: 15_000 });
    await shots(page, '10-staff');

    await button(page, 'Settings').click();
    const grace = page.getByRole('textbox', { name: 'Time to confirm' });
    await typeInto(page, grace, '30');
    await (await reveal(page, button(page, 'Save settings'))).click();
    await expect(page.getByText('Time to confirm has to be between 60 and 900.').first()).toBeAttached();
    await shots(page, '11-settings-refused');

    await scrollToTop(page);
    await typeInto(page, grace, '240');
    const zone = page.getByRole('textbox', { name: 'Timezone' });
    await typeInto(page, await reveal(page, zone), 'Mars/Olympus');
    await (await reveal(page, button(page, 'Save settings'))).click();
    await expect(page.getByText("That timezone isn't known.").first()).toBeAttached({ timeout: 15_000 });

    await typeInto(page, await reveal(page, zone), 'Africa/Lagos');
    await (await reveal(page, button(page, 'Save settings'))).click();
    await expect(page.getByText('Settings saved.').first()).toBeAttached({ timeout: 15_000 });
    await expect(
      page.getByText('Texts need Twilio set up on the server. Until then Docket uses push alerts only.')
        .or(page.getByText('Text patients')).first(),
    ).toBeAttached();

    await scrollToTop(page);
    await button(page, 'Lines and rooms').click();
    const taking = page.getByRole('switch', { name: /Taking new patients/ });
    await expect(taking).toHaveCount(2);
    await expect(taking.nth(1)).toBeChecked();
    await (await reveal(page, taking.nth(1))).click();
    await expect(page.getByText('Line saved.').first()).toBeAttached({ timeout: 15_000 });
    await expect(taking.nth(1)).not.toBeChecked();
    await scrollToTop(page);
    await shots(page, '12-lines-rooms');
  });

  await test.step('posters, board, reports and audit', async () => {
    await scrollToTop(page);
    await button(page, 'Posters').click();
    await expect(button(page, 'Lab poster, code L')).toBeAttached();
    await shots(page, '13-posters');

    await button(page, 'Board').click();
    await (await reveal(page, button(page, 'Rotate the board link'))).click();
    await button(page, 'Make a new link').click();
    await expect(page.getByText(/\/b\//).first()).toBeAttached({ timeout: 15_000 });
    await shots(page, '14-board');

    await scrollToTop(page);
    await button(page, 'Reports').click();
    await expect(page.getByText('Arrivals by hour').first()).toBeAttached({ timeout: 15_000 });
    await shots(page, '15-reports');
    const [csv] = await Promise.all([
      page.waitForEvent('download'),
      (await reveal(page, button(page, 'Download CSV'))).click(),
    ]);
    expect(csv.suggestedFilename()).toMatch(new RegExp(`^docket-ikeja-test-${stamp}-\\d{4}-\\d{2}-\\d{2}\\.csv$`));

    await scrollToTop(page);
    await button(page, 'Audit').click();
    await expect(page.getByText('Events').first()).toBeAttached();
    await shots(page, '16-audit');
  });
});

test('a sandbox visitor from /try arrives in their sandbox clinic without signing in', async ({
  page,
  request,
}) => {
  // #given a sandbox started the way /try starts it, remembered in this browser
  const sandbox = await api<{ clinicId: string; clinicSlug: string; sandboxToken: string; boardUrl: string }>(
    request,
    'sandbox',
    'start',
    {},
  );
  const raw = JSON.stringify(sandbox);
  await page.goto('/owner');
  await page.evaluate((value) => window.localStorage.setItem('docket.sandbox', value), raw);

  // #when they open the owner console
  await page.goto('/owner');
  await enableSemantics(page);

  // #then they're in the sandbox clinic, with its board link known
  await expect(page.getByText("This is your sandbox clinic. It's deleted 24 hours after you made it.").first()).toBeAttached({
    timeout: 60_000,
  });
  await expect(button(page, 'Sign in to set up a real clinic')).toBeAttached();
  await shots(page, '17-sandbox-today');
  await button(page, 'Board').click();
  await expect(page.getByText(new URL(sandbox.boardUrl).pathname, { exact: false }).first()).toBeAttached();
  await shots(page, '18-sandbox-board');
  expect(sandbox.clinicSlug).toMatch(/^sandbox-/);

  // #when demo patients join and one is called, the report and the audit
  // show it
  const desk = await api<{ lines: { id: string; code: string }[]; rooms: { id: string; name: string }[] }>(
    request,
    'desk',
    'getView',
    { clinicId: sandbox.clinicId, sandboxToken: sandbox.sandboxToken },
  );
  await api(request, 'sandbox', 'addDemoWalkIns', {
    sandboxToken: sandbox.sandboxToken,
    lineId: desk.lines.find((l) => l.code === 'C')!.id,
    count: 4,
  });
  await api(request, 'desk', 'act', {
    action: {
      __className__: 'CallNextAction',
      actionId: crypto.randomUUID(),
      deviceId: crypto.randomUUID(),
      seq: 1,
      issuedAtLocal: new Date().toISOString(),
      roomId: desk.rooms.find((r) => r.name === 'Room 1')!.id,
    },
    sandboxToken: sandbox.sandboxToken,
  });
  await scrollToTop(page);
  await button(page, 'Reports').click();
  await expect(page.getByRole('group', { name: /Arrivals by hour\. 4 in all/ })).toBeAttached({ timeout: 15_000 });
  await expect(page.getByRole('table', { name: 'Arrivals by hour' })).toBeAttached();
  await shots(page, '19-sandbox-reports');
  await scrollToTop(page);
  await button(page, 'Audit').click();
  await expect(page.getByText(/C-001\s+Called/).first()).toBeAttached({ timeout: 15_000 });
  await typeInto(page, page.getByRole('textbox', { name: 'Filter by ticket label' }), 'C-002');
  await expect(page.getByText(/C-001\s+Called/)).toHaveCount(0);
  await shots(page, '20-sandbox-audit');
});
