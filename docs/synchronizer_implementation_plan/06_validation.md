# Validation Plan

Read this file when adding tests, running verification, or determining completion.

## Commerce API

- Do not create a unit-test project or unit tests for the ECommerce API.
- [ ] Build the full Commerce API in Release with 0 errors.

## CeltaMobile

- [ ] Test summary/detail model conversions.
- [ ] Test datasource URL, POST method, headers, body, response, and error propagation.
- [ ] Test repository mapping and category preservation.
- [ ] Test summary controller load, reload, empty, and failure states.
- [ ] Test detail controller forwarding, load, reload, empty, and failure states.
- [ ] Add summary widget-state tests.
- [ ] Add detail widget-state and representative-category tests.
- [ ] Run narrow Flutter analysis for changed files.
- [ ] Run focused synchronizer tests.

## Manual read-only flow

- [ ] Open the synchronizer module.
- [ ] Load categories and counts.
- [ ] Open multiple supported categories.
- [ ] Confirm details match ERP UI data.
- [ ] Refresh summary and details independently.
- [ ] Confirm no operation changes database state.

## Evidence already obtained

- Commerce API Model Release builds passed after common contract changes.
- Commerce API DAL Release builds passed after facade/mapper changes.
- Full Commerce API Release builds passed after controller, DTO, registry, and coupon-adapter changes.
- Full Commerce API Release build passed after moving all synchronizer adapter infrastructure from DAL to Model.
- Full Commerce API Release build passed after organizing synchronizer Model code into `Common`, `Coupon`, and `CashierMovement` folders with matching namespaces.
- Latest recorded build result: 0 warnings and 0 errors.
