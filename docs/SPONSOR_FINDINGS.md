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
