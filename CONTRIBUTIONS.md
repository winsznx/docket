# Upstream contributions

These are drafts for Tim to file. Nothing here has been filed yet. Each comes from an entry in [docs/SPONSOR_FINDINGS.md](docs/SPONSOR_FINDINGS.md) or from something we hit while building, and each was searched for on GitHub first. Where an issue already exists, the draft links it instead of adding a duplicate.

Versions unless a draft says otherwise: Serverpod 4.0.4, Serverpod CLI 4.0.4, Flutter 3.47.7 stable, Dart 3.13.5, pointycastle 4.0.0, macOS 27.0 on Apple Silicon.

| # | Title | Repo | Status |
| --- | --- | --- | --- |
| 1 | `serverpod generate` labels a missing import as invalid Dart syntax | serverpod/serverpod | Draft. Related to serverpod/serverpod#5818 |
| 2 | Starter plan: `futureCalls` throws and a server that schedules at start crash-loops | serverpod/serverpod | Draft |
| 3 | `serverpod cloud deploy` waits on a crash-looping rollout without the reason | Serverpod Cloud CLI | Draft, no open tracker found |
| 4 | Say on the Cloud plan and scheduling pages that Starter has future calls off | serverpod/serverpod_docs | Draft |
| 5 | Model reference: fields with a non-default scope must be nullable | serverpod/serverpod_docs | Draft |
| 6 | List the reserved field names for table models | serverpod/serverpod_docs | Draft |
| 7 | Flutter web page: running your own service worker next to Flutter's | serverpod/serverpod_docs | Draft. Flutter side tracked in flutter/flutter#156910 |
| 8 | Installation: the PATH line after `dart install serverpod_cli` on macOS | serverpod/serverpod_docs | Draft |
| 9 | Installation: a shallow Flutter clone for slow connections | serverpod/serverpod_docs | Draft, low priority |
| 10 | `decodePoint` and ECDH accept points that aren't on the curve | bcgit/pc-dart | Draft, contact maintainers privately first |
| 11 | `GCMBlockCipher` block limit is -1 because `^` is XOR | bcgit/pc-dart | Draft |
| 12 | RFC 8291 section 5 says Content-Length 145 for a 144-byte body | RFC Editor | Already reported as erratum 5230, nothing to file |

---

## 1. `serverpod generate` labels a missing import as invalid Dart syntax

- Repo: serverpod/serverpod
- Existing: [serverpod/serverpod#5818](https://github.com/serverpod/serverpod/issues/5818), closed, shows the same headline for a different cause, primary constructors. Nothing found for missing imports. Searched "FutureCall analysis skipped", "invalid Dart syntax future call".
- Source: SPONSOR_FINDINGS F5

Reproduction

1. In a Serverpod 4 server, write a `FutureCall` subclass that imports a file that doesn't exist yet, such as `import '../domain/missing.dart';`.
2. Run `serverpod generate`.

Expected

The error leads with the real problem, that the import target doesn't exist, and names the file and line.

Actual

```
ERROR: FutureCall analysis skipped due to invalid Dart syntax. Please review and correct the syntax errors.
File: <path>
<analyzer errors>
```

The syntax is valid, so the headline sends you looking in the wrong place. The real error sits in the lines under it. Files that use `pod.futureCalls` then fail with "The getter 'futureCalls' isn't defined", which points somewhere else again. An agent fixing errors top down tends to chase that second error.

Suggested fix

In `future_calls_analyzer.dart` and `endpoints_analyzer.dart`, say "could not be analyzed" instead of "invalid Dart syntax", and put the first analyzer error in the headline. Generating an empty `futureCalls` accessor when analysis fails would also stop the follow-on error from pointing at the wrong file.

---

## 2. Starter plan: `futureCalls` throws and a server that schedules at start crash-loops

- Repo: serverpod/serverpod
- Existing: none found. Searched "FutureCalls is not initialized", "Starter plan future calls". Related but different: [serverpod/serverpod#3928](https://github.com/serverpod/serverpod/issues/3928) asks for a way to check whether a call is scheduled, and [serverpod/serverpod#2168](https://github.com/serverpod/serverpod/issues/2168) covers serverless mode.
- Source: SPONSOR_FINDINGS F3

Reproduction

1. Follow the recurring tasks page and register a recurring call after `await pod.start()`, starting with `pod.futureCalls.callRecurring(identifier: 'sweep')`.
2. Deploy with `serverpod cloud deploy` to a project on the Starter plan.

Expected

The call is scheduled, or the server says plainly that future calls are off on this server.

Actual

`Bad state: FutureCalls is not initialized.` from `FutureCalls._effectiveFutureCallManager`. The process exits and restarts every minute. Any endpoint that schedules a future call answers 500 after its own transaction has already committed.

Suggested fix

- A public check such as `pod.futureCalls.isAvailable`, so a server can choose another path.
- An error that names the cause, such as "Future calls are off on this server."
- A line on the recurring tasks page about guarding scheduling when future calls may be off.

---

## 3. `serverpod cloud deploy` waits on a crash-looping rollout without the reason

- Repo: the Serverpod Cloud CLI. The `serverpod_cloud_cli` pubspec lists serverpod/serverpod_cloud_clients as its issue tracker, but that repo has issues turned off. File through serverpod/serverpod or Serverpod Cloud support.
- Existing: none found.
- Source: SPONSOR_FINDINGS F3

Reproduction

Deploy a server that throws during startup, such as the one in draft 2, with `serverpod cloud deploy`.

Expected

The deploy reports that the new version keeps exiting, with the last error.

Actual

The command shows "Rollout running" while the pod restarts every minute. The reason is only visible in `serverpod cloud log`. It cost us about 20 minutes.

Suggested fix

When a rollout sees repeated restarts, print the last few log lines of the failing pod, or at least point at `serverpod cloud log`.

---

## 4. Say on the Cloud plan and scheduling pages that Starter has future calls off

- Repo: serverpod/serverpod_docs
- Existing: none found. The Cloud docs mention Starter only for storage limits and `project create --plan`.
- Source: SPONSOR_FINDINGS F3

Pages: the future calls and recurring tasks pages under `docs/06-concepts/`, and `cloud_docs/concepts/deployments.md`.

Expected

Anyone choosing a plan learns that future calls, including recurring calls, need Growth.

Actual

Nothing says so. You find out from a crash loop.

Suggested fix

One line on the future calls and recurring tasks pages, and one row in the plan comparison: "Future calls are off on Starter. Use Growth for scheduled and recurring work."

---

## 5. Model reference: fields with a non-default scope must be nullable

- Repo: serverpod/serverpod_docs
- Existing: none found. Searched "serverOnly nullable", "scope=serverOnly". [serverpod/serverpod#3424](https://github.com/serverpod/serverpod/issues/3424) and [serverpod/serverpod#4174](https://github.com/serverpod/serverpod/issues/4174) are about `scope` with `default`, a different problem.
- Source: SPONSOR_FINDINGS F6

Reproduction

```yaml
class: Clinic
table: clinic
fields:
  boardTokenHash: String, scope=serverOnly
```

Run `serverpod generate`.

Expected

The model reference, which is where people look up a keyword, states the rule.

Actual

The generator refuses it with `The field "boardTokenHash" must be nullable when the "scope" property is set to "serverOnly".` The models page says "A field with a scope other than `all` must be nullable", but the `scope` row in `docs/06-concepts/lookups/model-reference.md` only says "Denotes the scope for a field."

Suggested fix

Add the rule to the `scope` row: "Fields with `serverOnly` or `none` must be nullable."

---

## 6. List the reserved field names for table models

- Repo: serverpod/serverpod_docs
- Existing: none found. Searched "reserved field name", "count reserved".
- Source: SPONSOR_FINDINGS F6

Reproduction

```yaml
class: RateBucket
table: rate_bucket
fields:
  bucketKey: String
  count: int
```

Run `serverpod generate`.

Expected

The docs list the names a table model can't use.

Actual

`The field name "count" is reserved and cannot be used.` The list lives only in the CLI, as `_databaseModelReservedFieldNames` in `serverpod_cli/lib/src/analyzer/models/validation/restrictions.dart`: `count`, `insert`, `update`, `deleteRow`, `delete`, `findById`, `findSingleRow`, `find`, `setColumn`, `toJsonForDatabase`, `tableName`, `include`, `db` and `table`. Dart keywords are also refused. No docs page mentions either list.

Suggested fix

A "Reserved names" section on the model reference page with both lists, generated from the CLI source so it can't drift.

---

## 7. Flutter web page: running your own service worker next to Flutter's

- Repo: serverpod/serverpod_docs
- Existing on the Flutter side: [flutter/flutter#156910](https://github.com/flutter/flutter/issues/156910), "Deprecate and remove `flutter_service_worker.js`", open. [flutter/flutter#177613](https://github.com/flutter/flutter/pull/177613) hid and deprecated `--pwa-strategy`, and [flutter/flutter#176834](https://github.com/flutter/flutter/pull/176834) made the default worker unregister itself. Both shipped in Flutter 3.41. No new Flutter issue is needed.
- Source: SPONSOR_FINDINGS F4, with a correction

Correction to F4: `--pwa-strategy` wasn't removed in Flutter 3.47.7. It's hidden from `flutter build web -h`, so it looks gone, but `build_web.dart` still accepts it and prints a deprecation warning. The Serverpod 4 Flutter web page doesn't mention the flag at all.

What the docs could cover

Without the flag, the default strategy is still `offline-first`. The build writes a `flutter_service_worker.js` that unregisters itself when it activates and reloads open pages, and the default `flutter_bootstrap.js` passes `serviceWorkerSettings` to the loader. In this version the loader registers `flutter_service_worker.js` only when the page already has a service worker registration. An app that registers its own worker at scope `/`, as a Web Push app has to, already has one. So on the next load, Flutter registers its worker at the same scope, which replaces the app's worker, and then the replacement unregisters the whole registration. If that's right, the push subscription goes with it.

We read this from the Flutter 3.47.7 sources: `service_worker_loader.js`, `bootstrap.dart` and `flutter_service_worker.js`. Confirm it on a built app before filing.

Suggested fix

A short section on the Flutter web page: if your app registers its own service worker, build with `--pwa-strategy=none` while Flutter still accepts it, or ship a `web/flutter_bootstrap.js` that calls `_flutter.loader.load()` without `serviceWorkerSettings`.

---

## 8. Installation: the PATH line after `dart install serverpod_cli` on macOS

- Repo: serverpod/serverpod_docs
- Existing: none found. Searched "dart install PATH", "Application Support/Dart/install".
- Source: SPONSOR_FINDINGS F2

Reproduction

On a clean macOS account, run `dart install serverpod_cli`, then `serverpod version` as the page says.

Expected

`serverpod version` prints the version.

Actual

"command not found". The binary is in `~/Library/Application Support/Dart/install/bin`, which isn't on PATH and has a space in it. Dart prints a warning with the export line, which is easy to miss. The agent setup prompt on the page asks the agent to make sure `serverpod` is on PATH, but the manual steps under it don't say how.

Suggested fix

After `dart install serverpod_cli`, add:

```bash
export PATH="$PATH:$HOME/Library/Application Support/Dart/install/bin"
```

with a note to put it in `~/.zshrc` and keep the quotes for the space.

---

## 9. Installation: a shallow Flutter clone for slow connections

- Repo: serverpod/serverpod_docs
- Existing: none found.
- Source: SPONSOR_FINDINGS F1

Reproduction

Download `flutter_macos_arm64_3.47.7-stable.zip` on a 10 Mbps link.

Expected and actual

The zip is 2,263,893,135 bytes, about 30 minutes at the 1.25 MB/s we measured. `git clone --depth 1 -b 3.47.7 https://github.com/flutter/flutter.git` was 223 MB, and `flutter --version` set up the Dart SDK in seconds.

Suggested fix

One line on the installation page, and in the agent setup prompt, offering the shallow clone as the fast path.

---

## 10. `decodePoint` and ECDH accept points that aren't on the curve

- Repo: bcgit/pc-dart
- Existing: none found. Searched "decodePoint curve", "point not on curve", "invalid curve", "ECDH validate point".
- Before filing: this is an invalid-curve weakness for anyone doing ECDH with a long-lived private key. The repo has no SECURITY.md, so contact the maintainers privately first and file publicly only if they agree.

Reproduction

```dart
// be32 writes a BigInt as 32 big-endian bytes.
final p256 = ECCurve_secp256r1();
// (1, 2) isn't on P-256.
final encoded = Uint8List.fromList([0x04, ...be32(BigInt.one), ...be32(BigInt.two)]);
final point = p256.curve.decodePoint(encoded); // returns a point
final ecdh = ECDHBasicAgreement()..init(ECPrivateKey(BigInt.from(12345), p256));
ecdh.calculateAgreement(ECPublicKey(point, p256)); // returns a value
```

Expected

`decodePoint` throws for an uncompressed point that doesn't satisfy y² = x³ + ax + b, and `calculateAgreement` refuses it.

Actual

Both succeed. `ECCurveBase.decodePoint` passes x and y straight to `createPoint`. `cleanPoint` in `ecc/ecdh.dart` re-encodes and decodes the point, which doesn't check it either. The cofactor step can't catch it on prime-order curves like P-256, where h is 1.

Suggested fix

Check the curve equation in `decodePoint` for uncompressed and hybrid encodings, or in `createPoint`, and throw `ArgumentError`. Docket works around it with its own check in `_p256Point` in `docket_server/lib/src/notify/web_push.dart`, since RFC 8291 section 7 requires one.

---

## 11. `GCMBlockCipher` block limit is -1 because `^` is XOR

- Repo: bcgit/pc-dart
- Existing: none found. Searched "GCM limit", "2 ^ 36", "GCM blocksRemaining".

Reproduction

`lib/block/modes/gcm.dart`, in `init` and `reset`:

```dart
_blocksRemaining = (2 ^ 36 - 64) ~/ bs;
```

In Dart, `^` is XOR and binds looser than `-`, so this is `2 ^ (36 - 64)`, which is `2 ^ -28`, which is -26. Divided by the 16-byte block size it's -1. `_getNextCTRBlock` checks `_blocksRemaining == 0` and then decrements, so starting from -1 the check never fires.

Expected

The NIST SP 800-38D limit on plaintext per key and nonce, 2^39 − 256 bits, which is 2^32 − 2 blocks of 16 bytes, is enforced.

Actual

No limit is enforced. In practice it only matters past about 64 GiB under one key and nonce, so the impact is small, but the check the code means to make never runs.

Suggested fix

```dart
_blocksRemaining = 0xFFFFFFFE; // 2^32 - 2 blocks
```

and `if (_blocksRemaining <= 0)` so a bad start value can't skip the check again.

---

## 12. RFC 8291 section 5 says Content-Length 145 for a 144-byte body

- Already reported as [erratum 5230](https://www.rfc-editor.org/errata/eid5230) by Martin Thomson on 2018-01-07, status Reported. Nothing to file.

The Appendix A example encrypts to 144 bytes, and section 5 shows `Content-Length: 145`. Docket's test in `docket_server/test/unit/notify/web_push_test.dart` pins 144 and names the erratum, so the next person who reproduces the vector doesn't lose time on it.
