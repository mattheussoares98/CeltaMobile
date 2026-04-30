---
trigger: manual
description: Rules for riverpod providers and controllers
---

- You should find the default folder where providers are located, and create a new provider for every new datasource and repository.
- When you need to get the state of a provider, use `AsyncValueWidget`. In the `tryAgain` constructor, only call `ref.invalidate` if the data is being loaded inside the provider's build method.
- When possible, use a `Consumer` widget to watch a specific provider. This avoids rebuilding the entire page. For example, instead of watching a value inside the `build` method of a `Scaffold` (which rebuilds the `AppBar` too), wrap the specific body widget in a `Consumer`.
- When using `ref.watch` and the component only needs a specific property, use `.select()` to avoid listening to unnecessary changes.