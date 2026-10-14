import { defineConfig, devices } from '@playwright/test';

// The patient surface checks. Point BASE_URL at a running Flutter web build
// that talks to the local API server, the patient agent's is on 9101.
//
//   npx playwright test -c patient.config.ts
export default defineConfig({
  testDir: '.',
  testMatch: /patient\.spec\.ts$/,
  fullyParallel: false,
  workers: 1,
  retries: 0,
  reporter: [['list']],
  use: {
    ...devices['Desktop Chrome'],
    baseURL: process.env.BASE_URL ?? 'http://localhost:9101',
    trace: 'retain-on-failure',
  },
});
