# Decisions

Choices that shaped the build, what was observed, and where the docs or the PRD were overridden.

## Site home route

BUILD.md amendment A3 asks for the site pages at literal paths beside the Flutter app's `FlutterRoute`, with a middleware for `GET /` as the fallback plan if a literal `/` can't sit next to it.

The literal route worked, so there's no middleware. `registerSite` in `docket_server/lib/src/web/site/site.dart` adds a `WidgetRoute` per page, including one at `/`, before `lib/server.dart` adds `FlutterRoute(appDir, enableWasmHeaders: false)` at the root.

What was seen, on Serverpod 4.0.4 with relic_core 2.0.0-rc.2, running `bin/main.dart` with a `web/app` directory present so `FlutterRoute` was registered:

- Startup printed no error. "Conflicting values" never appeared.
- `GET /` and `HEAD /` returned the site home page with `cache-control: no-cache, private`.
- `/try`, `/t/<token>`, `/j/<slug>`, `/desk`, `/b/<token>`, `/owner` and `/invite/<code>` returned the Flutter `index.html` through the SPA fallback, and `/main.dart.js` returned the file itself.
- `/livez`, `/assets/assets/config.json` and `/site/...` kept working.

Why it works: `FlutterRoute` mounts a sub-router whose only route is a `StaticRoute` at the tail `/**`, so the root node it attaches to holds no value of its own. "Conflicting values" is thrown only when both sides of an attach hold a value at the same node, which would happen with a second route at exactly `/`, such as `StaticRoute.file` at `/`. On lookup, Relic's path trie returns the value at a node before it tries the node's tail, so the literal `/` wins and every other path falls through to the tail.

One thing to know: `FlutterRoute`'s 404 fallback middleware is attached at the same root node, so it wraps the site routes too. A site route that answered 404 would get the Flutter app instead. None of them do, since every site route always builds a page.

## Model differences from PRD 8

- `Clinic.boardTokenHash`, `Clinic.sandboxTokenHash` and `Ticket.tokenHash` are nullable because Serverpod 4 requires `scope=serverOnly` fields to be nullable. Every code path still writes them.
- `RateBucket.count` is `hits`, since `count` is a reserved field name.
- `LocalTicket.id` and `OutboxAction.id` use `defaultModel=random_v7` because client tables need a default for a nullable id.
- `DeliveryStatus` gains `delivered` and `undelivered` per BUILD A5.
- Added for real needs the PRD left implicit: `Ticket.closedReason` (the desk's removal reason shown to the patient), `Ticket.transferTokenCipher` (the transferred ticket's token, sealed, so the old link can follow it, since only token hashes are stored), `PushTarget.linkCipher` and `SmsTarget.linkCipher` (the sealed ticket URL, because SMS and push need the link and the raw token isn't stored), `TicketEvent.ticketLabel` and `Notification.ticketLabel` (so audit and the log filter by label), `Notification.callVersion` (so delivery chips match the current call), `DeskMeta.lastViewJson` (so a reload while offline renders the last view), and `LocalTicket.callVersion`, `reslotCount` and `priorityReason`.
- Wire models gained fields the surfaces need: `ClinicPublicInfo.isSandbox`, `LinePublicInfo.etaText` and `acceptingJoins`, several `PatientView` fields (`clinicName`, `etaText`, `graceSeconds`, `headsUpSent`, `transferredToLabel`, `transferredToLineName`, `closedReason`, `smsEnabled`, `smsLast4`, `isDemo`), `TicketView.lineId`, `priorityNote`, `callVersion`, `pushStatus` and `smsStatus` for the delivery chips, `LineView.servedToday`, `DeskView.clinicSlug` and `joinUrl`, `DeskActionResult.ticketUrl`, `SandboxStart.clinicId`, `LineReport.waitingNow` and `p90ServiceSeconds`. `OwnerView` is new, for the console's first load.

## Endpoint differences from PRD 9

- Every owner method takes a trailing `String? sandboxToken`, because PRD 9.5 says owner methods accept a sandbox token but the listed signatures had no parameter for it. `getOwnerView` is added.
- Recall re-notifies with a dedupe key suffixed `recall-<eventId>`. PRD 14.2's key has no recall part, so a second `called` push for the same call would otherwise be dropped as a duplicate.
- The re-slot places the ticket at 1-based position `reslotOffset` among normal-priority waiting tickets, matching the copy "you're back in line, 3rd from the front" with the default offset 3.

## Cookie auth stays off

PRD 9.8 asks for cookie-based auth on the web. On Serverpod Cloud the web app is served from `docket.serverpod.space` and the API from `docket.api.serverpod.space`. Cookie auth needs `allowedOrigins` and, across those two hosts, cross-site cookies that Safari blocks. Staff sign-in uses the default token storage instead. The patient path has no sign-in at all, so judges never touch it. Revisit with a custom domain that puts the app and the API on one site.

## Timers on a plan without future calls

See SPONSOR_FINDINGS F3. `Timers.executing(pod)` reads the server's config. With future calls on, PRD 11 runs as written. With them off, `LocalScheduler` applies the same idempotent rules from Postgres every second, so the live app stays correct on Starter, and `/readyz` reports `docket:timer-mode`. Measured locally, one run with future calls off: the re-slot landed 1132 ms after the grace end. The PRD's future-call path is the one Docket is built and tested for, and Growth (NEEDS-TIM 1) switches back to it with no code change.

## Build flags

`flutter build web --release --base-href / --pwa-strategy=none --no-web-resources-cdn --output ../docket_server/web/app`. `--pwa-strategy` is hidden from the help in Flutter 3.47.7 but still accepted (SPONSOR_FINDINGS F4), and it keeps Flutter's own worker off scope `/` so `push-sw.js` owns it.

## Settings Cloud doesn't read from YAML

`.scloudignore` leaves out `config/production.yaml`, because Cloud manages that file. The future-call settings from PRD 11 are set as Cloud variables instead: `SERVERPOD_FUTURE_CALL_SCAN_INTERVAL=1000`, `SERVERPOD_FUTURE_CALL_CONCURRENCY_LIMIT=8`, `SERVERPOD_FUTURE_CALL_CHECK_BROKEN_CALLS=true`, `SERVERPOD_FUTURE_CALL_DELETE_BROKEN_CALLS=true`.

## Fixes from the cold audit

- The smoke endpoint's probes (CPU loop, idle stream, scheduling, database pings) answer only outside production and are rate limited to 10 a minute per address. They burned CPU and held sockets on purpose, which the single Starter podlet can't afford. The Cloud numbers they produced are stored in `docs/measurements/`.
- Contact data is purged for every closed service day before the clinic's today, so the first nightly run after a visit clears it. PRD 11 said "more than 24 hours" after closing, which kept data two nights and broke the "deleted the day after your visit" copy. The copy wins.
- A patient stream re-checks its token on every rebuild, so a link the desk replaced with `linkPhone` stops getting updates.
- An owner can't turn texts on unless Twilio credentials are set on the server, so the join page never offers texts that would only be recorded as skipped.
- `GET /t/<token>` writes the label and place into the app shell. First paint on Fast 3G went from a 1732 ms median to 889 ms.
- Left open on purpose, with the reason: the board label's font size is 18 to 20% of the screen height but its glyphs measure about 14%, and the patient ticket sits under a header instead of filling the top of the screen. Both are layout changes too risky to make in the last hour before submission.
