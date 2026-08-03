# Schedule Error Deletion Plan

This plan covers one mutation only: deleting selected schedule-execution errors. It does not add schedule configuration or broaden mutation support to other synchronizer categories.

## Confirmed ERP and BSF behavior

- The ERP UI collects the selected `ModelSynchronizerConfigErrorSchedule` rows and requires resource `633` before deletion.
- `UserProcessSynchronizerConfigErrorSchedule.Delete` delegates to `BllSynchronizerConfigErrorSchedule.Delete`.
- BSF deletes rows from `SincronizadorEmpresasProgramacoesErros` by `CodigoInterno_SincErro`.
- The stable identifier is `ModelSynchronizerConfigErrorSchedule.Code`, a positive integer. Server, enterprise, execution date, description, and list position must not identify a row for deletion.
- BSF already provides the required mutation. Do not change BSF.

## Contract decision

Use one batched command with a non-empty, positive, deduplicated list of schedule-error codes:

```json
{ "Codes": [123, 456] }
```

Expose it as `POST /Synchronizer/DeleteScheduleErrors`. Keep the existing aggregate behavior: no enterprise parameter is required. A successful empty-body response is sufficient because the client already knows which codes completed.

## Commerce API

- [x] Add `Code` to `ScheduleSynchronizerErrorDetail` and map `schedule.Code` in `ScheduleSynchronizerErrorDetailAdapter`.
  - Why: the client must receive the exact BSF primary identifier used by the existing delete path.
  - Result: added the integer `Code` response property and mapped it directly from the BSF schedule model; Commerce API Model Release build passed with 0 warnings and 0 errors.
- [x] Add `DeleteScheduleErrorsParameters` in the Schedule model folder with `List<int> Codes`.
  - Result: added the schedule-specific request DTO with a non-null code list.
- [x] Add `DalSynchronizer.DeleteScheduleErrors(IEnumerable<int> codes)`.
  - Construct one `ModelSynchronizerConfigErrorSchedule` per code, place them in `ModelSynchronizerConfigErrorScheduleCollection`, and call the existing `BllSynchronizerConfigErrorSchedule.Delete` once.
  - Keep construction/delegation in DAL; do not place BSF model creation in the controller.
  - Result: DAL constructs the BSF schedule models and collection, then delegates once to the existing schedule BLL.
- [x] Add `SynchronizerController.DeleteScheduleErrors`.
  - Require resource `633`, matching ERP UI deletion authorization.
  - Reject a null/empty list and any code less than or equal to zero.
  - Deduplicate codes before DAL delegation.
  - Return `Ok()` only after BSF completes; preserve the controller's existing error-response convention.
  - Result: added the POST endpoint with resource `633`, required positive-code validation, deduplication, BSF delegation, and the existing controller error convention. Build verification was skipped at the user's request.
- [ ] Build `CeltaCommerceAPI.csproj` in Release.
  - Do not add Commerce API unit tests, per project rule.

## CeltaMobile domain and data

- [x] Add required `code` to `BSFScheduleSynchronizerErrorDetailEntity` and include it in `props`.
  - Result: added the required integer identifier and included it in Equatable equality.
- [x] Add required `code` to `BSFScheduleSynchronizerErrorDetailModel` constructor, `fromJson`, `toJson`, `fromEntity`, and `toEntity`.
  - Result: preserved `Code` through every JSON and entity conversion; narrow Dart analysis passed with no issues.
- [ ] Introduce a deletion capability contract for coded deletable details, in its own file, and have the schedule entity implement it.
  - Why: presentation should show deletion only for explicitly deletable payloads; `DetailType` describes payload shape, not mutation capability.
- [ ] Update schedule factories and model-conversion tests for `Code`.
- [x] Add `deleteScheduleErrors(EcRequestParams params, List<int> codes)` to datasource and repository interfaces and implementations.
  - POST to `/api/Synchronizer/DeleteScheduleErrors` with `{...params.toMap(), 'Codes': codes}`.
  - Result: added typed deletion methods across both interfaces and implementations with exact code-list forwarding.
- [x] Add focused datasource tests for the exact URL, verb, headers, body, successful completion, and propagated request failure.
  - Result: covered one batched POST and request-error propagation with exact argument verification.
- [x] Add focused repository tests for exact forwarding and propagated failure.
  - Result: covered exact datasource delegation and error propagation; both focused suites passed 17 tests in total.

## CeltaMobile command and UI

- [ ] Add a dedicated delete command controller; do not put HTTP mutation state in `SynchronizerDetailsStateController`.
  - Accept the schedule detail type, selected positive codes, and error key.
  - Return immediately for an empty selection and reject unsupported detail types explicitly.
  - Await `ecRequestParamsProvider().future`, call the repository, and expose independent loading/error state.
- [ ] After success, remove only the completed codes from the already-loaded details and clear those codes from selection.
  - Do not reload the full details list after a successful command; local removal avoids unnecessary network work and prevents a completed command from being coupled to a follow-up read failure.
  - Refresh the summary count silently so aggregate count can converge independently.
- [ ] Replace the schedule component's placeholder code `1` with `item.code`, and correct the coupon-specific selection label.
- [ ] Show delete-all/delete-selected actions only when the loaded items implement the deletion capability.
  - Confirm destructive intent before dispatch.
  - Disable repeated submission while the command is loading.
  - Keep reread and delete actions as separate capabilities and controllers.
- [ ] Add controller tests for empty input, supported dispatch, unsupported type, success cleanup, and failure preservation.
- [ ] Add schedule widget tests for code-based selection, confirmation, loading guard, success removal, and failure feedback.

## Validation and completion boundary

- [ ] Run narrow Dart analysis for changed synchronizer files; do not run `build_runner`.
- [ ] Run focused synchronizer model, datasource, repository, controller, and widget tests.
- [ ] Manually verify that selecting two schedule errors deletes exactly those BSF codes, leaves unselected rows intact, and updates the displayed count.
- [ ] Verify that a user with synchronizer read permission but without resource `633` cannot delete.
- [ ] Verify invalid, empty, and duplicate code requests do not produce unintended deletions.

Implement one unchecked item at a time and wait for explicit continuation between layers.
