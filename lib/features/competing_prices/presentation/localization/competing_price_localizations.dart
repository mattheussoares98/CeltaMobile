import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/localization/generated/generated.dart';

extension CompetingPriceLocalizations on AppLocalizations {
  String competingProductsQuery({
    required bool onlyAssociated,
    required SearchProductCompetingPriceType searchType,
  }) {
    if (!onlyAssociated) return loadAllUnassociatedProducts;
    return switch (searchType) {
      SearchProductCompetingPriceType.all => loadAllAssociatedProducts,
      SearchProductCompetingPriceType.informedPrices =>
        loadAssociatedPricedProducts,
      SearchProductCompetingPriceType.notInformedPrices =>
        loadAssociatedUnpricedProducts,
    };
  }
}
