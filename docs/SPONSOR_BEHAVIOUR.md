# Sponsor behaviour

How Serverpod and Serverpod Cloud behave under Docket, measured on the deployed app. Every number here is filled from real runs and carries its run count. A row with an empty Result hasn't been measured yet, and nothing goes in it until it has. The README and the film quote numbers only from this table.

| Measure | Start to end | Method | Runs | Sets | Result |
| --- | --- | --- | --- | --- | --- |
| Acknowledge latency | Desk tap to `act` result | Client timestamps | 10 | Button pressed state | |
| Perceptual latency | Desk tap to visible change on the phone | Desk and phone filmed in one 60 fps frame, frames counted | 10 | "Line moved" copy, README claim | |
| Timer completion | Scheduled grace end to visible re-slot | Insights timestamps against the schedule | 5, one across a restart | Countdown wording | |
| Reconnect | Network back to fresh view | Playwright offline toggle | 5 | "Reconnecting" chip | |
| First paint | Navigation to label on screen, Fast 3G | Chrome performance trace | 5 | First-paint budget | |
| Idle socket survival | Seconds an idle stream lives on Cloud | Long idle run | 3 | `websocketPingInterval` | |
| Podlets | Count on the chosen plan | Cloud console | 1 | Redis decision | |

## Filling in a row

- Result holds the median and the spread, such as the p95 or the minimum and maximum, with the number of runs actually made.
- Say where it ran, local or Serverpod Cloud, and the date.
- Keep the raw readings in the repo and link them from the row.
- A run that failed or was thrown out is noted under the table with the reason, not dropped.
