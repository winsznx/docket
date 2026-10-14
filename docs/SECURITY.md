# Security and privacy

Docket handles walk-in patients at clinics, so the rule is to keep as little as possible and seal what it must keep. Patients have no accounts. A ticket link is the patient's only key, staff sign in with email, and contact details are encrypted and deleted the day after the visit. This page lists the threats Docket defends against, who can do what, how phones and links are sealed, the rate limits, the nightly purge and what's out of scope.

## Threats and controls

| Threat | Control |
| --- | --- |
| Guessing ticket links | `Tokens.mint` in [`security/tokens.dart`](../docket_server/lib/src/security/tokens.dart) draws 32 random bytes from `Random.secure` and encodes them as base64url, so tokens carry 256 bits. Only the SHA-256 hash is stored, behind a unique index. `Tokens.looksValid` refuses malformed tokens before any query. The `ticket` endpoint has a per-IP ceiling |
| Spam joins | A per-IP ceiling on `publicClinic`, at most 2,000 joins per clinic per service day counted in `RateBucket`, the join cutoff time, and desk removal with a reason |
| A stolen ticket link | The link is the capability, and the patient page says "Anyone with this link can see and cancel this ticket." Leaving asks for confirmation. The desk can re-link with `linkPhone`, which rotates the token so the old link stops working, and re-seals the push and SMS links |
| Staff account takeover | Email verification through `serverpod_auth_idp`, JWTs with rotating refresh tokens, membership read from `StaffMember` on every call, and an owner can deactivate staff. The last active owner can't be deactivated |
| Replayed desk actions | A unique `actionId` index on `DeskActionReceipt`, per-device `seq`, and authorization checked again for every action in a sync batch. A batch action whose `deviceId` doesn't match the batch is rejected |
| Sandbox abuse | Sandbox tokens work only on sandbox clinics. Sandboxes never send SMS, hold at most 200 tickets, add 1 to 10 demo patients per call, expire after 24 hours and are deleted by the nightly job. Starting one is limited per IP |
| SMS cost abuse | Texts go out only on clinics with SMS on, never from a sandbox, only with consent, to one target per ticket, and only for the kinds `NotificationPolicy` allows |
| Push endpoint abuse | Subscriptions must be HTTPS on port 443 to `fcm.googleapis.com`, `updates.push.services.mozilla.com`, `web.push.apple.com` or a host under `notify.windows.com`, so a client can't make the server POST to an arbitrary URL. The browser's public key must be a point on P-256 |
| Script injection through names | Flutter renders plain text. The first-paint script in `docket_flutter/web/index.html` writes with `textContent`. Names are capped at 40 characters with control characters stripped |
| Personal data | Names are optional and default to "Patient". Phones are encrypted. Contact data lives in server-only models. A purge runs 24 hours after the day closes. The CSV export has no names or phones. There are no medical fields, and the priority note is capped at 60 characters with a "No medical details" hint |
| Forged Twilio delivery reports | `/api/twilio/status` checks `X-Twilio-Signature`, an HMAC-SHA1 over the URL and sorted form fields keyed by the auth token, compared in constant time. It answers 404 when Twilio isn't configured |
| A leaked board link | The board shows labels, room names and waiting counts, never patient names. The owner can rotate the board token, which ends every open board stream on the old link |
| Leaked staff invites | Invite codes are 128 bits, stored only as a hash, single use and valid for 48 hours |
| Secrets in the repo | `config/passwords.yaml` is gitignored, Cloud passwords hold production values, and `tool/secrets.dart` writes and copies secrets without printing them. Nothing secret ships to the client. The VAPID public key is public by design |

## Trust boundaries

| Actor | Can do | Authenticates with | Checked in |
| --- | --- | --- | --- |
| Patient | Join a line, read and watch their own ticket, confirm, leave, turn alerts on or off, add a phone when the clinic has SMS | The ticket token in the URL, no account | `TicketEndpoint.resolve` hashes the token and looks up the ticket. `FirstPaintRoute` uses the same lookup |
| Desk | Every desk action for their clinic: call, recall, start, finish, no-show, remove, add walk-ins and priority patients, transfer, room state, close day, re-link | Email sign-in, then an active `StaffMember` row for that clinic with role `desk` or `owner` | `ClinicAuth.desk` in [`security/clinic_auth.dart`](../docket_server/lib/src/security/clinic_auth.dart), in every `DeskEndpoint` method and again for every action in a sync |
| Owner | Desk powers plus settings, lines, rooms, staff invites, deactivation, board token, reports, audit and the notification log | Email sign-in, then an active `StaffMember` row with role `owner`. Creating a clinic needs only a signed-in user, who becomes its owner | `ClinicAuth.owner`, in every `OwnerEndpoint` method except `createClinic` |
| Board | Read the board view and its stream | The board token in the URL, matched by hash against `Clinic.boardTokenHash` | `BoardEndpoint._clinic`, and again on every stream event |
| Sandbox | Desk and owner powers on one sandbox clinic | The sandbox token returned once by `SandboxEndpoint.start`, matched by hash, valid only while the clinic is a sandbox and unexpired | `ClinicAuth` when a sandbox token is passed, `SandboxEndpoint.addDemoWalkIns` |
| System | Grace and arrival expiry, re-slots, reminders, dispatch, day close, reports, purges | Runs inside the server as future calls or `LocalScheduler`. No client can call it | Ticket timers re-check state and `callVersion` in their own transaction, so a late or repeated run changes nothing |

Clinic roles are checked in code against `StaffMember`, never with global auth scopes, because one person can own one clinic and staff another. `DeskEndpoint` and `OwnerEndpoint` keep `requireLogin` off so sandbox tokens work, and every method authorizes first. `StaffEndpoint`, which lists memberships and accepts invites, requires sign-in. Each `TicketEvent` records the actor type and a reference, which is the staff member id for desk and owner actions.

Staff sign-in uses the auth module's default token storage on the web. Cookie auth is off because the app and the API sit on different hosts on Serverpod Cloud, which `docs/DECISIONS.md` explains.

## How phones and links are sealed

`PhoneCipher` in [`security/phone.dart`](../docket_server/lib/src/security/phone.dart) is AES-256-GCM under the `phoneEncryptionKey` password, which is 32 random bytes in base64. Every call draws a fresh 12-byte nonce from `Random.secure` and stores `base64(nonce || ciphertext || tag)` with a 128-bit tag. Decrypting with the wrong key or altered data fails with a `FormatException`. `AppConfig.sealer` throws when the key is missing, so a missing key fails the write instead of storing a phone in the clear.

| Sealed value | Where | Why it's kept | Who decrypts |
| --- | --- | --- | --- |
| The phone number | `SmsTarget.phoneCipher` | To send texts. Only the last four digits sit in the clear, in `phoneLast4`, for the patient page | `Dispatcher._sms` |
| The ticket URL | `SmsTarget.linkCipher`, `PushTarget.linkCipher` | Texts and pushes carry the patient's link, and the raw token is otherwise never stored | `Dispatcher` |
| The new ticket's token after a transfer | `Ticket.transferTokenCipher` | So the old link can follow the patient to the new ticket | `Views.patient` |

Phones are normalized by `normalizePhoneE164` before sealing. Nigerian local numbers like `08031234567` become `+2348031234567`, and anything that isn't valid E.164 is refused at entry. Twilio errors that echo the recipient have the number replaced before they're logged or stored.

Push subscription endpoints and keys sit in `PushTarget`, a server-only table, and are deleted by the nightly purge. Push payloads are encrypted to the browser per RFC 8291, so the push service sees only metadata.

## Rate limits

`rateLimitMiddleware` in [`web/rate_limit.dart`](../docket_server/lib/src/web/rate_limit.dart) runs on the API server through `pod.server.addMiddleware`. It keys on the endpoint name and the client address, taken from the first `X-Forwarded-For` entry behind Cloud's load balancer or the socket address otherwise. Each key gets a fixed one-minute window, and anything over the ceiling gets a 429 with "Too many tries. Wait a minute and try again."

| Endpoint | Calls per IP per minute |
| --- | --- |
| `sandbox` | 6 |
| `publicClinic` | 60 |
| `staff` | 60 |
| `board` | 120 |
| `ticket` | 240 |
| `owner` | 240 |
| `desk` | 600 |

These counters live in memory on each podlet. The hard limits live in Postgres, so they hold across podlets and restarts:

- `QueueService.maxJoinsPerClinicDay` caps joins at 2,000 per clinic per service day, counted with an upsert on `RateBucket` under `joins:<clinicId>` inside the join transaction.
- `QueueService.maxSandboxTickets` caps a sandbox at 200 tickets.
- `DeskEndpoint.sync` takes at most 200 actions per batch.

## Nightly purge

`ClinicJobs.nightly` runs at 01:00 UTC, which is 02:00 in Lagos.

- For every service day that closed more than 24 hours ago, it deletes the `SmsTarget` and `PushTarget` rows of its tickets and renames the tickets to "Patient".
- It deletes expired sandbox clinics with their lines, rooms, tickets, events, notifications, receipts, presence rows, reports, invites, samples and contact targets.
- It deletes `RateBucket` rows older than two days.
- It clears `reason` and `actorRef` on ticket events older than 30 days.
- It stores a `DayReport` for each closed day. Reports hold counts and timings per line, with no names or phones.

## Out of scope

- Volumetric denial of service. The per-IP limits are a speed bump. If the load balancer appends to a client-sent `X-Forwarded-For` instead of replacing it, a client can choose its own key. The per-clinic caps in Postgres are the hard limit.
- Web routes such as `/api/t/<token>` and `/api/poster/<slug>` sit on the web server, outside the API middleware, so they have no per-IP ceiling. Guessing a 256-bit ticket token through `/api/t/` is still infeasible. Each poster is a PDF built on request, so repeated poster requests cost CPU.
- Anyone who holds a ticket link. The link is the capability by design, and a patient can share it.
- An attacker with access to the server or the Serverpod Cloud project. `phoneEncryptionKey` lives beside the database credentials, so that attacker can decrypt contact data until the purge runs.
- The desk device. The offline desk keeps the clinic's ticket list, including display names, in the browser's SQLite database. Securing that computer is the clinic's job.
- Staff email accounts. Whoever controls a staff member's inbox can sign in as them until an owner deactivates the membership.
- Data in transit through third parties. Texts travel in the clear over carrier networks and carry the ticket link. Push services see delivery metadata.
- Medical data. Docket has no medical fields. The priority note is free text capped at 60 characters with a "No medical details" hint, and a person can still ignore the hint.
