# Commerce API Error Adapters

Read this file only when implementing or reviewing category-specific detail mapping.

## Adapter completion rule

For one category family at a time:

1. Inspect the BSF model and matching ERP UI detail/list components.
2. Record exact read-only fields below before coding.
3. Add a typed Commerce API detail DTO.
4. Put the category DTO/model and adapter together in the category's folder under `CeltaCommerceAPI.Model/Architect/Synchronizer`.
5. Add and register the adapter.
6. Fail explicitly on an unexpected BSF model.
7. Build Commerce API in Release.
8. Mark only that category complete and record the result.

Do not add ECommerce API unit tests. Validate each adapter through the required full Commerce API Release build.

## Field/support matrix

| Family | Detail status | Exact fields |
|---|---|---|
| Coupon, including marked | Supported | Enterprise personalized code, creation date, sale/delivery date, coupon number, ECF number, cash-register number, detail descriptions |
| Cashier movement, including marked | Supported | Enterprise personalized code, creation date, opening/closing date, cash-register personalized code, description |
| Fiscal note | Supported | Enterprise personalized code, issuance date, fiscal-note number, series |
| NFC-e disable | Supported | Enterprise personalized code, issuance date, fiscal-note number, series |
| CAT52 read | Excluded | No longer used; excluded by explicit user direction |
| Task-execution error | Supported | Server name, enterprise name, execution date, description |
| Transaction | Supported | Transaction identifier |
| Treasury movement | Supported | Enterprise personalized code, sale date, coupon number, ECF number |
| ECF map summary, including marked | Supported | Enterprise personalized code, creation date, finalization date, ECF personalized code, ECF serial number, allowed-user description, error description |
| Customer with error | Supported | Enterprise personalized code, error creation date, customer registration date, customer code, customer name, detail descriptions |
| Customer waiting approval | Supported | Customer generating-system code, customer name |
| Sale request with error, including marked | Supported | Enterprise personalized code, error creation date, order registration date, commerce-site description, invoice code, order number, commerce-site file, detail descriptions, missing-product site code/name/price |
| Sale request waiting approval | Supported | Generating-system order code, BS order code |
| Sale request marked | Supported | BS order code, customer description, net total |
| Product with error | Supported | Enterprise personalized code/name, commerce site, PLU, product name, packing, site product ID, error description/message/more-info, sending-restriction indicator, last product/price/stock charge dates |
| Bleeding read, including marked | Supported | Enterprise personalized code, creation date, bleeding movement date, cash-register number, description |
| Correspondent banking, including marked | Supported | Enterprise personalized code, creation date, sale/delivery date, correspondent-banking number, ECF number, cash-register number, detail descriptions |
| Scanntech sale load | Supported | Enterprise personalized code, creation date, billing date, cash-register number, ECF number, document number, description |
| Sale/customer/employee send-data, including resend | Supported | Enterprise personalized code, commerce-site description, record description, site code, nullable send date, error message |

## Adapter checklist

- [x] Coupon errors, including marked variant.
  - Result: typed adapter contains exact ERP UI fields, registers both categories, rejects unexpected models, and API Release build passed with 0 warnings/errors.
- [x] Cashier movement errors, including marked variant.
  - Result: typed adapter contains the exact ERP UI fields, registers both categories, rejects unexpected models, and the full Commerce API Release build passed with 0 warnings and 0 errors.
- [x] Fiscal note errors.
  - Result: typed adapter contains the exact ERP UI display fields, registers the BSF fiscal-note key, rejects unexpected models, and the full Commerce API Release build passed with 0 warnings and 0 errors.
- [x] NFC-e disable errors.
  - Result: typed adapter contains the exact ERP UI display fields, registers the BSF NFC-e-disable key, rejects unexpected models, and the full Commerce API Release build passed with 0 warnings and 0 errors.
- [x] CAT52 read errors.
  - Result: intentionally excluded because this integration is no longer used; no DTO, adapter, or registry entry was created.
- [x] Synchronizer task-execution errors.
  - Result: typed adapter contains the exact ERP UI display fields, registers the BSF schedule error key, rejects unexpected models, and the full Commerce API Release build passed with 0 warnings and 0 errors.
- [x] Transaction errors.
  - Result: typed adapter contains the transaction identifier displayed by the ERP UI, registers the BSF transaction key, rejects unexpected models, and the full Commerce API Release build passed with 0 warnings and 0 errors.
- [x] Treasury movement errors.
  - Result: typed adapter contains the exact ERP UI display fields, registers the BSF treasury-movement key, rejects unexpected models, and the full Commerce API Release build passed with 0 warnings and 0 errors.
- [x] ECF map-summary errors, including marked variant.
  - Result: typed adapter contains the exact ERP UI list/detail fields, registers both BSF map-summary keys, rejects unexpected models, and the full Commerce API Release build passed with 0 warnings and 0 errors.
- [x] Customer-with-error records.
  - Result: typed adapter contains the exact ERP UI list/detail fields, registers the BSF customer-with-error key, rejects unexpected models, and the full Commerce API Release build passed with 0 warnings and 0 errors.
- [x] Customer-waiting-approval records.
  - Result: typed adapter contains the exact ERP UI display fields, registers the BSF customer-waiting-approval key, rejects unexpected models, and the full Commerce API Release build passed with 0 warnings and 0 errors.
- [x] Sale-request-with-error records, including marked variant.
  - Result: typed adapter contains both ERP UI detail areas and the read-only commerce-site file value, registers both BSF sale-request error keys, rejects unexpected models, and the full Commerce API Release build passed with 0 warnings and 0 errors.
- [x] Sale-request-waiting-approval records.
  - Result: typed adapter contains the exact ERP UI display fields, registers the BSF sale-request-waiting-approval key, rejects unexpected models, and the full Commerce API Release build passed with 0 warnings and 0 errors.
- [x] Sale-request-marked records.
  - Result: typed adapter contains the exact ERP UI display fields, registers the BSF sale-request-marked key, rejects unexpected models, and the full Commerce API Release build passed with 0 warnings and 0 errors.
- [x] Product-with-error records.
  - Result: typed adapter reproduces the ERP UI product fields, blank-date semantics, read-only more-info value, and sending-restriction indicator; it registers the BSF product-error key, rejects unexpected models, and the full Commerce API Release build passed with 0 warnings and 0 errors.
- [x] Bleeding read errors, including marked variant.
  - Result: typed adapter contains the exact ERP UI display fields, registers both BSF bleeding-read keys, rejects unexpected models, and the full Commerce API Release build passed with 0 warnings and 0 errors.
- [x] Correspondent-banking errors, including marked variant.
  - Result: typed adapter contains the exact ERP UI list/detail fields, registers both BSF correspondent-banking keys, rejects unexpected models, and the full Commerce API Release build passed with 0 warnings and 0 errors.
- [x] Scanntech sale-load errors.
  - Result: typed adapter contains the exact ERP UI display fields, registers the BSF Scanntech sale-load key, rejects unexpected models, and the full Commerce API Release build passed with 0 warnings and 0 errors.
- [x] Sale send-data errors, including resend variant.
  - Result: shared typed send-data adapter reproduces the ERP UI fields and nullable send-date behavior, registers both BSF sale keys, rejects unexpected models, and the full Commerce API Release build passed with 0 warnings and 0 errors.
- [x] Customer send-data errors, including resend variant.
  - Result: shared typed send-data adapter registers both BSF customer keys, preserves the common ERP UI contract, and the full Commerce API Release build passed with 0 warnings and 0 errors.
- [x] Employee send-data errors, including resend variant.
  - Result: shared typed send-data adapter registers both BSF employee keys, preserves the common ERP UI contract, and the full Commerce API Release build passed with 0 warnings and 0 errors.
- [x] Verify whether manifestation or other IDAL-only categories are reachable from active `SearchCount`/`SearchByKey`.
  - Result: BSF has 30 active `GetImplements()` registrations. Commerce registers 29 adapters, covering every active category except CAT52, which was explicitly excluded. Manifestation is IDAL-only and absent from active registration and key dispatch, so no additional adapter is reachable or required.
