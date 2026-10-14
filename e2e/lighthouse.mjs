// Runs Lighthouse mobile on every site page and checks DESIGN.md 4.4:
// performance and accessibility at 95 or above, LCP under 1.8 s, CLS under
// 0.05, and HTML, CSS and JS under 60 KB gzipped per page.
//
//   BASE_URL=http://localhost:18082 npm run lighthouse
//
// Full reports land in e2e/lighthouse/, which is gitignored.

import { spawnSync } from 'node:child_process';
import { mkdirSync, readFileSync } from 'node:fs';
import { join } from 'node:path';
import { gzipSync } from 'node:zlib';

const BASE_URL = process.env.BASE_URL ?? 'http://localhost:18082';
const OUT_DIR = join(import.meta.dirname, 'lighthouse');

const PAGES = [
  ['/', 'home'],
  ['/problem', 'problem'],
  ['/how-it-works', 'how-it-works'],
  ['/patients', 'patients'],
  ['/clinics', 'clinics'],
  ['/reliability', 'reliability'],
  ['/under-the-hood', 'under-the-hood'],
  ['/privacy', 'privacy'],
];

const BUDGET = { score: 95, lcpMs: 1800, cls: 0.05, gzipBytes: 60 * 1024 };

async function gzippedPageBytes(path) {
  const html = await (await fetch(`${BASE_URL}${path}`)).text();
  const assets = [
    ...html.matchAll(/<link rel="stylesheet" href="([^"]+)"/g),
    ...html.matchAll(/<script src="([^"]+)"/g),
  ].map((match) => match[1]);
  let total = gzipSync(html).length;
  for (const asset of assets) {
    const body = Buffer.from(await (await fetch(`${BASE_URL}${asset}`)).arrayBuffer());
    total += gzipSync(body).length;
  }
  return total;
}

function runLighthouse(path, slug) {
  const outputPath = join(OUT_DIR, `${slug}.json`);
  const run = spawnSync(
    'npx',
    [
      '--yes',
      'lighthouse',
      `${BASE_URL}${path}`,
      '--form-factor=mobile',
      '--quiet',
      '--chrome-flags=--headless=new',
      '--output=json',
      `--output-path=${outputPath}`,
    ],
    { stdio: ['ignore', 'ignore', 'inherit'] },
  );
  if (run.status !== 0) throw new Error(`Lighthouse failed on ${path}`);
  return JSON.parse(readFileSync(outputPath, 'utf8'));
}

mkdirSync(OUT_DIR, { recursive: true });

const rows = [];
for (const [path, slug] of PAGES) {
  const report = runLighthouse(path, slug);
  const row = {
    path,
    performance: Math.round(report.categories.performance.score * 100),
    accessibility: Math.round(report.categories.accessibility.score * 100),
    lcpMs: Math.round(report.audits['largest-contentful-paint'].numericValue),
    cls: Number(report.audits['cumulative-layout-shift'].numericValue.toFixed(3)),
    gzipKb: Number(((await gzippedPageBytes(path)) / 1024).toFixed(1)),
  };
  row.pass =
    row.performance >= BUDGET.score &&
    row.accessibility >= BUDGET.score &&
    row.lcpMs < BUDGET.lcpMs &&
    row.cls < BUDGET.cls &&
    row.gzipKb * 1024 < BUDGET.gzipBytes;
  rows.push(row);
}

console.table(rows);
if (rows.some((row) => !row.pass)) process.exitCode = 1;
