---
trigger: model_decision
description: Rules for writing unit and widget tests
---

- When returning an entity or a JSON object that needs conversion, follow the pattern from `EntityFactory` and create a new `make` method (e.g., `newEntity`) if necessary. Use this entity in your tests. If you need to return a model or JSON, you can convert it using the model.
- Prefer using `mocktail` for mocking values.
- Every datasource, repository, and controller must have a corresponding test file.
- Every public function in a datasource, repository, or controller must have a test.
- Every time you use `verify` or `expect` from `mocktail`, you must validate all arguments being passed. You cannot use `any()` or `any(named: "")`.