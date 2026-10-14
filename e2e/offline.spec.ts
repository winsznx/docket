import { expect, test } from '@playwright/test';

import {
  api,
  button,
  deskView,
  enableSemantics,
  openSandboxDesk,
  pressWithinQuota,
  reveal,
  said,
  scrollToTop,
  serverState,
  shot,
} from './desk-helpers';

// PRD 22.3 and 15: the desk keeps calling through an outage, replays its
// outbox when the connection returns, the server's answer wins, and the
// patient's own page catches up. Then a reload during an outage still opens
// the desk from this device.

type JoinResult = { ticketToken: string; view: { label: string } };

test('offline desk: two calls saved, synced, and the patient sees theirs', async ({ browser, request }) => {
  const deskContext = await browser.newContext({ viewport: { width: 1280, height: 800 } });
  const page = await deskContext.newPage();

  // #given a sandbox desk, a patient who joined from their own phone, and
  // five demo patients behind them
  const sandbox = await openSandboxDesk(page);
  const consultation = (await deskView(request, sandbox)).lines.find((l) => l.code === 'C')!;
  const joined = await api<JoinResult>(request, 'publicClinic', 'join', {
    request: {
      clinicSlug: sandbox.clinicSlug,
      lineId: consultation.id,
      displayName: 'AO',
      smsConsent: false,
    },
  });
  expect(joined.view.label).toBe('C-001');

  const phoneContext = await browser.newContext({ viewport: { width: 390, height: 844 } });
  const phone = await phoneContext.newPage();
  await phone.goto(`/t/${joined.ticketToken}`);
  await enableSemantics(phone);

  await pressWithinQuota(
    page,
    await reveal(page, button(page, 'Add 5 demo walk-ins')),
    page.getByRole('heading', { name: 'Consultation 6 waiting' }),
  );
  await scrollToTop(page);

  // #when the desk loses its connection and calls next twice
  await deskContext.setOffline(true);
  await expect(said(page, 'Offline, calls are saved on this device')).toBeAttached();
  await button(page, 'Call next').click();
  await expect(said(page, /Waiting to sync\. The patient is notified/)).toBeAttached();
  await button(page, 'Call next').click();
  await expect(said(page, '2 actions waiting')).toBeAttached();
  await shot(page, 'offline-01-two-calls-saved');

  // #then the server hasn't heard either call yet
  expect(await serverState(request, sandbox, 'C-001')).toBe('waiting');
  expect(await serverState(request, sandbox, 'C-002')).toBe('waiting');

  // #when the connection comes back
  await deskContext.setOffline(false);

  // #then the outbox syncs in order and the server has both calls
  await expect.poll(() => serverState(request, sandbox, 'C-001'), { timeout: 30_000 }).toBe('called');
  await expect.poll(() => serverState(request, sandbox, 'C-002')).toBe('called');
  await expect(said(page, 'Online')).toBeAttached({ timeout: 30_000 });
  await expect(said(page, 'Offline, calls are saved on this device')).toHaveCount(0);

  // #then nothing was turned down, so there's nothing to review
  await expect(said(page, /to review/)).toHaveCount(0);
  await expect(said(page, "The server didn't take these")).toHaveCount(0);
  await expect(said(page, /to confirm/)).toBeAttached();
  await shot(page, 'offline-02-synced');

  // #then the patient's own page shows their call
  await expect(said(phone, /Your turn/)).toBeAttached({ timeout: 30_000 });
  await phone.waitForTimeout(500);
  await phone.screenshot({ path: `${__dirname}/screens/desk/offline-03-patient-called.png` });

  // #given the desk has been opened once with its service worker in control,
  // which is when the worker caches the app shell (PRD 15.6). The first
  // visit registers the worker after the shell has already loaded.
  await page.reload();
  await enableSemantics(page);
  await expect(button(page, 'Start service').first()).toBeAttached({ timeout: 30_000 });
  await expect
    .poll(() => page.evaluate(() => navigator.serviceWorker.controller !== null))
    .toBe(true);

  // #when the desk reloads in the middle of another outage
  await deskContext.setOffline(true);
  await page.reload();
  await enableSemantics(page);

  // #then it opens from this device with the calls it had
  await expect(said(page, 'Offline, calls are saved on this device')).toBeAttached({ timeout: 30_000 });
  await expect(said(page, (await deskView(request, sandbox)).clinicName)).toBeAttached();
  await expect(button(page, 'Start service').first()).toBeAttached();
  await shot(page, 'offline-04-reloaded-offline');

  await deskContext.setOffline(false);
  await phoneContext.close();
  await deskContext.close();
});

test('a call the server turns down waits in the corrections drawer', async ({ browser, request }) => {
  const deskContext = await browser.newContext({ viewport: { width: 1280, height: 800 } });
  const page = await deskContext.newPage();

  // #given a sandbox desk with two patients who joined from their phones
  const sandbox = await openSandboxDesk(page);
  const consultation = (await deskView(request, sandbox)).lines.find((l) => l.code === 'C')!;
  const join = (name: string): Promise<JoinResult> =>
    api<JoinResult>(request, 'publicClinic', 'join', {
      request: { clinicSlug: sandbox.clinicSlug, lineId: consultation.id, displayName: name, smsConsent: false },
    });
  const first = await join('AB');
  await join('CD');
  await expect(page.getByRole('heading', { name: 'Consultation 2 waiting' })).toBeAttached();

  // #when the desk, offline, calls the first patient by name
  await deskContext.setOffline(true);
  await expect(said(page, 'Offline, calls are saved on this device')).toBeAttached();
  await page.getByRole('button', { name: /Options for C-001/ }).click();
  await said(page, 'Call this patient').click();
  await expect(said(page, /Waiting to sync/)).toBeAttached();

  // #and that patient leaves the line from their phone meanwhile
  await api(request, 'ticket', 'leave', { token: first.ticketToken });

  // #when the connection comes back
  await deskContext.setOffline(false);

  // #then the server's message waits in the drawer with the next step
  await expect(said(page, "The server didn't take these")).toBeAttached({ timeout: 30_000 });
  await expect(said(page, 'C-001 had already left the line.')).toBeAttached();
  await expect(said(page, 'Call C-001 to Room 1').or(said(page, /Call a patient to Room 1/))).toBeAttached();
  await shot(page, 'offline-05-corrections-drawer');

  // #then the obvious next step calls the next patient, and the drawer is done
  await page.getByRole('button', { name: 'Call next' }).last().click();
  await expect.poll(() => serverState(request, sandbox, 'C-002'), { timeout: 30_000 }).toBe('called');
  await expect(said(page, "The server didn't take these")).toHaveCount(0);
  await expect(said(page, /to review/)).toHaveCount(0);
  await deskContext.close();
});
