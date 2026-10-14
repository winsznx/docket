import { join } from 'node:path';

import { defineConfig, devices } from '@playwright/test';

// Film and GIF capture (PRD 26 and 28). Drives the real app with a visible
// cursor and records the desk and the phone as separate videos, which
// capture/stitch.sh puts side by side. CAPTURE_BASE_URL defaults to the
// live app.
export default defineConfig({
  testDir: '.',
  testMatch: /capture\.spec\.ts$/,
  fullyParallel: false,
  workers: 1,
  retries: 0,
  timeout: 600_000,
  reporter: [['list']],
  outputDir: join(__dirname, 'videos', 'raw'),
  use: {
    ...devices['Desktop Chrome'],
    baseURL: process.env.CAPTURE_BASE_URL ?? 'https://docket.serverpod.space',
  },
});
