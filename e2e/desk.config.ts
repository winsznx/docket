import { tmpdir } from 'node:os';
import { join } from 'node:path';

import { defineConfig, devices } from '@playwright/test';

// The desk and offline specs. They drive a desk build against the real local
// API server, so point DESK_BASE_URL at the Flutter app and DOCKET_API_URL at
// the API server. Run with `npx playwright test -c desk.config.ts`.
export default defineConfig({
  testDir: '.',
  testMatch: /(desk|offline)\.spec\.ts$/,
  fullyParallel: false,
  workers: 1,
  retries: 0,
  timeout: 360_000,
  reporter: [['list']],
  // Kept apart from test-results/, which other suites on this machine clear.
  outputDir: process.env.DESK_OUTPUT_DIR ?? join(tmpdir(), 'docket-desk-e2e'),
  use: {
    ...devices['Desktop Chrome'],
    baseURL: process.env.DESK_BASE_URL ?? 'http://localhost:9102',
    trace: 'retain-on-failure',
  },
});
