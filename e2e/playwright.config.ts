import { defineConfig, devices } from '@playwright/test';

// Point BASE_URL at any running Docket web server. The default is the site
// agent's local instance on the 1808x ports.
const baseURL = process.env.BASE_URL ?? 'http://localhost:18082';

export default defineConfig({
  testDir: '.',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: 0,
  reporter: [['list']],
  use: {
    baseURL,
    trace: 'retain-on-failure',
  },
  projects: [
    {
      name: 'chromium',
      testMatch: /site\.spec\.ts$/,
      use: { ...devices['Desktop Chrome'] },
    },
    {
      name: 'webkit',
      testMatch: /site\.spec\.ts$/,
      use: { ...devices['Desktop Safari'] },
    },
    // Scripts that write files rather than check things. Run them by name,
    // see the "og" and "shots" scripts in package.json.
    {
      name: 'tools',
      testMatch: /(render-og|capture-site-shots)\.spec\.ts$/,
      use: { ...devices['Desktop Chrome'] },
    },
  ],
});
