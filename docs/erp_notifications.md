# ERP mobile notifications

## Purpose

ERP alerts are converted into push notifications by the CMS service and sent
through the Supabase Edge Function `send-erp-notification`.

The mobile application does not create these notifications. It registers the
device session and FCM token that Supabase uses to select recipients.

## Current flow

1. The CMS checks its configured alerts.
2. When an alert must be propagated, the CMS calls:
   `POST /functions/v1/send-erp-notification/users`.
3. The request contains:
   - `baseUrl`: identifies the customer enterprise in Supabase.
   - `users`: ERP user names selected by the CMS configuration.
   - `platform`: `both`, `android`, or `ios`.
   - `title`: the CMS alert name.
   - `description`: the CMS description. When it is empty, the CMS sends
     `Uma ou mais questões aguardando resolução`.
4. The Edge Function authenticates the request using the configured API key.
5. Supabase resolves exactly one enterprise from `baseUrl`.
6. Supabase selects current FCM tokens from `user_session`, restricted by:
   - Supabase enterprise ID;
   - normalized ERP user name;
   - requested platform.
7. The database performs an atomic deduplication claim.
8. If allowed, the Edge Function sends the notification through Firebase
   Cloud Messaging.
9. Supabase saves the delivery counts and any Firebase error codes in
   `erp_notification_deduplication`.

## Validation and limits

- Requests accept at most 500 users.
- Titles are truncated to 150 characters.
- Descriptions are truncated to 1,000 characters.
- The complete request body is limited to 128 KiB.
- Firebase deliveries are divided into batches of at most 500 tokens.
- Transient Firebase failures are retried up to three times.
- Invalid or expired tokens are reported as delivery failures.

## Deduplication

The current deduplication window is five minutes.

A notification is considered duplicated by its normalized title and
description. The enterprise is saved for auditing but is not part of the
duplicate comparison.

Consequently, two customers producing the same title and description within
five minutes are currently treated as the same notification. A tester copy
added after this check would receive only notifications accepted by the
deduplication rule, not every incoming CMS request.

## Recommended tester-copy design

The tester override must exist only inside the protected Edge Function. It
must not be implemented in the CMS or mobile application and must not weaken
the normal enterprise-scoped recipient query.

Configure the tester through Edge Function environment variables:

- enabled flag;
- tester Supabase enterprise ID;
- normalized tester user name;
- tester platform.

Initial tester values:

- Supabase enterprise ID: `111`;
- enterprise: `celtateste`;
- user name: `soares celta`;
- platform: `ios`.

For every notification accepted for delivery:

1. Resolve normal customer recipients using the customer enterprise.
2. Return the customer enterprise name together with its ID during the existing
   `baseUrl` lookup; an additional unrestricted table query is unnecessary.
3. Resolve the tester token separately using the configured tester enterprise,
   user name, and platform.
4. Send the normal notification to customer recipients:
   - title: original title;
   - description: original description.
5. Send a separate tester copy:
   - title: original title;
   - description: `{customer enterprise name} — {original description}`.
6. Deduplicate tokens before delivery so the same physical device never
   receives both copies when it is already a normal recipient.

The separate delivery is mandatory because Firebase multicast applies the same
title and description to every token in a batch.

## Tester-copy accounting

Tester delivery results should be logged separately from customer delivery
results. They should not change:

- the API status returned to the CMS;
- customer `sent` and `failed` counts;
- the decision to invalidate or retry a customer delivery.

A tester-token failure must never make an otherwise successful customer
notification fail.

## Security

- Never store the CMS API key, Supabase secret key, Firebase service account,
  or FCM token in this repository.
- Keep tester configuration in protected Edge Function environment variables.
- Never query a tester by user name alone. Always require the configured
  Supabase enterprise ID and platform.
- The `service_role` or Supabase secret key must never be exposed to
  CeltaMobile.

## Operational notes

- Updating the tester's iOS token requires only a normal CeltaMobile session
  synchronization; the Edge Function should resolve the latest token for every
  delivery.
- Disabling the tester-copy flag must immediately stop cross-customer copies
  without requiring a CMS or mobile release.
- Tester notifications contain customer information. Access must be explicitly
  authorized and disabled when testing finishes.
