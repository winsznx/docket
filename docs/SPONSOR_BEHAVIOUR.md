# Sponsor behaviour

How Serverpod and Serverpod Cloud behave under Docket, measured on the deployed app. Every number here is filled from real runs and carries its run count. A row with an empty Result hasn't been measured yet, and nothing goes in it until it has. The README and the film quote numbers only from this table.

| Measure | Start to end | Method | Runs | Sets | Result |
| --- | --- | --- | --- | --- | --- |
| Acknowledge latency | Desk tap to `act` result | Client timestamps | 10 | Button pressed state | |
| Perceptual latency | Desk tap to visible change on the phone | Desk and phone filmed in one 60 fps frame, frames counted | 10 | "Line moved" copy, README claim | |
| Timer completion | Scheduled grace end to visible re-slot | A client polls the ticket every 500 ms and compares with the `graceEndsAt` the server returned, so each reading can be up to 500 ms late | 5, four across a restart or redeploy | Countdown wording | Local, future calls, server killed and restarted inside a 60 s window: 401, 773, 784 ms (3 runs). Serverpod Cloud Starter, in-process sweep, redeploy inside a 180 s window: 1148 ms (1 run). Local, in-process sweep: 1132 ms (1 run). Raw: [measurements/restart-2026-10-14.txt](measurements/restart-2026-10-14.txt) |
| Reconnect | Network back to fresh view | Playwright offline toggle | 5 | "Reconnecting" chip | |
| First paint | Navigation to label on screen, Fast 3G | Chrome performance trace | 5 | First-paint budget | |
| Idle socket survival | Seconds an idle stream lives on Cloud | Long idle run | 3 | `websocketPingInterval` | |
| Podlets | Count on the chosen plan | `serverpod cloud project show docket` | 1 | Redis decision | 1 podlet, small compute, Starter plan, 2026-10-14. One podlet needs no Redis. |

## Load, PRD 22.4

| Where | Streams | Calls | Samples | p50 | p95 | Max | Raw |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Local, M1 Pro, server and clients on one machine, 2026-10-14 | 300 | 15, one every 2 s | 4,500 | 180 ms | 196 ms | 209 ms | [load-local-2026-10-14.txt](measurements/load-local-2026-10-14.txt) |

Latency is from the desk's `act` result to each client receiving the view with the new line version. The first local run, before the line snapshot cache was single-flight, timed out Call next after 20 s with 300 streams open. That run is why the cache changed.

## Filling in a row

- Result holds the median and the spread, such as the p95 or the minimum and maximum, with the number of runs actually made.
- Say where it ran, local or Serverpod Cloud, and the date.
- Keep the raw readings in the repo and link them from the row.
- A run that failed or was thrown out is noted under the table with the reason, not dropped.
