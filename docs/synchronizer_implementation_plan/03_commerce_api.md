# Commerce API Plan

Read this file for common Commerce API contracts, controller behavior, authorization, DTOs, and adapter infrastructure.

## Request contract

- [x] Add `SynchronizerErrorSearchOperation`.
  - Result: numeric `SearchCount` and `SearchByKey`; model Release build passed.
- [x] Add `SearchSynchronizerErrorsParameters`.
  - Result: inherits `SearchBaseParameters` and contains enterprise, operation, and optional key; model Release build passed.
- [x] Add GET example parameters.
  - Result: controller-root GET returns the complete example; legacy count remains at `Synchronizer/SearchCount`; API Release build passed.

## Read implementation

- [x] Add `DalSynchronizer.SearchByKey`.
  - Result: typed delegation to existing BLL; DAL Release build passed.
- [x] Add POST validation.
  - Result: validates body, enterprise, enum, conditional key, and resource `1348`; API Release build passed.
- [x] Dispatch POST operations.
  - Result: only count or lookup-by-key reaches BSF; API Release build passed.
- [x] Remove the duplicate Commerce API error-category enum and mapper.
  - Use BSF `SynchronizerConfigErrorKeys` constants directly in the adapter registry.
  - Keep category values as BSF keys in response contracts.
  - Result: removed `SynchronizerErrorCategory` and `SynchronizerErrorCategoryMapper`. Summary/detail categories and the adapter registry now use BSF keys directly; coupon registration uses `SynchronizerConfigErrorKeys`. Full Commerce API Release build passed with 0 warnings and 0 errors.
- [x] Add typed summary DTO.
  - Result: stable category, BSF key, description, and count; count endpoints return typed summaries; API Release build passed.
- [x] Add typed detail envelope.
  - Result: stable category/key and a non-null list of base detail items; model Release build passed.
- [x] Add category-adapter registry.
  - Result: only registered typed adapters can query details; unsupported categories fail explicitly; API Release build passed.
- [x] Move synchronizer adapter infrastructure into `CeltaCommerceAPI.Model`.
  - Result: summary/detail adapters, adapter interface, and registry now compile in the Model project. DAL retains only BSF retrieval, and the controller passes retrieved errors into the pure Model registry. Full Commerce API Release build passed with 0 warnings and 0 errors.
- [x] Organize synchronizer Model code by category folder.
  - Result: shared contracts and infrastructure are in `Common`; coupon and cashier-movement DTOs/models and adapters are colocated in their respective category folders with matching namespaces. Full Commerce API Release build passed with 0 warnings and 0 errors.

## Contract rules

- Reuse BSF enums whenever BSF defines the same concept.
- Use BSF `SynchronizerConfigErrorKeys` directly for aggregate error categories because BSF has no aggregate category enum.
- Do not create Commerce API or Mobile enums that duplicate an existing BSF enum.
- Preserve marked/reread/resend variants as distinct categories.
- Category-specific mapping belongs in adapters, never controller branches.
- Synchronizer adapters, their interface, and their registry belong to `CeltaCommerceAPI.Model`; DAL remains responsible only for retrieving BSF data.
- Organize `CeltaCommerceAPI.Model/Architect/Synchronizer` by category folder. Each category folder must contain that category's DTOs/models and adapter (for example, `CashierMovement/`). Put only contracts and infrastructure shared by every category in `Common/`. Namespaces must mirror these folders.
- Return an empty item list, not null.
- Never expose raw `ISynchronizerConfigError` JSON.
- Do not create a unit-test project or unit tests for the ECommerce API; use the required Release builds for validation.
