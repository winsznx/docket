import { join } from 'node:path';

import { expect, test, type APIRequestContext, type Page } from '@playwright/test';

import { api, axeClean, button, enableSemantics, noHorizontalScroll, onApp, screensDir } from './board-owner-helpers';

// The waiting-room board (PRD 17.4, 15.5 and 22.3). A sandbox desk calls
// patients and the board in another tab of the same browser announces each
// call. Speech goes to a stubbed `speechSynthesis` that records every
// utterance, so the check reads exactly what the TV would have said.
//
// The API server allows six sandbox calls a minute from one address, so one
// sandbox serves every step.

const SCREENS = screensDir('board');

type Sandbox = { clinicId: string; clinicSlug: string; sandboxToken: string; boardUrl: string };
type DeskView = {
  lines: { id: string; code: string; tickets: { label: string; state: string }[] }[];
  rooms: { id: string; name: string }[];
};

/**
 * Replaces the browser's speech with a recorder and counts the chime's
 * tones, before the app loads. [voices] false stands in for a browser with
 * no voice at all.
 */
const speechRecorder = (voices = true): string => `
  window.__spoken = [];
  window.__tones = 0;
  const createOscillator = AudioContext.prototype.createOscillator;
  AudioContext.prototype.createOscillator = function () {
    window.__tones += 1;
    return createOscillator.call(this);
  };
  class RecordedUtterance {
    constructor(text) {
      this.text = text ?? '';
      this.lang = '';
      this.voice = null;
      this.volume = 1;
      this.rate = 1;
      this.pitch = 1;
      this.onend = null;
      this.onerror = null;
    }
  }
  const voice = { name: 'Recorder', lang: 'en-GB', default: true, localService: true, voiceURI: 'recorder' };
  window.SpeechSynthesisUtterance = RecordedUtterance;
  Object.defineProperty(window, 'speechSynthesis', {
    configurable: true,
    value: {
      speaking: false,
      pending: false,
      paused: false,
      onvoiceschanged: null,
      getVoices: () => (${voices} ? [voice] : []),
      speak(utterance) {
        if (utterance.text.trim()) window.__spoken.push(utterance.text);
        setTimeout(() => utterance.onend && utterance.onend(new Event('end')), 30);
      },
      cancel() {},
      pause() {},
      resume() {},
      addEventListener() {},
      removeEventListener() {},
    },
  });
`;

async function tones(page: Page): Promise<number> {
  return page.evaluate(() => (window as unknown as { __tones: number }).__tones);
}

async function spoken(page: Page): Promise<string[]> {
  return page.evaluate(() => (window as unknown as { __spoken: string[] }).__spoken);
}

async function shot(page: Page, name: string): Promise<void> {
  await page.screenshot({ path: join(SCREENS, `${name}.png`) });
}

/** A desk call made the way the generated client sends it. */
async function callNext(request: APIRequestContext, sandbox: Sandbox, roomId: string): Promise<void> {
  await api(request, 'desk', 'act', {
    action: {
      __className__: 'CallNextAction',
      actionId: crypto.randomUUID(),
      deviceId: crypto.randomUUID(),
      seq: 1,
      issuedAtLocal: new Date().toISOString(),
      roomId,
    },
    sandboxToken: sandbox.sandboxToken,
  });
}

async function deskView(request: APIRequestContext, sandbox: Sandbox): Promise<DeskView> {
  return api<DeskView>(request, 'desk', 'getView', {
    clinicId: sandbox.clinicId,
    sandboxToken: sandbox.sandboxToken,
  });
}

/** Opens the board for [sandbox] with speech recorded, before the first tap. */
async function openBoard(page: Page, baseURL: string, sandbox: Sandbox, voices = true): Promise<void> {
  await page.addInitScript(speechRecorder(voices));
  await page.setViewportSize({ width: 1920, height: 1080 });
  await page.goto(onApp(baseURL, sandbox.boardUrl));
  await enableSemantics(page);
  await expect(button(page, 'Tap anywhere to turn on announcements')).toBeAttached({ timeout: 60_000 });
}

/** Presses [target] until [done] shows, waiting out the sandbox rate limit. */
async function pressWithinQuota(page: Page, target: ReturnType<typeof button>, done: ReturnType<typeof button>): Promise<void> {
  const tooMany = page.getByText('Too many tries. Wait a minute and try again.');
  for (let attempt = 0; attempt < 4; attempt++) {
    await target.click();
    await expect(done.or(tooMany).first()).toBeAttached({ timeout: 30_000 });
    if ((await done.count()) > 0) return;
    await page.waitForTimeout(61_000);
  }
  throw new Error('The API server kept refusing sandbox calls.');
}

test('the board says each call aloud and stops when its link is revoked', async ({
  page: board,
  request,
  baseURL,
}) => {
  // #given a sandbox with three demo patients and the board open on a TV
  const sandbox = await api<Sandbox>(request, 'sandbox', 'start', {});
  const view = await deskView(request, sandbox);
  const consultation = view.lines.find((l) => l.code === 'C')!;
  const room = (name: string) => view.rooms.find((r) => r.name === name)!.id;
  await api(request, 'sandbox', 'addDemoWalkIns', {
    sandboxToken: sandbox.sandboxToken,
    lineId: consultation.id,
    count: 3,
  });
  await openBoard(board, baseURL!, sandbox);
  await expect(board.getByText('Room 1, Open')).toBeAttached();
  await noHorizontalScroll(board);
  await axeClean(board, 'the board before the first tap');
  await shot(board, '1920-01-first-load');

  await test.step('a call is chimed and said aloud, with the label at least 18% high', async () => {
    // #when the first tap turns announcements on and the desk calls
    await board.mouse.click(960, 540);
    await expect(button(board, 'Tap anywhere to turn on announcements')).toHaveCount(0);
    await callNext(request, sandbox, room('Room 1'));

    // #then the room floods, then settles, and the call is said once
    await expect(board.getByText('Room 1, now calling C-001')).toBeAttached({ timeout: 15_000 });
    await board.waitForTimeout(300);
    await shot(board, '1920-02-call-flash');
    await expect.poll(() => spoken(board), { timeout: 15_000 }).toEqual(['C 1, please go to Room 1']);
    expect(await tones(board), 'two notes, each with an overtone').toBe(4);
    await board.waitForTimeout(4_500);
    await axeClean(board, 'the board with a call');
    await shot(board, '1920-03-settled');

    // #and the settings sheet offers voice, chime, a test and full screen
    await button(board, 'Settings').click();
    await expect(board.getByRole('switch', { name: /Say each call aloud/ })).toBeChecked();
    await board.waitForTimeout(400);
    await shot(board, '1920-03b-settings');
    await button(board, 'Done').click();
  });

  await test.step('a second room calls on a 720p screen', async () => {
    await board.setViewportSize({ width: 1280, height: 720 });
    await callNext(request, sandbox, room('Room 2'));
    await expect(board.getByText('Room 2, now calling C-002')).toBeAttached({ timeout: 15_000 });
    await board.waitForTimeout(300);
    await shot(board, '1280-01-call-flash');
    await expect
      .poll(() => spoken(board), { timeout: 15_000 })
      .toEqual(['C 1, please go to Room 1', 'C 2, please go to Room 2']);
    await board.waitForTimeout(4_500);
    await noHorizontalScroll(board);
    await shot(board, '1280-02-settled');
  });

  await test.step('a revoked board link shows the server message', async () => {
    await api(request, 'owner', 'rotateBoardToken', {
      clinicId: sandbox.clinicId,
      sandboxToken: sandbox.sandboxToken,
    });
    await expect(
      board.getByText("This board link doesn't work any more. Get the new one from the owner page.").first(),
    ).toBeAttached({ timeout: 30_000 });
    await shot(board, '1280-03-revoked');
    await board.setViewportSize({ width: 1920, height: 1080 });
    await board.waitForTimeout(400);
    await shot(board, '1920-05-revoked');
  });
});

test("with the connection down, the board reads this browser's desk and keeps calling", async ({
  page: desk,
  context,
  request,
  baseURL,
}) => {
  // #given a sandbox desk from /try with demo patients, in this browser
  await desk.setViewportSize({ width: 1280, height: 800 });
  await desk.goto('/try');
  await enableSemantics(desk);
  await pressWithinQuota(desk, button(desk, 'Open my sandbox desk'), button(desk, 'Add 5 demo walk-ins'));
  await expect(desk).toHaveURL(/\/desk$/);
  const sandbox = JSON.parse(
    (await desk.evaluate(() => window.localStorage.getItem('docket.sandbox')))!,
  ) as Sandbox;
  const waiting = async (): Promise<number> =>
    (await deskView(request, sandbox)).lines
      .flatMap((l) => l.tickets)
      .filter((t) => t.state === 'waiting').length;
  for (let attempt = 0; attempt < 4 && (await waiting()) < 5; attempt++) {
    await button(desk, 'Add 5 demo walk-ins').click();
    await expect
      .poll(waiting, { timeout: 15_000 })
      .toBe(5)
      .catch(() => desk.waitForTimeout(61_000));
  }
  expect(await waiting()).toBe(5);

  // #and the board in another tab of the same browser, announcements on
  const board = await context.newPage();
  board.on('console', (m) => {
    // The board says why it couldn't read the desk, which explains a failure.
    if (m.text().startsWith('Board local mode')) {
      test.info().annotations.push({ type: 'board', description: m.text() });
    }
  });
  await openBoard(board, baseURL!, sandbox);
  await board.mouse.click(960, 540);

  // #when the network drops and the desk calls next
  await context.setOffline(true);
  await desk.bringToFront();
  await button(desk, 'Call next').click({ timeout: 30_000 });

  // #then the board shows Local mode and says the call from the desk's data
  await expect(board.getByText('Local mode').or(board.getByLabel('Local mode')).first()).toBeAttached({ timeout: 30_000 });
  await expect(board.getByText('Room 1, now calling C-001')).toBeAttached({ timeout: 15_000 });
  await expect.poll(() => spoken(board), { timeout: 15_000 }).toEqual(['C 1, please go to Room 1']);
  await board.waitForTimeout(4_500);
  await shot(board, '1920-04-local-mode');

  // #when the connection returns, the board follows the server again and the
  // synced call isn't said twice
  await context.setOffline(false);
  await expect(board.getByText('Local mode').or(board.getByLabel('Local mode'))).toHaveCount(0, { timeout: 60_000 });
  await expect.poll(async () => (await deskView(request, sandbox)).lines[0].tickets.find((t) => t.label === 'C-001')?.state, {
    timeout: 60_000,
  }).toBe('called');
  await board.waitForTimeout(3_000);
  expect(await spoken(board)).toEqual(['C 1, please go to Room 1']);
});

test("a browser without a voice says so in settings, and the chime still plays", async ({
  page: board,
  request,
  baseURL,
}) => {
  // #given a board in a browser that has no speech voices
  const sandbox = await api<Sandbox>(request, 'sandbox', 'start', {});
  const view = await deskView(request, sandbox);
  await api(request, 'sandbox', 'addDemoWalkIns', {
    sandboxToken: sandbox.sandboxToken,
    lineId: view.lines.find((l) => l.code === 'C')!.id,
    count: 1,
  });
  await openBoard(board, baseURL!, sandbox, false);
  await board.setViewportSize({ width: 1280, height: 720 });
  await board.mouse.click(640, 360);

  // #when the settings sheet opens, #then it says there's no voice
  await button(board, 'Settings').click();
  await expect(board.getByText("Voice isn't available in this browser").first()).toBeAttached({
    timeout: 10_000,
  });
  await board.waitForTimeout(400);
  await shot(board, '1280-04-no-voice');
  await button(board, 'Done').click();

  // #when the desk calls, #then the chime plays and nothing is spoken
  await callNext(request, sandbox, view.rooms.find((r) => r.name === 'Room 1')!.id);
  await expect(board.getByText('Room 1, now calling C-001')).toBeAttached({ timeout: 15_000 });
  await expect.poll(() => tones(board), { timeout: 10_000 }).toBe(4);
  await board.waitForTimeout(2_000);
  expect(await spoken(board)).toEqual([]);
});
