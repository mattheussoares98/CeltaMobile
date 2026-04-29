---
trigger: model_decision
description: Rules for datasource and models
---

- Every model should implement its equivalent entity whenever possible.
- Every model should end with `Model` in its class name.
- Every model file should end with `_model.dart`.
- Every model should implement `fromJson`, `toJson`, `fromEntity`, and `toEntity` methods.
- Datasource abstract classes must start with an `I`.
- Datasource implementations should have the exact same name but without the leading `I`.
- Example: Abstract datasource `ILocalLoadProductsDatasource` and its implementation `LocalLoadProductsDatasource`.