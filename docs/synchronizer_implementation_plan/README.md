# Synchronizer Error Monitor Plan

This is the mandatory entry point for the implementation plan. Read this file first, then open only the file routed by the current step.

## Goal

Reproduce in CeltaMobile the read-only synchronization-error behavior from the ERP UI's **Monitor de sincronismo**, using the existing BSF implementation through the Commerce API.

## Reading guide

| File | Read when |
|---|---|
| [01_scope_and_rules.md](01_scope_and_rules.md) | Always, before changing implementation or plan files |
| [02_architecture_and_inventory.md](02_architecture_and_inventory.md) | When resolving BSF categories, UI behavior, models, or call paths |
| [03_commerce_api.md](03_commerce_api.md) | When changing Commerce API requests, controllers, DTOs, authorization, or common adapters |
| [04_error_adapters.md](04_error_adapters.md) | When implementing or reviewing a category-specific read adapter |
| [05_celtamobile.md](05_celtamobile.md) | When changing Mobile domain, data, controllers, navigation, or UI |
| [06_validation.md](06_validation.md) | When adding tests, running builds/analyzers, or deciding whether work is complete |

Do not read every file by default. Read `01_scope_and_rules.md`, then the one or two files relevant to the current unchecked step.

## Current progress

- Architecture inventory: completed.
- Commerce API common request/read foundation: completed.
- All reachable category adapters are completed; CAT52 was explicitly excluded and manifestation is not actively registered.
- Commerce API unit tests: excluded by project rule.
- CeltaMobile domain entities: completed.
- CeltaMobile domain entities and models: completed.
- CeltaMobile data flow, controllers, and UI: pending.
- Final validation: pending.

## Next step

Open [05_celtamobile.md](05_celtamobile.md) and implement **Update shared test factories** only.

## Plan status rule

Each checklist lives in its routed file. After validating one step:

1. Mark it `[x]` in that file.
2. Add a short `Result:` below it.
3. Update **Current progress** and **Next step** here if the active phase or next task changed.
