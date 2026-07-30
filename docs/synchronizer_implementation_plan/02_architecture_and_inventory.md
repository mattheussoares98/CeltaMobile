# Architecture and Error Inventory

Read this file when working with BSF categories, models, ERP UI fields, or the end-to-end call path.

## Confirmed call chain

`CeltaMobile -> Commerce API controller -> Commerce API DalSynchronizer -> BllSynchronizerConfigErrors -> existing BSF DAL error implementations -> database`

Existing BSF read methods:

- `BllSynchronizerConfigErrors.SearchCount()`
- `BllSynchronizerConfigErrors.SearchByKey(string key)`

BSF does not define an aggregate enum for the 30 error categories. Its aggregate category contract is `SynchronizerConfigErrorKeys`, a struct of string constants. Category-specific enums such as `SynchronizerConfigErrorSendDataType` represent fields inside particular error families and are not replacements for the aggregate key.

The Commerce API must use its `DalSynchronizer` facade. It must not copy SQL, call BSF SQL DAL classes directly, or reproduce BSF business logic.

ERP UI reference behavior:

- `UserProcessSynchronizerConfigErrors.SearchCount()` loads summaries.
- `TreeViewSynchronizerMonitorErrorsSummary` displays category and count.
- `UserProcessSynchronizerConfigErrors.SearchByKey(key)` loads details lazily.
- Category-specific components display different detail shapes.

## Investigation checklist

- [x] Confirm the BSF BLL-first read path.
  - Result: existing BLL methods cover counts and lookup by key; BSF changes are unnecessary.
- [x] Confirm the ERP UI summary-first behavior.
  - Result: counts load first; details load only for the selected BSF key.
- [x] Confirm the initial CeltaMobile state.
  - Result: placeholder page and `dynamic` count-only flow.
- [x] Inventory every active aggregate registration.
  - Result: all 30 `GetImplements()` registrations are below.
- [x] Define version-one support.
  - Result: all categories require typed summaries. Detail support is added one adapter at a time; unsupported detail categories fail explicitly.

## Active categories

| # | BSF key | BSF implementation/variant | BSF detail model | ERP UI behavior |
|---:|---|---|---|---|
| 1 | `Coupon` | `Coupon(false)` | `ModelSynchronizerConfigErrorCoupon` | `ShowErrorDetailCoupon(false)` |
| 2 | `CouponMarkedToReadAgain` | `Coupon(true)` | same | `ShowErrorDetailCoupon(true)` |
| 3 | `CashierMovement` | `CashierMovement(false)` | `ModelSynchronizerConfigErrorCashierMovement` | `ShowErrorDetailCashierMovement(false)` |
| 4 | `CashierMovementMarkedToReadAgain` | `CashierMovement(true)` | same | `ShowErrorDetailCashierMovement(true)` |
| 5 | `FiscalNote` | `FiscalNote()` | `ModelSynchronizerConfigErrorFiscalNote` | `ShowErrorDetailFiscalNote` |
| 6 | `NFeDisable` | `NFeDisable()` | `ModelSynchronizerConfigErrorNFeDisable` | `ShowErrorDetailNFeDisable` |
| 7 | `ReadFiscalInfoCAT52` | `ReadFiscalInfoCAT52()` | `ModelSynchronizerConfigErrorReadFiscalInfoCAT52` | `ShowErrorDetailReadFiscalInfoCAT52` |
| 8 | `Schedule` | `Schedule()` | `ModelSynchronizerConfigErrorSchedule` | `ShowErrorDetailSchedule` |
| 9 | `Transaction` | `Transaction()` | `ModelSynchronizerConfigErrorTransaction` | `ShowErrorDetailTransaction` |
| 10 | `TreasuryMovement` | `TreasuryMovement()` | `ModelSynchronizerConfigErrorTreasuryMovement` | `ShowErrorDetailTreasuryMovement` |
| 11 | `MapSummarySaleEcf` | `MapSummarySaleEcf(false)` | `ModelSynchronizerConfigErrorMapSummarySaleEcf` | `ShowErrorDetailMapSummarySaleEcf(false)` |
| 12 | `MapSummarySaleEcfMarkedToReadAgain` | `MapSummarySaleEcf(true)` | same | `ShowErrorDetailMapSummarySaleEcf(true)` |
| 13 | `CustomerWithError` | `CustomerWithError()` | `ModelSynchronizerConfigErrorCustomerWithError` | `ShowErrorDetailCustomerWithError` |
| 14 | `CustomerWaitingApproval` | `CustomerWaitingApproval()` | `ModelSynchronizerConfigErrorCustomerWaitingApproval` | `ShowErrorDetailCustomerWaitingApproval` |
| 15 | `SaleRequestWithError` | `SaleRequestWithError(false)` | `ModelSynchronizerConfigErrorSaleRequestWithError` | `ShowErrorDetailSaleRequestWithError(false)` |
| 16 | `SaleRequestWithErrorMarkedToReadAgain` | `SaleRequestWithError(true)` | same | `ShowErrorDetailSaleRequestWithError(true)` |
| 17 | `SaleRequestWaitingApproval` | `SaleRequestWaitingApproval()` | `ModelSynchronizerConfigErrorSaleRequestWaitingApproval` | `ShowErrorDetailSaleRequestWaitingApproval` |
| 18 | `SaleRequestMarked` | `SaleRequestMarked()` | `ModelSynchronizerConfigErrorSaleRequestMarked` | `ShowErrorDetailSaleRequestMarked` |
| 19 | `LoadProductsWithErrors` | `ProductWithError()` | `ModelSynchronizerConfigErrorProductWithError` | `ShowErrorDetailProductWithError` |
| 20 | `ReadBleeding` | `ReadBleeding(false)` | `ModelSynchronizerConfigErrorReadBleeding` | `ShowErrorDetailReadBleeding(false)` |
| 21 | `ReadBleedingMarkedToReadAgain` | `ReadBleeding(true)` | same | `ShowErrorDetailReadBleeding(true)` |
| 22 | `CorrespondentBanking` | `CorrespondentBanking(false)` | `ModelSynchronizerConfigErrorCorrespondentBanking` | `ShowErrorDetailCorrespondentBanking(false)` |
| 23 | `CorrespondentBankingMarkedToReadAgain` | `CorrespondentBanking(true)` | same | `ShowErrorDetailCorrespondentBanking(true)` |
| 24 | `SaleMovementScanntechLoadError` | `SaleMovementScanntechLoadError()` | `ModelSynchronizerConfigErrorSaleMovementScanntechLoadError` | matching UI detail |
| 25 | `SendSales` | `SendData(Sale, false)` | `ModelSynchronizerConfigErrorSendDataWithError` | shared send-data UI |
| 26 | `SendSalesMarkedToSendAgain` | `SendData(Sale, true)` | same | shared send-data UI |
| 27 | `SendCustomers` | `SendData(Customer, false)` | same | shared send-data UI |
| 28 | `SendCustomersMarkedToSendAgain` | `SendData(Customer, true)` | same | shared send-data UI |
| 29 | `SendEmployees` | `SendData(Employee, false)` | same | shared send-data UI |
| 30 | `SendEmployeesMarkedToSendAgain` | `SendData(Employee, true)` | same | shared send-data UI |

`Schedule` is the task-execution error category and remains readable. Editing schedules remains excluded.
