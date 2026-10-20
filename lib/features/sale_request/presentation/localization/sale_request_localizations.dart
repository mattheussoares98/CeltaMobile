import 'package:celta_inventario/localization/generated/generated.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';

extension SaleRequestLocalizations on AppLocalizations {
  String sanitizationActionMessage(BSFSaleRequestSanitizationAction action) {
    if (action.details.isNotEmpty) {
      if (action.type == BSFSaleRequestSanitizationType.paymentsCleared) {
        return removedPaymentMethods(action.details.join(', '));
      }
      if (action.type == BSFSaleRequestSanitizationType.customerBlocked) {
        return customerSalesBlockDetails(action.details.join(', '));
      }
    }
    return sanitizationMessage(action.type);
  }

  String sanitizationMessage(
    BSFSaleRequestSanitizationType value,
  ) => switch (value) {
    BSFSaleRequestSanitizationType.paymentsCleared => paymentsWillBeCleared,
    BSFSaleRequestSanitizationType.discountsReset => discountsWillBeReset,
    BSFSaleRequestSanitizationType.incrementsReset => surchargesWillBeReset,
    BSFSaleRequestSanitizationType.deliveryTaxReset => deliveryFeesWillBeReset,
    BSFSaleRequestSanitizationType.customerBlocked => customerBlockedForSales,
    BSFSaleRequestSanitizationType.productAutomaticDiscountsRemoved =>
      automaticDiscountsWillBeRemoved,
  };

  String discountBlockadeName(SaleBlockadeDiscountType value) =>
      switch (value) {
        SaleBlockadeDiscountType.none => noBlockade,
        SaleBlockadeDiscountType.blockadeByOfferPrice => offerPriceBlockade,
        SaleBlockadeDiscountType.blockadeByAutomaticDiscount =>
          automaticDiscountBlockade,
        SaleBlockadeDiscountType.blockadeBySaleNegotiation =>
          salesAgreementBlockade,
        SaleBlockadeDiscountType.blockadeByWholePrice => wholesalePriceBlockade,
      };

  String discountOriginName(DiscountOrigin value) => switch (value) {
    DiscountOrigin.manual => corePracticedPriceTypeManual,
    DiscountOrigin.saleOffer => promotionOrigin,
    DiscountOrigin.saleNegotiation => salesAgreementOrigin,
    DiscountOrigin.desoneration => taxExemptionOrigin,
    DiscountOrigin.salePaymentFinalization => paymentMethod,
    DiscountOrigin.crm => "CRM",
  };

  String percentageOrValueName(PercentageOrValue value) => switch (value) {
    PercentageOrValue.percentage => percentageType,
    PercentageOrValue.reais => reaisType,
  };
}
