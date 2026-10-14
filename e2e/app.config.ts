import { tmpdir } from 'node:os';
import { join } from 'node:path';

import { defineConfig, devices } from '@playwright/test';

// DESIGN.md section 7 for every Flutter route. Point APP_BASE_URL at a
// server that serves the built app (the web server, not `flutter run`) and
// APP_API_URL at its API server.
export default defineConfig({
  testDir: '.',
  testMatch: /app-sweep\.spec\.ts$/,
  fullyParallel: true,
  workers: 4,
  retries: 0,
  timeout: 120_000,
  reporter: [['list']],
  outputDir: join(tmpdir(), 'docket-app-sweep'),
  use: {
    baseURL: process.env.APP_BASE_URL ?? 'http://localhost:8082',
    trace: 'retain-on-failure',
  },
  projects: [
    { name: 'chromium', use: { ...devices['Desktop Chrome'] } },
    { name: 'webkit', use: { ...devices['Desktop Safari'] } },
  ],
});
