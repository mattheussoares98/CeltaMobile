import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';

class PriceCostModel extends Equatable {
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
  const PriceCostModel({
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

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'RetailPracticedPrice': RetailPracticedPrice,
      'RetailSalePrice': RetailSalePrice,
      'RetailOfferPrice': RetailOfferPrice,
      'RetailSuggestionPrice': RetailSuggestionPrice,
      'RetailMinimumPrice': RetailMinimumPrice,
      'WholePracticedPrice': WholePracticedPrice,
      'WholeSalePrice': WholeSalePrice,
      'WholeOfferPrice': WholeOfferPrice,
      'WholeSuggestionPrice': WholeSuggestionPrice,
      'WholeMinimumPrice': WholeMinimumPrice,
      'ECommercePracticedPrice': ECommercePracticedPrice,
      'ECommerceSalePrice': ECommerceSalePrice,
      'ECommerceOfferPrice': ECommerceOfferPrice,
      'ECommerceSuggestionPrice': ECommerceSuggestionPrice,
      'ECommerceMinimumPrice': ECommerceMinimumPrice,
      'MinimumWholeQuantity': MinimumWholeQuantity,
      'OperationalCost': OperationalCost,
      'ReplacementCost': ReplacementCost,
      'ReplacementCostMidle': ReplacementCostMidle,
      'LiquidCost': LiquidCost,
      'LiquidCostMidle': LiquidCostMidle,
      'RealCost': RealCost,
      'RealLiquidCost': RealLiquidCost,
      'FiscalCost': FiscalCost,
      'FiscalLiquidCost': FiscalLiquidCost,
      'RetailMargin': RetailMargin,
      'RetailOfferMargin': RetailOfferMargin,
      'RetailMinimumMargin': RetailMinimumMargin,
      'WholeMargin': WholeMargin,
      'WholeOfferMargin': WholeOfferMargin,
      'WholeMinimumMargin': WholeMinimumMargin,
      'ECommerceMargin': ECommerceMargin,
      'ECommerceOfferMargin': ECommerceOfferMargin,
      'ECommerceMinimumMargin': ECommerceMinimumMargin,
    };
  }

  factory PriceCostModel.fromJson(Map json) {
    return PriceCostModel(
      RetailPracticedPrice: json['RetailPracticedPrice'] as double?,
      RetailSalePrice: json['RetailSalePrice'] as double?,
      RetailOfferPrice: json['RetailOfferPrice'] as double?,
      RetailSuggestionPrice: json['RetailSuggestionPrice'] as double?,
      RetailMinimumPrice: json['RetailMinimumPrice'] as double?,
      WholePracticedPrice: json['WholePracticedPrice'] as double?,
      WholeSalePrice: json['WholeSalePrice'] as double?,
      WholeOfferPrice: json['WholeOfferPrice'] as double?,
      WholeSuggestionPrice: json['WholeSuggestionPrice'] as double?,
      WholeMinimumPrice: json['WholeMinimumPrice'] as double?,
      ECommercePracticedPrice: json['ECommercePracticedPrice'] as double?,
      ECommerceSalePrice: json['ECommerceSalePrice'] as double?,
      ECommerceOfferPrice: json['ECommerceOfferPrice'] as double?,
      ECommerceSuggestionPrice: json['ECommerceSuggestionPrice'] as double?,
      ECommerceMinimumPrice: json['ECommerceMinimumPrice'] as double?,
      MinimumWholeQuantity: json['MinimumWholeQuantity'] as double?,
      OperationalCost: json['OperationalCost'] as double?,
      ReplacementCost: json['ReplacementCost'] as double?,
      ReplacementCostMidle: json['ReplacementCostMidle'] as double?,
      LiquidCost: json['LiquidCost'] as double?,
      LiquidCostMidle: json['LiquidCostMidle'] as double?,
      RealCost: json['RealCost'] as double?,
      RealLiquidCost: json['RealLiquidCost'] as double?,
      FiscalCost: json['FiscalCost'] as double?,
      FiscalLiquidCost: json['FiscalLiquidCost'] as double?,
      RetailMargin: json['RetailMargin'] as double?,
      RetailOfferMargin: json['RetailOfferMargin'] as double?,
      RetailMinimumMargin: json['RetailMinimumMargin'] as double?,
      WholeMargin: json['WholeMargin'] as double?,
      WholeOfferMargin: json['WholeOfferMargin'] as double?,
      WholeMinimumMargin: json['WholeMinimumMargin'] as double?,
      ECommerceMargin: json['ECommerceMargin'] as double?,
      ECommerceOfferMargin: json['ECommerceOfferMargin'] as double?,
      ECommerceMinimumMargin: json['ECommerceMinimumMargin'] as double?,
    );
  }

  factory PriceCostModel.fromEntity(PriceCostEntity entity) {
    return PriceCostModel(
      RetailPracticedPrice: entity.RetailPracticedPrice,
      RetailSalePrice: entity.RetailSalePrice,
      RetailOfferPrice: entity.RetailOfferPrice,
      RetailSuggestionPrice: entity.RetailSuggestionPrice,
      RetailMinimumPrice: entity.RetailMinimumPrice,
      WholePracticedPrice: entity.WholePracticedPrice,
      WholeSalePrice: entity.WholeSalePrice,
      WholeOfferPrice: entity.WholeOfferPrice,
      WholeSuggestionPrice: entity.WholeSuggestionPrice,
      WholeMinimumPrice: entity.WholeMinimumPrice,
      ECommercePracticedPrice: entity.ECommercePracticedPrice,
      ECommerceSalePrice: entity.ECommerceSalePrice,
      ECommerceOfferPrice: entity.ECommerceOfferPrice,
      ECommerceSuggestionPrice: entity.ECommerceSuggestionPrice,
      ECommerceMinimumPrice: entity.ECommerceMinimumPrice,
      MinimumWholeQuantity: entity.MinimumWholeQuantity,
      OperationalCost: entity.OperationalCost,
      ReplacementCost: entity.ReplacementCost,
      ReplacementCostMidle: entity.ReplacementCostMidle,
      LiquidCost: entity.LiquidCost,
      LiquidCostMidle: entity.LiquidCostMidle,
      RealCost: entity.RealCost,
      RealLiquidCost: entity.RealLiquidCost,
      FiscalCost: entity.FiscalCost,
      FiscalLiquidCost: entity.FiscalLiquidCost,
      RetailMargin: entity.RetailMargin,
      RetailOfferMargin: entity.RetailOfferMargin,
      RetailMinimumMargin: entity.RetailMinimumMargin,
      WholeMargin: entity.WholeMargin,
      WholeOfferMargin: entity.WholeOfferMargin,
      WholeMinimumMargin: entity.WholeMinimumMargin,
      ECommerceMargin: entity.ECommerceMargin,
      ECommerceOfferMargin: entity.ECommerceOfferMargin,
      ECommerceMinimumMargin: entity.ECommerceMinimumMargin,
    );
  }

  PriceCostEntity toEntity() {
    return PriceCostEntity(
      RetailPracticedPrice: RetailPracticedPrice,
      RetailSalePrice: RetailSalePrice,
      RetailOfferPrice: RetailOfferPrice,
      RetailSuggestionPrice: RetailSuggestionPrice,
      RetailMinimumPrice: RetailMinimumPrice,
      WholePracticedPrice: WholePracticedPrice,
      WholeSalePrice: WholeSalePrice,
      WholeOfferPrice: WholeOfferPrice,
      WholeSuggestionPrice: WholeSuggestionPrice,
      WholeMinimumPrice: WholeMinimumPrice,
      ECommercePracticedPrice: ECommercePracticedPrice,
      ECommerceSalePrice: ECommerceSalePrice,
      ECommerceOfferPrice: ECommerceOfferPrice,
      ECommerceSuggestionPrice: ECommerceSuggestionPrice,
      ECommerceMinimumPrice: ECommerceMinimumPrice,
      MinimumWholeQuantity: MinimumWholeQuantity,
      OperationalCost: OperationalCost,
      ReplacementCost: ReplacementCost,
      ReplacementCostMidle: ReplacementCostMidle,
      LiquidCost: LiquidCost,
      LiquidCostMidle: LiquidCostMidle,
      RealCost: RealCost,
      RealLiquidCost: RealLiquidCost,
      FiscalCost: FiscalCost,
      FiscalLiquidCost: FiscalLiquidCost,
      RetailMargin: RetailMargin,
      RetailOfferMargin: RetailOfferMargin,
      RetailMinimumMargin: RetailMinimumMargin,
      WholeMargin: WholeMargin,
      WholeOfferMargin: WholeOfferMargin,
      WholeMinimumMargin: WholeMinimumMargin,
      ECommerceMargin: ECommerceMargin,
      ECommerceOfferMargin: ECommerceOfferMargin,
      ECommerceMinimumMargin: ECommerceMinimumMargin,
    );
  }
}
