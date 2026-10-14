import { join } from 'node:path';

import { defineConfig, devices } from '@playwright/test';

// PRD 23 browser measurements: first paint on Fast 3G and reconnect time.
// Results append to measurements/*.tsv. Defaults to the live app.
export default defineConfig({
  testDir: '.',
  testMatch: /measure-.*\.spec\.ts$/,
  fullyParallel: false,
  workers: 1,
  retries: 0,
  timeout: 600_000,
  reporter: [['list']],
  outputDir: join(__dirname, 'test-results', 'measure'),
  use: {
    ...devices['Pixel 7'],
    baseURL: process.env.MEASURE_BASE_URL ?? 'https://docket.serverpod.space',
  },
});
