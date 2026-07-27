# ERP Push Notification Implementation Plan

## Current-state finding

Step 1 was completed in read-only mode on 2026-07-27.

The Supabase project configured by CeltaMobile is
`ktodulvteumcqjcdezon`. It is the project that owns the notification data:

- `public.enterprises` has 111 rows, RLS enabled, and these relevant columns:
  - `id bigint` identity primary key;
  - `name text` unique;
  - `remote_http_url text` required;
  - `remote_https_url text`, `local_http_url text`, and `local_https_url text`
    nullable.
- `public.user_session` has 707 rows, RLS enabled, and these columns:
  - `user_name text` required;
  - `device_type device_platform` with `android`, `ios`, `web`, `windows`, and
    `macos`;
  - `fcm_token text` nullable;
  - `updated_at timestamptz` nullable with `now()` as its default;
  - `enterprise_id bigint` required with a cascading foreign key to
    `enterprises.id`;
  - `app_version text` nullable.
- The current `user_session` primary key is
  `(user_name, device_type, enterprise_id)`.
- A second unique index exists on
  `(lower(trim(user_name)), device_type, enterprise_id)`.
- There is no URL lookup index on any of the four enterprise URL columns.

Current data confirms the installation migration is necessary:

- 592 session rows have a non-empty FCM token, representing 591 distinct tokens.
- One token currently appears in two enterprises; no token is associated with
  multiple normalized user/platform pairs.
- 115 rows have no usable FCM token.
- Android has 441 session rows and 438 usable-token rows.
- iOS has 220 session rows and 154 usable-token rows.
- App versions are distributed across many releases, so `installation_id` must be
  nullable and backward compatible during rollout.
- Complete lowercasing and trailing-slash removal produce one ambiguous normalized
  URL shared by two enterprises. The lookup must retain the planned `409` behavior
  until that data is corrected.

Existing database functions:

- `handle_user_session(text, device_platform, bigint, text, text)` lowercases the
  user name and upserts by the current primary key. It is `SECURITY DEFINER`.
- A legacy four-argument `handle_user_session` overload also remains deployed.
- `delete_user_session(text, device_platform, integer)` deletes by user, platform,
  and enterprise, so it cannot distinguish two installations using the same
  account and platform.
- All three functions grant execution to `PUBLIC`, `anon`, and `authenticated`.
- `user_session` grants table privileges to `anon` and has an `ALL` RLS policy with
  `USING (true)` and `WITH CHECK (true)`.
- The Supabase security advisor reports both the unrestricted `user_session` policy
  and anonymous execution of the `SECURITY DEFINER` session function. It also
  reports a mutable search path for `delete_user_session`.

Existing Firebase implementation:

- The active Edge Function is `send-celta-mobile-notification`, version 9.
- It uses `firebase-admin@12.1.0` and the existing
  `FIREBASE_SERVICE_ACCOUNT_KEY` secret.
- It accepts caller-supplied `tokens`, `title`, and `body`, then calls
  `sendEachForMulticast`.
- It has `verify_jwt = false` and performs no authentication in its handler.
- It returns only `successCount`, exposes raw exception messages, and does not
  process individual invalid-token results.
- No CeltaMobile source code invokes this Edge Function directly.
- The mobile app retrieves an initial FCM token during session synchronization and
  displays foreground/background notifications, but it has no FCM token-refresh
  listener.

The new ERP notification operation should reuse the existing Firebase secret and
sender capability, but not the existing unauthenticated public contract.

## Recommended architecture

Create a service-to-service Supabase Edge Function, provisionally named
`send-erp-notification`.

The ERP will call the function over HTTPS. The Edge Function will authenticate the
ERP request, validate it, resolve the enterprise and its eligible sessions, and then
call Firebase Cloud Messaging (FCM). Database credentials and Firebase credentials
must remain server-side secrets.

Expose two explicit operations while reusing the same internal enterprise lookup,
recipient resolution, and FCM sender:

- send to selected users;
- send to every eligible user in one enterprise.

An empty or omitted user list must never mean "send to everyone."

## Proposed request contracts

### Selected users

`POST /functions/v1/send-erp-notification/users`

```json
{
  "bsfUrl": "https://example.com/bsf/",
  "users": ["USER ONE", "USER TWO"],
  "platform": "android",
  "title": "Notification title",
  "description": "Notification description"
}
```

### All users in one enterprise

`POST /functions/v1/send-erp-notification/enterprise`

```json
{
  "bsfUrl": "https://example.com/bsf/",
  "platform": "ios",
  "title": "Notification title",
  "description": "Notification description"
}
```

Validation rules:

- Accept only `POST` with `application/json`.
- Require a non-empty `bsfUrl`, `title`, and `description` for both operations.
- Require a non-empty `users` list only for the selected-users operation.
- Trim every input string.
- Reject an empty user list and empty user names after trimming.
- Deduplicate requested users using the same normalized comparison used by the
  database lookup.
- Treat `platform` as optional:
  - omitted: target both Android and iOS;
  - `android`: target Android sessions only;
  - `ios`: target iOS sessions only;
  - any other value: reject the request with `400 invalid_platform`.
- Define safe maximum lengths and a maximum number of users per request.
- Do not log authorization headers, Firebase credentials, full FCM tokens, or the
  complete notification description.

## Implementation phases

### 1. Confirm the target project and database contract — completed

- Confirm the Supabase project that owns `enterprises` and `user_session`.
- Inspect the exact schema and types for:
  - the enterprise primary key;
  - `remote_http_url`, `remote_https_url`, `local_http_url`, and
    `local_https_url`;
  - the session enterprise foreign key;
  - the user-name column;
  - `fcm_token`;
  - the current session uniqueness constraints and indexes;
  - the exact definitions, grants, RLS interaction, and security mode of
    `handle_user_session` and `delete_user_session`;
  - session activity/expiration fields, if present;
  - user notification preference fields, if present.
- Inspect any existing Edge Function or shared Firebase sender and reuse its
  established authentication and response conventions.
- Decide whether user names are guaranteed unique within an enterprise. If they are
  not, extend the ERP contract to send a stable user identifier. Until then, an
  ambiguous normalized name must not silently notify multiple unrelated accounts.

### 2. Add `installation_id` with a backward-compatible rollout — implementation completed; device rollout pending

- Add a nullable UUID `installation_id` column to `user_session`. Do not generate
  server-side values for existing rows because the database cannot know which rows
  belong to the same physical app installation.
- Create a partial unique index on `installation_id` for rows where it is non-null.
  A regular non-unique index is insufficient because it would still allow the same
  installation to be associated with different enterprises.
- Inspect existing indexes and table activity before deciding whether index creation
  must use a low-lock/concurrent deployment procedure.
- The mobile app now generates an RFC 4122 UUID v4 installation ID on its first
  launch after the update and persists it in the existing local `user_session` Hive
  box. Logout preserves it. It is an app-installation identifier, not a hardware
  identifier and not an authentication credential.
- The live database now has:
  - nullable UUID column `user_session.installation_id`;
  - partial unique index `user_session_installation_id_uniq` for non-null IDs;
  - `handle_user_session_v2(..., p_installation_id uuid)` with an explicit required
    installation ID;
  - `delete_user_session_v2(p_installation_id uuid)` for exact-installation logout.
- Versioned RPC names were chosen because two `handle_user_session` overloads
  already exist. Both legacy RPC contracts remain unchanged, preventing PostgREST
  overload resolution changes for more than 700 existing clients.
- The v2 functions use `SECURITY INVOKER`, an empty fixed `search_path`, and explicit
  grants to `anon`, `authenticated`, and `service_role`; they are not granted to
  `PUBLIC`.
- `handle_user_session_v2` serializes concurrent updates for the same installation,
  removes its previous row and matching legacy null-ID rows for the same non-empty
  FCM token, then upserts the current user, enterprise, platform, token, version, and
  timestamp.
- All 707 existing rows remain unchanged with a null installation ID.
- A rollback-only smoke test executed the v2 RPCs as `anon`, switched one test
  installation between two enterprises, verified that exactly one current row
  remained, verified exact-installation deletion, and left no test data.
- When an updated installation synchronizes for the first time, reconcile its
  legacy rows using its current non-empty FCM token, keep one current row, attach the
  installation ID, and remove or deactivate superseded rows in the same transaction.
- Logout/removal now identifies the exact installation through
  `delete_user_session_v2`. It no longer deletes sessions using only user name,
  platform, and enterprise, which could affect another device using the same
  account.
- Keep `installation_id` nullable until the supported mobile versions guarantee that
  all active devices send it. Do not block notification delivery while more than 700
  existing devices are gradually updated.
- Track rollout adoption by app version and platform using counts only. Do not log
  installation IDs or FCM tokens.
- After the migration window, decide whether to:
  - make `installation_id` mandatory for active mobile sessions;
  - reject the legacy RPC contract;
  - remove any remaining legacy duplicate rows.

### 3. Define authentication and authorization

- Treat this as a backend-to-backend endpoint; do not expose it to anonymous or
  mobile-client callers.
- Create a dedicated rotatable credential for the ERP caller and store the expected
  value in Supabase Edge Function secrets.
- Authenticate the request before performing database reads.
- Use constant-time credential comparison where the selected authentication scheme
  requires direct secret comparison.
- Add request rate limiting or an equivalent abuse control.
- Keep Firebase service-account material in Edge Function secrets; never store it in
  source code or return it in errors.

### 4. Centralize URL normalization

- Define one canonical normalization operation:
  1. trim surrounding whitespace;
  2. convert the entire URL to lowercase, as required by the ERP lookup contract;
  3. remove all trailing `/` characters;
  4. reject a result that is empty or is not an absolute HTTP/HTTPS URL.
- Treat the normalized URL only as an enterprise lookup key. Never reuse the
  lowercased value to make an HTTP request.
- Apply exactly the same operation to the incoming URL and all four enterprise URL
  columns.
- Prefer a database normalization function or stored normalized columns so matching
  rules cannot drift between TypeScript and SQL.
- Add indexes suitable for normalized lookup after examining table size and current
  indexes. Avoid a permanent four-column sequential scan as the table grows.
- Enforce that a normalized BSF URL resolves to exactly one enterprise:
  - zero matches: return `404 enterprise_not_found`;
  - more than one match: return `409 ambiguous_enterprise_url`;
  - one match: continue with its `enterprise_id`.

### 5. Resolve target sessions and tokens

- Normalize requested user names consistently (at minimum trim and lowercase).
- Resolve the current row for each installation before applying the enterprise,
  user, or platform filters:
  - for non-null `installation_id`, the partial unique index and upsert contract make
    that row authoritative;
  - for legacy null-ID rows, use the latest `updated_at` row for each non-empty FCM
    token as the temporary best approximation of the current installation.
- Only after current-installation resolution, filter by the resolved
  `enterprise_id`. This prevents a stale login from another enterprise from
  receiving the notification.
- Apply the optional `platform` filter using normalized `android`/`ios` session
  values.
- For the selected-users operation, filter to the requested users.
- For the enterprise operation, include all eligible users in that enterprise;
  never infer this behavior from an empty user list.
- Require `fcm_token` to be non-null and non-empty.
- If the schema supports it, also require an active, non-expired session and enabled
  push-notification preference.
- Deduplicate identical FCM tokens after current-installation and enterprise
  resolution, including during the legacy migration window.
- Track requested user names that were not found and users that had no usable token.
- Do not return FCM tokens to the ERP.

### 6. Handle FCM token creation and refresh — implementation completed; device verification pending

- Continue obtaining the initial FCM token when synchronizing the session.
- Subscribe to Firebase Messaging token-refresh events on supported mobile
  platforms.
- When the token changes, upsert the same `installation_id` row with the new token
  and refresh `updated_at`; do not create a second installation row.
- If refresh synchronization fails, retain the installation ID locally and retry
  with bounded backoff or during the next safe session synchronization.
- Remove the existing debug output that prints the complete FCM token.
- Add focused tests for initial token registration, token refresh, repeated refresh
  with the same token, refresh failure, and refresh after an enterprise change.

### 7. Send through Firebase Cloud Messaging

- Reuse the existing Firebase sender if one exists and is compatible with FCM HTTP
  v1.
- Otherwise, implement a small Firebase gateway that:
  - creates/refreshes a Google OAuth access token from service-account secrets;
  - sends the title and description through the FCM HTTP v1 API;
  - limits concurrency and uses bounded batches to protect the Edge Function and FCM;
  - applies short timeouts;
  - retries only transient failures (`429` and selected `5xx`) with bounded
    exponential backoff;
  - never retries permanent invalid-token or invalid-payload errors.
- Record invalid/unregistered tokens for cleanup. Token deletion or invalidation
  should be a deliberate database operation with a focused test, not an incidental
  side effect hidden inside generic error handling.
- Return a partial-success summary rather than failing the whole request after one
  token fails.
- Estimate the maximum enterprise broadcast size before choosing synchronous
  delivery. If it can exceed safe Edge Function execution limits, persist a job,
  return `202`, and process bounded batches asynchronously.

### 8. Define stable responses

Suggested success response:

```json
{
  "ok": true,
  "enterpriseId": "<id>",
  "audience": "users",
  "platform": "android",
  "requestedUsers": 2,
  "matchedUsers": 2,
  "uniqueTokens": 3,
  "sent": 2,
  "failed": 1,
  "usersNotFound": [],
  "usersWithoutToken": []
}
```

Response behavior:

- `200`: all eligible tokens accepted by FCM.
- `207`: mixed FCM result or some requested users had no eligible token.
- `400`: malformed JSON or invalid fields.
- `401`/`403`: missing or invalid ERP authentication.
- `404`: no enterprise matches the normalized BSF URL.
- `409`: URL or user-name match is ambiguous.
- `422`: enterprise exists, but no eligible recipient token remains.
- `429`: caller rate limit exceeded.
- `502`/`503`: Firebase or another required dependency is unavailable.

Every response should contain a request/correlation ID. Internal error details,
database values, credentials, and tokens must not be exposed.

For an enterprise-wide asynchronous broadcast, return `202` with a job/request ID
instead of a final sent/failed summary.

### 9. Observability and idempotency

- Accept or generate a correlation ID and include it in structured logs.
- Log counts, audience type, platform, app-version adoption, and normalized error
  codes, not tokens, installation IDs, user names, or notification content.
- Add an ERP-supplied idempotency key if ERP retries could otherwise send duplicate
  notifications.
- If idempotency is added, persist request status and a request-body hash with an
  expiry; return the stored result for a repeated identical request and reject reuse
  with a different payload.
- Require idempotency before enabling enterprise-wide broadcasts because their
  larger blast radius makes duplicate delivery more costly.

### 10. Verification

Create focused tests for:

- URL trimming, lowercasing, and removal of one or multiple trailing slashes;
- path-case variants matching because the complete lookup URL is lowercased;
- confirmation that the normalized lookup URL is never used for outbound HTTP;
- matching each of the four enterprise URL columns;
- no enterprise and duplicate-enterprise matches;
- invalid request and invalid authentication;
- omitted, Android, iOS, and invalid platform values;
- duplicate/case-varied user names;
- selected-user and enterprise-wide audience separation;
- empty users never triggering an enterprise-wide broadcast;
- nullable installation IDs during the rollout;
- unique non-null installation IDs across enterprises;
- upsert of the same installation after changing enterprises;
- exact-installation logout without affecting another device;
- lazy reconciliation of legacy rows;
- legacy latest-token-row selection before enterprise filtering;
- missing users, missing tokens, duplicate tokens, and expired sessions;
- duplicate user-name ambiguity;
- initial FCM token registration and token refresh;
- full success, partial FCM failure, total FCM failure, timeout, retry, and invalid
  token handling;
- synchronous and queued enterprise-broadcast behavior, as applicable;
- idempotent retry behavior, if enabled;
- secret/token redaction in logs and responses.

Then verify in a non-production environment:

1. Invoke the function with a known enterprise and test device.
2. Confirm exactly one notification per unique token.
3. Confirm unknown URLs cannot send notifications.
4. Confirm users from another enterprise cannot receive the notification.
5. Log the same installation into Enterprise A and then Enterprise B; confirm only
   Enterprise B can target it.
6. Confirm an Android-only request does not notify iOS, and vice versa.
7. Confirm a legacy app remains usable during the nullable-column rollout.
8. Refresh an FCM token and confirm only the new token remains active for the
   installation.
9. Run Supabase database/security advisors after any schema or function changes.
10. Review Edge Function logs and FCM results using only redacted identifiers.

## Implementation order after approval

1. Confirm the correct project and inspect the real tables/current Firebase code.
2. Finalize the authentication, ambiguity, and idempotency contracts.
3. Add the nullable `installation_id`, partial unique index, and backward-compatible
   RPC changes. — completed
4. Update the mobile installation-ID registration, exact logout, and FCM token
   refresh flow. — completed in source; real-device verification pending
5. Add the URL-normalization/database lookup changes.
6. Implement both Edge Function operations and the shared Firebase gateway.
7. Add focused automated tests.
8. Deploy to a development environment and perform the legacy and updated-device
   end-to-end checks.
9. Monitor adoption by app version and platform before retiring legacy behavior.
10. Review results before any production deployment.

## Decisions required before implementation

- Are normalized `user_name` values stable user identifiers between ERP and mobile,
  or must the ERP send a separate immutable user ID?
- Should missing users produce partial success or reject the complete request?
- Should disabled/expired sessions and disabled notification preferences be ignored?
- Is there already a Firebase sender and service-account secret to reuse?
- What credential will identify the ERP caller?
- Can the ERP provide a stable notification/idempotency key?
- What app-version adoption threshold or minimum supported version will allow the
  legacy null-`installation_id` path to be removed?
- What enterprise size should trigger queued rather than synchronous broadcast
  delivery?
