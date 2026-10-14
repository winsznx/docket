# Sponsor findings

Everything that surprised us while building Docket on Serverpod 4 and Serverpod Cloud, written down the moment it happened. Each entry has the versions, exact steps, what we expected, what we got, what it cost, and a concrete fix.

## Environment

| Tool | Version |
| --- | --- |
| Serverpod CLI | 4.0.4 |
| Flutter | 3.47.7 stable, framework abaf9c5237, engine d8a2d6c768 |
| Dart | 3.13.5 stable |
| Node | 24.19.0 |
| OS | macOS 27.0 on Apple Silicon (arm64) |
| App Studio | not used |

## Findings

### F1. The macOS Flutter zip is 2.2 GB, a shallow clone gets you running in under a minute
- Versions: Flutter 3.47.7, macOS arm64.
- Reproduction: download `flutter_macos_arm64_3.47.7-stable.zip` from the releases JSON on a 10 Mbps link.
- Expected and actual: the installation doc points to the Flutter install page. The zip is 2,263,893,135 bytes, about 30 minutes at the measured 1.25 MB/s. `git clone --depth 1 -b 3.47.7 https://github.com/flutter/flutter.git` was 223 MB and `flutter --version` bootstrapped the Dart SDK in seconds.
- Impact: anyone starting a hackathon on a slow link loses half an hour before `serverpod create` runs.
- Suggested fix: the Serverpod installation page could mention the shallow clone as the fast path for agents and slow connections.
- Upstream: not filed, Flutter docs issue.

### F2. `dart install` puts `serverpod` outside PATH on macOS
- Versions: Serverpod CLI 4.0.4, Dart 3.13.5.
- Reproduction: `dart install serverpod_cli` on a clean macOS account.
- Expected and actual: the docs say to run `serverpod version` next. It fails with "command not found" because the binary lands in `~/Library/Application Support/Dart/install/bin`, a path with a space in it that isn't on PATH. Dart prints a warning with the export line.
- Impact: every agent following the installation page hits a failed command right after install and has to read the warning to recover.
- Suggested fix: the installation page and the agent setup prompt could include the PATH line, quoted for the space.
- Upstream: not filed yet.

### F3. On the Starter plan the generated `futureCalls` throws, and a server that schedules at start crash-loops
- Versions: Serverpod 4.0.4, Serverpod Cloud, project on the Starter plan, Dart 3.13.5 on linux_x64.
- Reproduction: a server that calls `pod.futureCalls.callRecurring(...)` after `pod.start()`, as the recurring-tasks docs show, deployed with `serverpod cloud deploy` to a Starter project.
- Expected and actual: either the call is scheduled or the docs say Starter has future calls off. Actual: `Bad state: FutureCalls is not initialized.` from `FutureCalls._effectiveFutureCallManager`, the process exits, and the rollout sits at "Rollout running" while the pod restarts every minute. `serverpod cloud deploy` waits on it without showing the error. The reason is only visible in `serverpod cloud log`.
- Impact: about 20 minutes lost. Anyone who follows the recurring-tasks page on Starter ships a server that never comes up. Any endpoint that schedules a future call returns 500 after its transaction has committed.
- Suggested fix: document on the Cloud plans and scheduling pages that Starter disables future calls, expose a public `pod.futureCalls.isAvailable`, and have the deploy command print the crash reason when a rollout keeps restarting.
- Upstream: not filed yet, drafted in CONTRIBUTIONS.md.

### F4. `--pwa-strategy` is hidden from `flutter build web -h` but still works
- Versions: Flutter 3.47.7.
- Reproduction: `flutter build web -h | grep pwa` prints nothing. `flutter_tools/lib/src/commands/build_web.dart` still registers the option with `hide: true` and a deprecation note.
- Expected and actual: PRD 21.3 uses `--pwa-strategy=none` so Flutter's service worker doesn't take scope `/` from Docket's own `push-sw.js`. The help hides it, so it looks removed. It isn't, and dropping it would let the default bootstrap register `flutter_service_worker.js` over `push-sw.js`.
- Impact: we first removed the flag on the evidence of `-h`, then restored it after reading the tool's source. Anyone with a custom service worker who trusts the help output loses their push subscriptions.
- Suggested fix: Flutter could keep deprecated flags visible with a deprecation line until they're gone, and the Serverpod Flutter web page could mention the flag for apps with their own worker.
- Upstream: drafted in CONTRIBUTIONS.md.

### F5. `serverpod generate` hides the real error when a future call file has a missing import
- Versions: Serverpod CLI 4.0.4.
- Reproduction: write a `FutureCall` subclass that imports a file that doesn't exist yet, run `serverpod generate`.
- Expected and actual: the missing import is named. Actual: "FutureCall analysis skipped due to invalid Dart syntax", with the analyzer lines below it, and the endpoints that use `pod.futureCalls` then fail with "The getter 'futureCalls' isn't defined" until the import is fixed, which points at the wrong file.
- Impact: a few minutes. Worse for an agent, which tends to chase the second error.
- Suggested fix: print the first analyzer error as the headline.
- Upstream: not filed.

### F6. Model rules that only show up as generator errors
- Versions: Serverpod CLI 4.0.4.
- Reproduction: `boardTokenHash: String, scope=serverOnly` on a table model, and a field named `count`.
- Expected and actual: the model reference doesn't mention either rule. The generator refuses a non-nullable `serverOnly` field ("must be nullable when the scope property is set to serverOnly") and reserves the field name `count`.
- Impact: small, but PRD 8.3 had both and had to change.
- Suggested fix: list reserved field names and the `serverOnly` nullability rule on the model reference page.
- Upstream: not filed.
