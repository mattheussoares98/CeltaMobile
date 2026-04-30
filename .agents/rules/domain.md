---
trigger: manual
description: Rules for repository and entities
---

- Entity class names should end with `Entity`.
- Every entity file should end with `_entity.dart`.
- Repository implementations should end with `Impl` and omit the leading `I` from the abstract class name. They must also receive the abstract datasource via the constructor.
- Example: Abstract repository `ILocalLoadProductsRepository` and its implementation `LocalLoadProductsRepositoryImpl`.
- Entities must always extend `Equatable` and include all properties inside the `props` list.
- Every new entity generated from an ERP model should start with `BSF` in the name. This applies even when calling the Ec API, because Ec generally just serializes the ERP model.