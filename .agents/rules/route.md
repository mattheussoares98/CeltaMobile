---
trigger: manual
description: Rules for app navigation and routes
---

- You should follow the existing patterns found in the `lib/routing` folder.
- For every new page, create a new route in `lib/routing/routes.dart`.
- For ALL navigation in the app, use GoRouter via `context.go()` or `context.push()`.