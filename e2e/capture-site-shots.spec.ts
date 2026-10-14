import { writeFileSync } from 'node:fs';
import { join } from 'node:path';

import { expect, test, type Browser, type Page } from '@playwright/test';

// Captures the real screenshots the site's /patients and /clinics pages show,
// from the running Flutter app, through the /try sandbox. Nothing is posted
// directly: every step drives the UI a visitor would use.
//
//   BASE_URL=http://localhost:8082 npm run shots
//
// The pages show a figure only once its file exists, so a failed or partial
// run leaves the site without that figure, never with a stand-in.
//
// The app renders to a canvas, so the steps find controls through Flutter's
// semantics tree by role and accessible name. If the app's copy changes,
// adjust the constants below rather than the steps.

const SANDBOX_PATH = '/try';
const OWNER_PATH = '/owner';

const UI = {
  openSandboxDesk: { role: 'button', name: 'Open my sandbox desk' },
  addDemoWalkIns: { role: 'button', name: 'Add 5 demo walk-ins' },
  callNext: { role: 'button', name: 'Call next' },
  openBoard: { role: 'button', name: 'Open the waiting-room board in a new tab' },
  joinLine: { role: 'button', name: 'Join the line' },
  patientName: { role: 'textbox', name: 'Initials or first name' },
  boardSoundPrompt: 'Tap anywhere to turn on announcements',
} as const;

// Text the desk shows once it has loaded, and that the patient ticket shows
// once it has loaded.
const DESK_READY_TEXT = 'Call next';
const TICKET_READY_TEXT = /in line/;

// Where the join link for the sandbox shows on the desk. The desk's side panel
// carries the same URL its QR code encodes.
const JOIN_LINK_PATTERN = /\/j\/[A-Za-z0-9-]+(\?line=[A-Za-z])?/;

const PATIENT_NAME = 'TA';

const IMG_DIR = join(__dirname, '..', 'docket_server', 'web', 'site', 'img');

// The patient shot is shown at 390 CSS px on /patients, so it's captured at
// 390 px wide and twice the pixel density.
const SHOTS = {
  patientTicket: { file: 'shot-patient-ticket.webp', viewport: { width: 390, height: 844 }, deviceScaleFactor: 2 },
  desk: { file: 'shot-desk.webp', viewport: { width: 1280, height: 800 }, deviceScaleFactor: 1 },
  board: { file: 'shot-board.webp', viewport: { width: 1280, height: 720 }, deviceScaleFactor: 1 },
  owner: { file: 'shot-owner.webp', viewport: { width: 1280, height: 800 }, deviceScaleFactor: 1 },
} as const;

const WEBP_QUALITY = 0.86;

type Control = { role: 'button' | 'textbox' | 'link'; name: string };

function control(page: Page, c: Control) {
  return page.getByRole(c.role, { name: c.name });
}

// Flutter builds its semantics tree only after the placeholder is activated.
async function enableSemantics(page: Page): Promise<void> {
  await page.locator('flt-semantics-placeholder, flutter-view').first().waitFor({ state: 'attached', timeout: 30_000 });
  await page.evaluate(() => {
    const placeholder = document.querySelector('flt-semantics-placeholder');
    if (placeholder instanceof HTMLElement) placeholder.click();
  });
}

async function openFlutterPage(page: Page, path: string, readyText: string | RegExp): Promise<void> {
  await page.goto(path);
  await enableSemantics(page);
  await expect(page.getByText(readyText).first()).toBeVisible({ timeout: 30_000 });
}

// The semantics tree carries text both as DOM text and as aria-labels.
async function findJoinPath(page: Page): Promise<string> {
  const text = await page.evaluate(() =>
    [
      document.body.innerText,
      ...Array.from(document.querySelectorAll('[aria-label]'), (el) => el.getAttribute('aria-label') ?? ''),
      ...Array.from(document.querySelectorAll('a[href]'), (el) => el.getAttribute('href') ?? ''),
    ].join('\n'),
  );
  const joinPath = text.match(JOIN_LINK_PATTERN)?.[0];
  if (!joinPath) throw new Error(`No join link matching ${JOIN_LINK_PATTERN} on the sandbox desk`);
  return joinPath;
}

// Playwright writes PNG, so Chromium's own canvas encoder turns it into WebP.
async function saveAsWebp(browser: Browser, png: Buffer, file: string): Promise<void> {
  const page = await browser.newPage();
  try {
    const dataUrl = await page.evaluate(
      async ({ base64, quality }) => {
        const image = new Image();
        image.src = `data:image/png;base64,${base64}`;
        await image.decode();
        const canvas = document.createElement('canvas');
        canvas.width = image.naturalWidth;
        canvas.height = image.naturalHeight;
        const context = canvas.getContext('2d');
        if (!context) throw new Error('No 2D canvas context');
        context.drawImage(image, 0, 0);
        return canvas.toDataURL('image/webp', quality);
      },
      { base64: png.toString('base64'), quality: WEBP_QUALITY },
    );
    if (!dataUrl.startsWith('data:image/webp;base64,')) {
      throw new Error(`Chromium did not encode WebP for ${file}`);
    }
    writeFileSync(join(IMG_DIR, file), Buffer.from(dataUrl.split(',')[1], 'base64'));
  } finally {
    await page.close();
  }
}

test('captures the desk, board, owner and patient screens from the sandbox', async ({ browser, browserName }) => {
  test.skip(browserName !== 'chromium', 'WebP encoding uses Chromium');
  test.setTimeout(180_000);

  // #given a fresh sandbox clinic, opened the way a visitor opens it
  const deskContext = await browser.newContext({
    viewport: SHOTS.desk.viewport,
    deviceScaleFactor: SHOTS.desk.deviceScaleFactor,
    colorScheme: 'light',
  });
  const desk = await deskContext.newPage();
  await openFlutterPage(desk, SANDBOX_PATH, UI.openSandboxDesk.name);
  await control(desk, UI.openSandboxDesk).click();
  await expect(desk.getByText(DESK_READY_TEXT).first()).toBeVisible({ timeout: 30_000 });
  await enableSemantics(desk);
  await control(desk, UI.addDemoWalkIns).click();

  const joinPath = await findJoinPath(desk);

  // #when a patient joins from a phone and the desk calls the next patient
  const phoneContext = await browser.newContext({
    viewport: SHOTS.patientTicket.viewport,
    deviceScaleFactor: SHOTS.patientTicket.deviceScaleFactor,
    colorScheme: 'light',
    isMobile: true,
    hasTouch: true,
  });
  const phone = await phoneContext.newPage();
  await openFlutterPage(phone, joinPath, UI.joinLine.name);
  await control(phone, UI.patientName).fill(PATIENT_NAME);
  await control(phone, UI.joinLine).click();
  await expect(phone.getByText(TICKET_READY_TEXT).first()).toBeVisible({ timeout: 30_000 });

  await control(desk, UI.callNext).click();
  await desk.waitForTimeout(1_500);

  // #then each screen is saved as WebP for the site
  await saveAsWebp(browser, await desk.screenshot(), SHOTS.desk.file);
  await saveAsWebp(browser, await phone.screenshot(), SHOTS.patientTicket.file);

  const [board] = await Promise.all([deskContext.waitForEvent('page'), control(desk, UI.openBoard).click()]);
  await board.setViewportSize(SHOTS.board.viewport);
  await board.waitForLoadState('load');
  await enableSemantics(board);
  // The board asks for a tap before it may play sound. The shot shows the
  // board after that tap, the way it runs in a waiting room.
  const soundPrompt = board.getByText(UI.boardSoundPrompt);
  const asksForTap = await soundPrompt.waitFor({ state: 'visible', timeout: 15_000 }).then(
    () => true,
    () => false,
  );
  if (asksForTap) {
    await board.mouse.click(SHOTS.board.viewport.width / 2, SHOTS.board.viewport.height / 2);
    await expect(soundPrompt).toBeHidden();
  }
  await board.waitForTimeout(1_500);
  await saveAsWebp(browser, await board.screenshot(), SHOTS.board.file);

  const owner = await deskContext.newPage();
  await owner.setViewportSize(SHOTS.owner.viewport);
  await openFlutterPage(owner, OWNER_PATH, /./);
  await owner.waitForTimeout(1_500);
  await saveAsWebp(browser, await owner.screenshot(), SHOTS.owner.file);

  await phoneContext.close();
  await deskContext.close();
});
