import 'package:celta_inventario/features/adjust_sale_price/domain/entities/entities.dart';
import 'package:celta_inventario/localization/generated/generated.dart';

extension AdjustSalePriceLocalizations on AppLocalizations {
  String adjustmentPriceTypeName(PriceType value) => switch (value) {
    PriceType.sale => regularPrice,
    PriceType.offer => offerPrice,
  };

  String saleTypeName(SaleType value) => switch (value) {
    SaleType.retail => corePracticedPriceTypeRetail,
    SaleType.whole => corePracticedPriceTypeWhole,
    SaleType.ecommerce => corePracticedPriceTypeEcommerce,
  };

  String replicationTypeName(ReplicationTypes value) => switch (value) {
    ReplicationTypes.classess => replicateClass,
    ReplicationTypes.grid => replicateGrid,
    ReplicationTypes.operationalGrouping => replicateOperationalGroup,
    ReplicationTypes.packings => replicatePackings,
  };

  String missingCurrentPrice(PriceType? priceType, SaleType? saleType) =>
      priceType == null || saleType == null
      ? noCurrentPrice
      : noCurrentPriceForType(
          adjustmentPriceTypeName(priceType).toLowerCase(),
          saleTypeName(saleType).toLowerCase(),
        );

  String missingSuggestedPrice(PriceType? priceType, SaleType? saleType) =>
      priceType == null || saleType == null
      ? noSuggestedPrice
      : noSuggestedPriceForType(
          adjustmentPriceTypeName(priceType).toLowerCase(),
          saleTypeName(saleType).toLowerCase(),
        );
}
