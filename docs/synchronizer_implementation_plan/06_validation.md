# Validation Plan

Read this file when adding tests, running verification, or determining completion.

## Commerce API

- Do not create a unit-test project or unit tests for the ECommerce API.
- [ ] Build the full Commerce API in Release with 0 errors.

## CeltaMobile

- [ ] Test summary/detail model conversions.
- [x] Test datasource URL, POST method, headers, body, response, and error propagation.
  - Result: four focused datasource tests passed for typed count/detail success and request-error propagation without enterprise context.
- [x] Test repository mapping and category preservation.
  - Result: focused repository tests cover summary/detail mapping, key preservation, exact forwarding, and error propagation.
- [ ] Test summary controller load, reload, empty, and failure states.
- [ ] Test detail controller forwarding, load, reload, empty, and failure states.
- [ ] Add summary widget-state tests.
- [ ] Add detail widget-state and representative-category tests.
- [x] Run narrow Flutter analysis for changed files.
  - Result: datasource, provider, test, and shared factory analysis passed with no issues.
- [x] Run focused synchronizer tests.
  - Result: focused datasource suite passed 4 tests.

## Manual read-only flow

- [ ] Open the synchronizer module.
- [ ] Load categories and counts.
- [ ] Open multiple supported categories.
- [ ] Confirm details match ERP UI data.
- [ ] Refresh summary and details independently.
- [ ] Confirm no operation changes database state.

## Evidence already obtained

- Full Commerce API Release build passed after removing unnecessary enterprise context from synchronizer requests: 0 warnings and 0 errors.
- Commerce API Model Release builds passed after common contract changes.
- Commerce API DAL Release builds passed after facade/mapper changes.
- Full Commerce API Release builds passed after controller, DTO, registry, and coupon-adapter changes.
- Full Commerce API Release build passed after moving all synchronizer adapter infrastructure from DAL to Model.
- Full Commerce API Release build passed after organizing synchronizer Model code into `Common`, `Coupon`, and `CashierMovement` folders with matching namespaces.
- Latest recorded build result: 0 warnings and 0 errors.
