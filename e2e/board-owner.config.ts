import { defineConfig, devices } from '@playwright/test';

// The board and owner specs. They drive a Flutter build against the real
// local API server, so point BOARD_OWNER_BASE_URL at the Flutter app and
// DOCKET_API_URL at the API server. Run with
// `npx playwright test -c board-owner.config.ts`.
export default defineConfig({
  testDir: '.',
  testMatch: /(board|owner)\.spec\.ts$/,
  fullyParallel: false,
  workers: 1,
  retries: 0,
  timeout: 360_000,
  reporter: [['list']],
  // Other agents run Playwright from this folder too, so keep artifacts apart.
  outputDir: 'test-results/board-owner',
  use: {
    ...devices['Desktop Chrome'],
    baseURL: process.env.BOARD_OWNER_BASE_URL ?? 'http://localhost:9103',
    trace: 'retain-on-failure',
    screenshot: 'only-on-failure',
  },
});
