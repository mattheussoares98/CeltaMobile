import 'package:equatable/equatable.dart';

class PriceCostEntity extends Equatable {
  final double RetailPracticedPrice;
  final double RetailSalePrice;
  final double RetailOfferPrice;
  final double RetailSuggestionPrice;
  final double RetailMinimumPrice;
  final double WholePracticedPrice;
  final double WholeSalePrice;
  final double WholeOfferPrice;
  final double WholeSuggestionPrice;
  final double WholeMinimumPrice;
  final double ECommercePracticedPrice;
  final double ECommerceSalePrice;
  final double ECommerceOfferPrice;
  final double ECommerceSuggestionPrice;
  final double ECommerceMinimumPrice;
  final double MinimumWholeQuantity;
  final double OperationalCost;
  final double ReplacementCost;
  final double ReplacementCostMidle;
  final double LiquidCost;
  final double LiquidCostMidle;
  final double RealCost;
  final double RealLiquidCost;
  final double FiscalCost;
  final double FiscalLiquidCost;
  final double RetailMargin;
  final double RetailOfferMargin;
  final double RetailMinimumMargin;
  final double WholeMargin;
  final double WholeOfferMargin;
  final double WholeMinimumMargin;
  final double ECommerceMargin;
  final double ECommerceOfferMargin;
  final double ECommerceMinimumMargin;
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
  ];
}
