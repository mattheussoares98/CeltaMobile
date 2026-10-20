import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/localization/generated/generated.dart';

/// Localized labels without changing domain values or persisted identifiers.
extension CoreEnumLocalizations on AppLocalizations {
  String moduleName(Modules value) => switch (value) {
    Modules.adjustCost => coreModulesAdjustCost,
    Modules.adjustPrice => coreModulesAdjustPrice,
    Modules.adjustStock => coreModulesAdjustStock,
    Modules.buyQuotation => coreModulesBuyQuotation,
    Modules.buyRequest => coreModulesBuyRequest,
    Modules.buyMovement => coreModulesBuyMovement,
    Modules.competingPrices => coreModulesCompetingPrices,
    Modules.customerRegister => coreModulesCustomerRegister,
    Modules.expeditionConference => coreModulesExpeditionConference,
    Modules.inventory => coreModulesInventory,
    Modules.printLabel => coreModulesPrintLabel,
    Modules.processAuthorization => coreModulesProcessAuthorization,
    Modules.productsRegister => coreModulesProductsRegister,
    Modules.receipt => coreModulesReceipt,
    Modules.reports => coreModulesReports,
    Modules.saleRequest => coreModulesSaleRequest,
    Modules.searchProducts => coreModulesSearchProducts,
    Modules.synchronizer => coreModulesSynchronizer,
    Modules.stockReplacement => coreModulesStockReplacement,
    Modules.transferBetweenStocks => coreModulesTransferBetweenStocks,
    Modules.transferRequest => coreModulesTransferRequest,
  };

  String resourceName(BsResource value) => switch (value) {
    BsResource.adjustStock => coreBsResourceAdjustStock,
    BsResource.adjustSalePrice => coreBsResourceAdjustSalePrice,
    BsResource.changeSaleRequestPrices => coreBsResourceChangeSaleRequestPrices,
    BsResource.buyQuotation => coreBsResourceBuyQuotation,
    BsResource.buyRequest => coreBsResourceBuyRequest,
    BsResource.transferRequest => coreBsResourceTransferRequest,
    BsResource.saleRequest => coreBsResourceSaleRequest,
    BsResource.saleRequestChangeTPrice => coreBsResourceSaleRequestChangeTPrice,
    BsResource.priceConference => coreBsResourcePriceConference,
    BsResource.researchOfPrice => coreBsResourceResearchOfPrice,
    BsResource.synchronizer => coreBsResourceSynchronizer,
    BsResource.synchronizerDelete => coreBsResourceSynchronizerDelete,
    BsResource.goodsReceiving => coreBsResourceGoodsReceiving,
    BsResource.processAuthorizationRules =>
      coreBsResourceProcessAuthorizationRules,
  };

  String priceTypeName(PracticedPriceType value) => switch (value) {
    PracticedPriceType.manual => corePracticedPriceTypeManual,
    PracticedPriceType.retail => corePracticedPriceTypeRetail,
    PracticedPriceType.whole => corePracticedPriceTypeWhole,
    PracticedPriceType.operationalCost => corePracticedPriceTypeOperationalCost,
    PracticedPriceType.replacementCost => corePracticedPriceTypeReplacementCost,
    PracticedPriceType.replacementCostMidle =>
      corePracticedPriceTypeReplacementCostMidle,
    PracticedPriceType.liquidCost => corePracticedPriceTypeLiquidCost,
    PracticedPriceType.liquidCostMidle => corePracticedPriceTypeLiquidCostMidle,
    PracticedPriceType.definedBySystem => corePracticedPriceTypeDefinedBySystem,
    PracticedPriceType.realCost => corePracticedPriceTypeRealCost,
    PracticedPriceType.realLiquidCost => corePracticedPriceTypeRealLiquidCost,
    PracticedPriceType.fiscalCost => corePracticedPriceTypeFiscalCost,
    PracticedPriceType.fiscalLiquidCost =>
      corePracticedPriceTypeFiscalLiquidCost,
    PracticedPriceType.ecommerce => corePracticedPriceTypeEcommerce,
  };

  String operationName(OperationType value) => switch (value) {
    OperationType.exit => coreOperationTypeExit,
    OperationType.entrance => coreOperationTypeEntrance,
  };

  String searchPreferenceName(SearchProductTypePreference value) =>
      switch (value) {
        SearchProductTypePreference.dynamic =>
          coreSearchProductTypePreferenceDynamic,
        SearchProductTypePreference.personalizedCode =>
          coreSearchProductTypePreferencePersonalizedCode,
        SearchProductTypePreference.legacyCode =>
          coreSearchProductTypePreferenceLegacyCode,
        SearchProductTypePreference.ean => coreSearchProductTypePreferenceEan,
      };

  String usageName(UsageType value) => switch (value) {
    UsageType.adjustCost => coreUsageTypeAdjustCost,
    UsageType.adjustSalePrice => coreUsageTypeAdjustSalePrice,
    UsageType.adjustStock => coreUsageTypeAdjustStock,
    UsageType.buyMovementDetails => coreUsageTypeBuyMovementDetails,
    UsageType.completeSearchSaleRequest =>
      coreUsageTypeCompleteSearchSaleRequest,
    UsageType.countInventoryProduct => coreUsageTypeCountInventoryProduct,
    UsageType.countReceiptProduct => coreUsageTypeCountReceiptProduct,
    UsageType.downloadReport => coreUsageTypeDownloadReport,
    UsageType.finishedExpedition => coreUsageTypeFinishedExpedition,
    UsageType.generateReport => coreUsageTypeGenerateReport,
    UsageType.insertBuyRequest => coreUsageTypeInsertBuyRequest,
    UsageType.insertNotFoundReceiptProduct =>
      coreUsageTypeInsertNotFoundReceiptProduct,
    UsageType.insertSaleRequest => coreUsageTypeInsertSaleRequest,
    UsageType.insertTransferRequest => coreUsageTypeInsertTransferRequest,
    UsageType.insertUpdateBuyQuotation => coreUsageTypeInsertUpdateBuyQuotation,
    UsageType.insertUpdateCustomer => coreUsageTypeInsertUpdateCustomer,
    UsageType.insertUpdateCompetingPrices =>
      coreUsageTypeInsertUpdateCompetingPrices,
    UsageType.liberateReceiptDocument => coreUsageTypeLiberateReceiptDocument,
    UsageType.notDefined => coreUsageTypeNotDefined,
    UsageType.updateSaleRequest => coreUsageTypeUpdateSaleRequest,
    UsageType.printLabelCreateUpdate => coreUsageTypePrintLabelCreateUpdate,
    UsageType.processAuthorizationVote => coreUsageTypeProcessAuthorizationVote,
    UsageType.searchProducts => coreUsageTypeSearchProducts,
    UsageType.sendToPrint => coreUsageTypeSendToPrint,
    UsageType.shallowBuyMovement => coreUsageTypeShallowBuyMovement,
    UsageType.shallowSearchProduct => coreUsageTypeShallowSearchProduct,
    UsageType.shallowSearchSaleRequest => coreUsageTypeShallowSearchSaleRequest,
    UsageType.stockReplacement => coreUsageTypeStockReplacement,
    UsageType.synchronizer => coreUsageTypeSynchronizer,
    UsageType.transferBetweenStocks => coreUsageTypeTransferBetweenStocks,
  };

  String personTypeName(CustomerPersonType value) => switch (value) {
    CustomerPersonType.fisica => coreCustomerPersonTypeFisica,
    CustomerPersonType.juridica => coreCustomerPersonTypeJuridica,
  };

  String competingPriceFilterName(SearchProductCompetingPriceType value) =>
      switch (value) {
        SearchProductCompetingPriceType.all =>
          coreSearchProductCompetingPriceTypeAll,
        SearchProductCompetingPriceType.informedPrices =>
          coreSearchProductCompetingPriceTypeInformedPrices,
        SearchProductCompetingPriceType.notInformedPrices =>
          coreSearchProductCompetingPriceTypeNotInformedPrices,
      };

  String sexName(CustomerSexType value) => switch (value) {
    CustomerSexType.male => coreCustomerSexTypeMale,
    CustomerSexType.female => coreCustomerSexTypeFemale,
  };

  String transferJustificationName(TransferJustificationType value) =>
      switch (value) {
        TransferJustificationType.adjustStock =>
          coreTransferJustificationTypeAdjustStock,
        TransferJustificationType.transferBetweenStocks =>
          coreTransferJustificationTypeTransferBetweenStocks,
      };
}
