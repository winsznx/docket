# Setup

From a fresh clone to Docket running on your machine, then on your own Serverpod Cloud project. Docket was built on macOS on Apple Silicon, and the commands assume a POSIX shell such as zsh or bash.

## 1. Install the tools

You need Flutter 3.44.4 or later, which is the minimum for Serverpod 4 and brings Dart 3.12.2. Docket was built with Flutter 3.47.7 and Dart 3.13.5. Follow the [Flutter install page](https://docs.flutter.dev/get-started/install), or on a slow link take a shallow clone of the stable branch, which is far smaller than the release zip:

```bash
git clone --depth 1 -b stable https://github.com/flutter/flutter.git ~/development/flutter
export PATH="$HOME/development/flutter/bin:$PATH"
flutter --version
```

Then install the Serverpod CLI:

```bash
dart install serverpod_cli
```

If you installed it before with `dart pub global activate`, run `dart pub global deactivate serverpod_cli` first. On macOS, `dart install` puts the binary in `~/Library/Application Support/Dart/install/bin`, which isn't on your PATH and has a space in it. Add this line to `~/.zshrc`, quotes included, and open a new terminal:

```bash
export PATH="$PATH:$HOME/Library/Application Support/Dart/install/bin"
```

`serverpod version` should now print a version. The project pins Serverpod 4.0.4 in `docket_server/pubspec.yaml`.

For the end-to-end tests you also need Node.js. The build used 24.19.0.

You don't need Docker. Serverpod runs Postgres embedded and downloads it on first use.

## 2. Get the code and packages

```bash
git clone https://github.com/winsznx/docket.git
cd docket
flutter pub get
```

The root `pubspec.yaml` is a pub workspace holding `docket_server`, `docket_client`, `docket_flutter` and `loadtest`, so one `flutter pub get` at the root resolves all four.

## 3. Create the passwords file

`docket_server/config/passwords.yaml` holds every secret the server reads, and it's gitignored, so a fresh clone doesn't have it. `serverpod create` normally writes it with random values when it makes a project. Here you write it yourself.

Development and test each need these keys:

| Key | Used by |
| --- | --- |
| `database` | The embedded Postgres superuser, set when its data directory is first created |
| `serviceSecret` | The service protocol and Insights. It must be longer than 20 characters or Insights stays off |
| `emailSecretHashPepper` | Email sign-in |
| `jwtHmacSha512PrivateKey` | Signing staff JWTs |
| `jwtRefreshTokenHashPepper` | Hashing refresh tokens, at least 10 characters |

This writes the file with fresh random values for both run modes:

```bash
cd docket_server
rnd() { openssl rand -base64 32; }
cat > config/passwords.yaml <<EOF
development:
  database: '$(rnd)'
  serviceSecret: '$(rnd)'
  emailSecretHashPepper: '$(rnd)'
  jwtHmacSha512PrivateKey: '$(rnd)'
  jwtRefreshTokenHashPepper: '$(rnd)'

test:
  database: '$(rnd)'
  serviceSecret: '$(rnd)'
  emailSecretHashPepper: '$(rnd)'
  jwtHmacSha512PrivateKey: '$(rnd)'
  jwtRefreshTokenHashPepper: '$(rnd)'
EOF
```

Then add Docket's own secrets with the bundled tool, still from `docket_server`:

```bash
dart run tool/secrets.dart generate
```

It adds a `shared:` block, which every run mode reads, with a fresh VAPID key pair for Web Push in `vapidPublicKey` and `vapidPrivateKey`, the `vapidSubject` contact, and `phoneEncryptionKey`, 32 random bytes for AES-256-GCM. It never prints a value, and keys that already exist are kept. The subject defaults to `https://docket.serverpod.space`. Pass your own `https:` or `mailto:` address as a second argument to use another:

```bash
dart run tool/secrets.dart generate https://your-id.serverpod.space
```

SMS is optional. To send texts, add your Twilio values under `shared:` by hand as `twilioAccountSid`, `twilioAuthToken` and `twilioFrom`. Without them, text notifications are recorded as skipped with "SMS isn't configured on this server." and push still works.

If you change `database` after the first start, the embedded Postgres keeps the old one. Delete `docket_server/.serverpod/` to start over with empty local databases.

## 4. Build the web app

```bash
serverpod run flutter_build
```

This runs the `flutter_build` script from `docket_server/pubspec.yaml`, which builds `docket_flutter` with `flutter build web --release --base-href / --pwa-strategy=none --no-web-resources-cdn` into `docket_server/web/app`. Build it before you start the server. `lib/server.dart` mounts the app with `FlutterRoute` only when `web/app` exists at startup, so after a first build on a running server, restart it.

## 5. Run the server

```bash
serverpod start
```

Run it from `docket_server`. On first start it downloads Postgres, creates the development database under `.serverpod/development/`, and applies the migrations. Then it runs the server with hot reload in a terminal UI. It also launches the Flutter app listed under `flutter_apps` in `docket_server/pubspec.yaml` in development mode. Pass `--no-flutter` to skip that and use the built app, and `--no-tui` for plain log output.

| What | Where |
| --- | --- |
| Site and web app | <http://localhost:8082/> |
| Sandbox desk | <http://localhost:8082/try> |
| API | <http://localhost:8080/> |
| Insights | <http://localhost:8081/> |
| Health probes | <http://localhost:8082/livez>, `/readyz` and `/startupz` |

In development, sign-in verification codes print to the server log instead of going out by email. Web Push needs HTTPS, except on `localhost`, so testing push from a real phone needs the deployed app or a tunnel.

## 6. Run the tests

Each block starts from the repo root.

```bash
cd docket_server
dart test                  # unit and integration tests
dart test -x integration   # unit tests only
dart test -t integration   # integration tests only
```

The integration tests use `withServerpod`, which boots the server in the `test` run mode with its own embedded database under `.serverpod/test/`. Nothing has to be running first. They read the `test:` and `shared:` blocks of `passwords.yaml`, so run step 3 first.

```bash
cd docket_flutter
flutter test
```

```bash
cd e2e
npm ci
npx playwright install chromium webkit
BASE_URL=http://localhost:8082 npm test
```

`npm test` runs `playwright test --project=chromium --project=webkit` against `BASE_URL`, which defaults to `http://localhost:18082`. Plain `npx playwright test` also runs the `tools` project, which renders the social image and captures site screenshots into files instead of checking anything.

### End-to-end suites

Each Playwright config in `e2e/` runs one suite. Run them from `e2e/`. For a local run, build the app with `serverpod run flutter_build`, start the server from `docket_server`, and point every base URL at the web server on <http://localhost:8082> and every API URL at <http://localhost:8080>. The suites with a live default check https://docket.serverpod.space unless you override them.

| Config | What it runs | Command | Env vars and defaults |
| --- | --- | --- | --- |
| `playwright.config.ts` | `site.spec.ts` in Chromium and WebKit, plus the `tools` project | `BASE_URL=http://localhost:8082 npm test` | `BASE_URL`, default `http://localhost:18082` |
| `live.config.ts` | `live-smoke.spec.ts`: the home page, `/try` through to a called phone, and `/livez`. It appends the desk click to phone text time to `e2e/screens/live/latency.log` | `npx playwright test -c live.config.ts` | `LIVE_BASE_URL`, default `https://docket.serverpod.space`. `LIVE_API_URL`, default `https://docket.api.serverpod.space` |
| `desk.config.ts` | `desk.spec.ts` and `offline.spec.ts` | `DESK_BASE_URL=http://localhost:8082 npx playwright test -c desk.config.ts` | `DESK_BASE_URL`, default `http://localhost:9102`. `DOCKET_API_URL`, default `http://localhost:8080`. `DESK_OUTPUT_DIR` for artifacts, default a folder under the system temp directory |
| `patient.config.ts` | `patient.spec.ts` | `BASE_URL=http://localhost:8082 npx playwright test -c patient.config.ts` | `BASE_URL`, default `http://localhost:9101`. `API_URL`, default `http://localhost:8080` |
| `board-owner.config.ts` | `board.spec.ts` and `owner.spec.ts` | `BOARD_OWNER_BASE_URL=http://localhost:8082 DOCKET_SERVER_LOG=<server log file> npx playwright test -c board-owner.config.ts` | `BOARD_OWNER_BASE_URL`, default `http://localhost:9103`. `DOCKET_API_URL`, default `http://localhost:8080`. `DOCKET_SERVER_LOG`, the server's log file, where the owner spec reads sign-up codes |
| `app.config.ts` | `app-sweep.spec.ts`, every Flutter route in Chromium and WebKit | `npx playwright test -c app.config.ts` | `APP_BASE_URL`, default `http://localhost:8082`. `APP_API_URL`, default `http://localhost:8080` |
| `measure.config.ts` | `measure-first-paint.spec.ts` and `measure-reconnect.spec.ts`. They append to `docs/measurements/first-paint.tsv` and `reconnect.tsv` | `npx playwright test -c measure.config.ts` | `MEASURE_BASE_URL`, default `https://docket.serverpod.space`. `MEASURE_API_URL`, default `https://docket.api.serverpod.space` |
| `capture.config.ts` | `capture.spec.ts`, which records the desk and the phone for the film and the README GIFs into `e2e/videos/` | `npx playwright test -c capture.config.ts` | `CAPTURE_BASE_URL`, default `https://docket.serverpod.space` |

From the repo root, `dart run tool/gen_tokens.dart --check` fails when the generated design token files have drifted from `design/tokens.json`.

The load and restart scripts take the API URL:

```bash
cd loadtest
dart run bin/load.dart http://localhost:8080/ 300 30   # streams, then calls
dart run bin/restart.dart http://localhost:8080/ 60    # grace seconds
```

`load.dart` opens patient streams on one line while a desk calls every 2 seconds and prints the latency distribution. `restart.dart` calls a patient on a fresh sandbox with a short grace window and waits for the re-slot, so you can restart the server while it waits.

## 7. Deploy to Serverpod Cloud

Docket is built for future calls, which Serverpod Cloud turns off on the Starter plan, so use a Growth project. Keep minimum and maximum podlets at 1 unless you add Redis, since server events only reach other podlets through Redis. On a server without future calls, `LocalScheduler` runs the same timer rules instead, and `/readyz` says so under `docket:timer-mode`.

Run these from `docket_server`:

```bash
serverpod cloud auth login
serverpod cloud project link <id>
dart run tool/secrets.dart push-cloud
serverpod cloud variable set PUBLIC_BASE_URL https://<id>.serverpod.space
serverpod run flutter_build
serverpod cloud deploy --wet-run --show-files
serverpod cloud deploy
```

- `project link` points `scloud.yaml` at your project.
- `push-cloud` sets `vapidPublicKey`, `vapidPrivateKey`, `vapidSubject` and `phoneEncryptionKey` from the `shared:` block as Cloud passwords, plus the three Twilio keys when they're present, without printing them. Generate the keys with your own URL as the subject first, as in step 3. The database password, the service secret and the auth module's keys are managed by Cloud, and `serverpod cloud password list` shows them.
- `PUBLIC_BASE_URL` is the base for links in texts, pushes, posters and QR codes, and the Twilio status callback.
- `scloud.yaml` runs `serverpod generate` and `serverpod run flutter_build` as pre-deploy hooks, so each deploy regenerates the code and rebuilds the web app before it uploads.
- `--wet-run --show-files` lists what would be uploaded without deploying. Check that `docket_server/web/app` is in the list, since it's gitignored.

Migrations apply on deploy. Follow the rollout with `serverpod cloud status deployment show` and read logs with `serverpod cloud log`. A server that crash-loops on start keeps the rollout running without showing why, and the reason is only in the logs.

Once it's live:

| What | URL |
| --- | --- |
| Site and web app | `https://<id>.serverpod.space/` |
| API | `https://<id>.api.serverpod.space/` |
| Insights | `https://<id>.insights.serverpod.space/` |

The smoke script checks that streams reach a client and that a future call fires on Cloud:

```bash
cd loadtest
dart run bin/smoke.dart https://<id>.api.serverpod.space/ stream
dart run bin/smoke.dart https://<id>.api.serverpod.space/ schedule 60
dart run bin/smoke.dart https://<id>.api.serverpod.space/ runs
```
