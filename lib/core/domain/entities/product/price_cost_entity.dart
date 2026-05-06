import 'package:equatable/equatable.dart';

class PriceCostEntity extends Equatable {
  final double? RetailPracticedPrice;
  final double? RetailSalePrice;
  final double? RetailOfferPrice;
  final double? RetailSuggestionPrice;
  final double? RetailMinimumPrice;
  final double? WholePracticedPrice;
  final double? WholeSalePrice;
  final double? WholeOfferPrice;
  final double? WholeSuggestionPrice;
  final double? WholeMinimumPrice;
  final double? ECommercePracticedPrice;
  final double? ECommerceSalePrice;
  final double? ECommerceOfferPrice;
  final double? ECommerceSuggestionPrice;
  final double? ECommerceMinimumPrice;
  final double? MinimumWholeQuantity;
  final double? OperationalCost;
  final double? ReplacementCost;
  final double? ReplacementCostMidle;
  final double? LiquidCost;
  final double? LiquidCostMidle;
  final double? RealCost;
  final double? RealLiquidCost;
  final double? FiscalCost;
  final double? FiscalLiquidCost;
  final double? RetailMargin;
  final double? RetailOfferMargin;
  final double? RetailMinimumMargin;
  final double? WholeMargin;
  final double? WholeOfferMargin;
  final double? WholeMinimumMargin;
  final double? ECommerceMargin;
  final double? ECommerceOfferMargin;
  final double? ECommerceMinimumMargin;
  const PriceCostEntity({
    required this.RetailPracticedPrice,
    required this.RetailSalePrice,
    required this.RetailOfferPrice,
    required this.RetailSuggestionPrice,
    required this.RetailMinimumPrice,
    required this.WholePracticedPrice,
    required this.WholeSalePrice,
    required this.WholeOfferPrice,
    required this.WholeSuggestionPrice,
    required this.WholeMinimumPrice,
    required this.ECommercePracticedPrice,
    required this.ECommerceSalePrice,
    required this.ECommerceOfferPrice,
    required this.ECommerceSuggestionPrice,
    required this.ECommerceMinimumPrice,
    required this.MinimumWholeQuantity,
    required this.OperationalCost,
    required this.ReplacementCost,
    required this.ReplacementCostMidle,
    required this.LiquidCost,
    required this.LiquidCostMidle,
    required this.RealCost,
    required this.RealLiquidCost,
    required this.FiscalCost,
    required this.FiscalLiquidCost,
    required this.RetailMargin,
    required this.RetailOfferMargin,
    required this.RetailMinimumMargin,
    required this.WholeMargin,
    required this.WholeOfferMargin,
    required this.WholeMinimumMargin,
    required this.ECommerceMargin,
    required this.ECommerceOfferMargin,
    required this.ECommerceMinimumMargin,
  });

  @override
  List<Object?> get props => [
    RetailPracticedPrice,
    RetailSalePrice,
    RetailOfferPrice,
    RetailSuggestionPrice,
    RetailMinimumPrice,
    WholePracticedPrice,
    WholeSalePrice,
    WholeOfferPrice,
    WholeSuggestionPrice,
    WholeMinimumPrice,
    ECommercePracticedPrice,
    ECommerceSalePrice,
    ECommerceOfferPrice,
    ECommerceSuggestionPrice,
    ECommerceMinimumPrice,
    MinimumWholeQuantity,
    OperationalCost,
    ReplacementCost,
    ReplacementCostMidle,
    LiquidCost,
    LiquidCostMidle,
    RealCost,
    RealLiquidCost,
    FiscalCost,
    FiscalLiquidCost,
    RetailMargin,
    RetailOfferMargin,
    RetailMinimumMargin,
    WholeMargin,
    WholeOfferMargin,
    WholeMinimumMargin,
    ECommerceMargin,
    ECommerceOfferMargin,
    ECommerceMinimumMargin,
  ];

  PriceCostEntity copyWith({
    double? RetailPracticedPrice,
    double? RetailSalePrice,
    double? RetailOfferPrice,
    double? RetailSuggestionPrice,
    double? RetailMinimumPrice,
    double? WholePracticedPrice,
    double? WholeSalePrice,
    double? WholeOfferPrice,
    double? WholeSuggestionPrice,
    double? WholeMinimumPrice,
    double? ECommercePracticedPrice,
    double? ECommerceSalePrice,
    double? ECommerceOfferPrice,
    double? ECommerceSuggestionPrice,
    double? ECommerceMinimumPrice,
    double? MinimumWholeQuantity,
    double? OperationalCost,
    double? ReplacementCost,
    double? ReplacementCostMidle,
    double? LiquidCost,
    double? LiquidCostMidle,
    double? RealCost,
    double? RealLiquidCost,
    double? FiscalCost,
    double? FiscalLiquidCost,
    double? RetailMargin,
    double? RetailOfferMargin,
    double? RetailMinimumMargin,
    double? WholeMargin,
    double? WholeOfferMargin,
    double? WholeMinimumMargin,
    double? ECommerceMargin,
    double? ECommerceOfferMargin,
    double? ECommerceMinimumMargin,
  }) {
    return PriceCostEntity(
      RetailPracticedPrice: RetailPracticedPrice ?? this.RetailPracticedPrice,
      RetailSalePrice: RetailSalePrice ?? this.RetailSalePrice,
      RetailOfferPrice: RetailOfferPrice ?? this.RetailOfferPrice,
      RetailSuggestionPrice:
          RetailSuggestionPrice ?? this.RetailSuggestionPrice,
      RetailMinimumPrice: RetailMinimumPrice ?? this.RetailMinimumPrice,
      WholePracticedPrice: WholePracticedPrice ?? this.WholePracticedPrice,
      WholeSalePrice: WholeSalePrice ?? this.WholeSalePrice,
      WholeOfferPrice: WholeOfferPrice ?? this.WholeOfferPrice,
      WholeSuggestionPrice: WholeSuggestionPrice ?? this.WholeSuggestionPrice,
      WholeMinimumPrice: WholeMinimumPrice ?? this.WholeMinimumPrice,
      ECommercePracticedPrice:
          ECommercePracticedPrice ?? this.ECommercePracticedPrice,
      ECommerceSalePrice: ECommerceSalePrice ?? this.ECommerceSalePrice,
      ECommerceOfferPrice: ECommerceOfferPrice ?? this.ECommerceOfferPrice,
      ECommerceSuggestionPrice:
          ECommerceSuggestionPrice ?? this.ECommerceSuggestionPrice,
      ECommerceMinimumPrice:
          ECommerceMinimumPrice ?? this.ECommerceMinimumPrice,
      MinimumWholeQuantity: MinimumWholeQuantity ?? this.MinimumWholeQuantity,
      OperationalCost: OperationalCost ?? this.OperationalCost,
      ReplacementCost: ReplacementCost ?? this.ReplacementCost,
      ReplacementCostMidle: ReplacementCostMidle ?? this.ReplacementCostMidle,
      LiquidCost: LiquidCost ?? this.LiquidCost,
      LiquidCostMidle: LiquidCostMidle ?? this.LiquidCostMidle,
      RealCost: RealCost ?? this.RealCost,
      RealLiquidCost: RealLiquidCost ?? this.RealLiquidCost,
      FiscalCost: FiscalCost ?? this.FiscalCost,
      FiscalLiquidCost: FiscalLiquidCost ?? this.FiscalLiquidCost,
      RetailMargin: RetailMargin ?? this.RetailMargin,
      RetailOfferMargin: RetailOfferMargin ?? this.RetailOfferMargin,
      RetailMinimumMargin: RetailMinimumMargin ?? this.RetailMinimumMargin,
      WholeMargin: WholeMargin ?? this.WholeMargin,
      WholeOfferMargin: WholeOfferMargin ?? this.WholeOfferMargin,
      WholeMinimumMargin: WholeMinimumMargin ?? this.WholeMinimumMargin,
      ECommerceMargin: ECommerceMargin ?? this.ECommerceMargin,
      ECommerceOfferMargin: ECommerceOfferMargin ?? this.ECommerceOfferMargin,
      ECommerceMinimumMargin:
          ECommerceMinimumMargin ?? this.ECommerceMinimumMargin,
    );
  }
}
