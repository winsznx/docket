/*
 * Docket's service worker, at scope "/".
 *
 * Patients register it after tapping "Get alerts" (PRD 14.3), and the desk
 * registers it at load so a reload works offline (PRD 15.6). It does two
 * things:
 *
 * 1. Web Push. Shows the server's notification and, on a tap, focuses the
 *    ticket's tab or opens it.
 * 2. A runtime cache of the app shell, stale-while-revalidate, so app routes
 *    load from cache when the network is gone.
 *
 * It never caches API calls, other origins or the server-rendered site
 * pages, so live data always comes from the server.
 */
'use strict';

const SHELL_CACHE = 'docket-shell-v1';

/** Files the Flutter app needs to boot. */
const SHELL_FILES = new Set([
  '/index.html',
  '/main.dart.js',
  '/main.dart.mjs',
  '/main.dart.wasm',
  '/flutter.js',
  '/flutter_bootstrap.js',
  '/manifest.json',
  '/favicon.png',
  '/sqlite3.wasm',
  '/db_worker.js',
]);
const SHELL_PREFIXES = ['/canvaskit/', '/assets/', '/icons/'];

/** Flutter routes, answered from the cached index.html when offline. */
const APP_PATHS = new Set(['/desk', '/try', '/owner']);
const APP_PREFIXES = ['/b/', '/t/', '/j/'];

/** Paths that must always reach the server. */
const SITE_PATHS = new Set([
  '/',
  '/problem',
  '/how-it-works',
  '/patients',
  '/clinics',
  '/reliability',
  '/under-the-hood',
  '/privacy',
]);
const NEVER_PREFIXES = ['/api/', '/site/'];

/** Files fetched on install so the very first visit can reload offline. */
const WARM_FILES = ['/index.html', '/flutter_bootstrap.js', '/main.dart.js'];

/**
 * The rest of the shell a desk needs to boot with no network. The desk asks
 * for these with a 'warm-shell' message. Patients who only turned on alerts
 * never download them, since CanvasKit alone is several megabytes of data.
 */
const DESK_WARM_FILES = [
  '/flutter.js',
  '/manifest.json',
  '/favicon.png',
  '/sqlite3.wasm',
  '/db_worker.js',
  '/canvaskit/canvaskit.js',
  '/canvaskit/canvaskit.wasm',
  '/canvaskit/chromium/canvaskit.js',
  '/canvaskit/chromium/canvaskit.wasm',
  '/assets/AssetManifest.bin.json',
  '/assets/AssetManifest.bin',
  '/assets/FontManifest.json',
  '/assets/assets/config.json',
  '/assets/fonts/MaterialIcons-Regular.otf',
  '/assets/packages/lucide_icons_flutter/assets/lucide.ttf',
  '/assets/assets/fonts/AtkinsonHyperlegibleNext-Regular.ttf',
  '/assets/assets/fonts/AtkinsonHyperlegibleNext-Medium.ttf',
  '/assets/assets/fonts/AtkinsonHyperlegibleNext-Bold.ttf',
  '/assets/assets/fonts/AtkinsonHyperlegibleNext-ExtraBold.ttf',
  '/assets/assets/fonts/AtkinsonHyperlegibleMono-Regular.ttf',
  '/assets/assets/fonts/AtkinsonHyperlegibleMono-Medium.ttf',
];

const PUSH_ICON = '/icons/Icon-192.png';
const CALL_VIBRATION = [300, 120, 300, 120, 600];

function trimSlash(pathname) {
  return pathname.length > 1 && pathname.endsWith('/')
    ? pathname.slice(0, -1)
    : pathname;
}

function neverCached(pathname) {
  return (
    SITE_PATHS.has(trimSlash(pathname)) ||
    NEVER_PREFIXES.some((prefix) => pathname.startsWith(prefix))
  );
}

function isShellFile(pathname) {
  return (
    SHELL_FILES.has(pathname) ||
    SHELL_PREFIXES.some((prefix) => pathname.startsWith(prefix))
  );
}

function isAppRoute(pathname) {
  return (
    APP_PATHS.has(trimSlash(pathname)) ||
    APP_PREFIXES.some((prefix) => pathname.startsWith(prefix))
  );
}

function cacheable(response) {
  return response.ok && response.type === 'basic';
}

async function warmShell(files = WARM_FILES) {
  const cache = await caches.open(SHELL_CACHE);
  await Promise.all(
    files.map(async (file) => {
      try {
        const response = await fetch(file, { cache: 'no-cache' });
        if (cacheable(response)) await cache.put(file, response);
      } catch (error) {
        console.warn('Docket: could not cache', file, error);
      }
    }),
  );
}

self.addEventListener('message', (event) => {
  if (event.data && event.data.type === 'warm-shell') {
    event.waitUntil(warmShell([...WARM_FILES, ...DESK_WARM_FILES]));
  }
});

self.addEventListener('install', (event) => {
  event.waitUntil(warmShell().then(() => self.skipWaiting()));
});

self.addEventListener('activate', (event) => {
  event.waitUntil(
    (async () => {
      const names = await caches.keys();
      await Promise.all(
        names
          .filter((name) => name.startsWith('docket-shell-') && name !== SHELL_CACHE)
          .map((name) => caches.delete(name)),
      );
      await self.clients.claim();
    })(),
  );
});

/** Answers from cache at once and refreshes the copy in the background. */
async function staleWhileRevalidate(event, request) {
  const cache = await caches.open(SHELL_CACHE);
  const cached = await cache.match(request);
  const refresh = fetch(request).then(async (response) => {
    if (cacheable(response)) await cache.put(request, response.clone());
    return response;
  });
  if (!cached) return refresh;
  event.waitUntil(
    refresh.catch((error) => {
      console.warn('Docket: kept the cached copy of', request.url, error);
    }),
  );
  return cached;
}

/**
 * App routes go to the network first, so a deploy shows at once. The
 * response is the app's index.html, which is kept for offline reloads.
 */
async function appNavigation(event, request) {
  const cache = await caches.open(SHELL_CACHE);
  try {
    const response = await fetch(request);
    if (cacheable(response)) {
      event.waitUntil(cache.put('/index.html', response.clone()));
    }
    return response;
  } catch (error) {
    const shell = await cache.match('/index.html');
    if (shell) return shell;
    throw error;
  }
}

self.addEventListener('fetch', (event) => {
  const request = event.request;
  if (request.method !== 'GET' || request.headers.has('range')) return;
  const url = new URL(request.url);
  if (url.origin !== self.location.origin) return;
  if (neverCached(url.pathname)) return;

  if (request.mode === 'navigate') {
    if (isAppRoute(url.pathname)) {
      event.respondWith(appNavigation(event, request));
    }
    return;
  }
  if (isShellFile(url.pathname)) {
    event.respondWith(staleWhileRevalidate(event, request));
  }
});

/** The server sends `{title, body, url, tag, kind}`, encrypted per RFC 8291. */
function readPayload(data) {
  if (!data) return {};
  try {
    return data.json();
  } catch (error) {
    console.warn('Docket: push payload was not JSON', error);
    return { body: data.text() };
  }
}

function safeUrl(value) {
  try {
    const url = new URL(typeof value === 'string' ? value : '/', self.location.origin);
    return url.protocol === 'https:' || url.protocol === 'http:'
      ? url.href
      : new URL('/', self.location.origin).href;
  } catch (error) {
    console.warn('Docket: push link was not a URL', value, error);
    return new URL('/', self.location.origin).href;
  }
}

self.addEventListener('push', (event) => {
  const payload = readPayload(event.data);
  const called = payload.kind === 'called';
  const title =
    typeof payload.title === 'string' && payload.title ? payload.title : 'Docket';
  event.waitUntil(
    self.registration.showNotification(title, {
      body: typeof payload.body === 'string' ? payload.body : '',
      tag: typeof payload.tag === 'string' && payload.tag ? payload.tag : 'docket',
      renotify: true,
      requireInteraction: called,
      vibrate: called ? CALL_VIBRATION : undefined,
      icon: PUSH_ICON,
      lang: 'en',
      data: { url: safeUrl(payload.url), kind: payload.kind },
    }),
  );
});

/** Focuses a tab already showing the ticket, or opens one. */
async function focusOrOpen(href) {
  const target = new URL(href);
  const windows = await self.clients.matchAll({
    type: 'window',
    includeUncontrolled: true,
  });
  const open = windows.find((client) => {
    const url = new URL(client.url);
    return url.origin === target.origin && url.pathname === target.pathname;
  });
  if (open) return open.focus();
  return self.clients.openWindow(target.href);
}

self.addEventListener('notificationclick', (event) => {
  event.notification.close();
  const url = event.notification.data && event.notification.data.url;
  event.waitUntil(focusOrOpen(safeUrl(url)));
});
