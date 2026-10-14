import { tmpdir } from 'node:os';
import { join } from 'node:path';

import { defineConfig, devices } from '@playwright/test';

// The live smoke from BUILD.md 5.9: the home page, /try through to a called
// phone, and /livez. Defaults to the deployed app. For a local run:
// LIVE_BASE_URL=http://localhost:8082 LIVE_API_URL=http://localhost:8080 npx playwright test -c live.config.ts
export default defineConfig({
  testDir: '.',
  testMatch: /live-smoke\.spec\.ts$/,
  fullyParallel: false,
  workers: 1,
  retries: 0,
  timeout: 300_000,
  reporter: [['list']],
  outputDir: join(tmpdir(), 'docket-live-e2e'),
  use: {
    ...devices['Desktop Chrome'],
    baseURL: process.env.LIVE_BASE_URL ?? 'https://docket.serverpod.space',
    trace: 'retain-on-failure',
  },
});
