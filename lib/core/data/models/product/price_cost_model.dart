import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';

class PriceCostModel extends Equatable {
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
  List<Object> get props {
    return [
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
  }

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

  factory PriceCostModel.fromJson(Map<String, dynamic> map) {
    return PriceCostModel(
      RetailPracticedPrice: map['RetailPracticedPrice'] as double,
      RetailSalePrice: map['RetailSalePrice'] as double,
      RetailOfferPrice: map['RetailOfferPrice'] as double,
      RetailSuggestionPrice: map['RetailSuggestionPrice'] as double,
      RetailMinimumPrice: map['RetailMinimumPrice'] as double,
      WholePracticedPrice: map['WholePracticedPrice'] as double,
      WholeSalePrice: map['WholeSalePrice'] as double,
      WholeOfferPrice: map['WholeOfferPrice'] as double,
      WholeSuggestionPrice: map['WholeSuggestionPrice'] as double,
      WholeMinimumPrice: map['WholeMinimumPrice'] as double,
      ECommercePracticedPrice: map['ECommercePracticedPrice'] as double,
      ECommerceSalePrice: map['ECommerceSalePrice'] as double,
      ECommerceOfferPrice: map['ECommerceOfferPrice'] as double,
      ECommerceSuggestionPrice: map['ECommerceSuggestionPrice'] as double,
      ECommerceMinimumPrice: map['ECommerceMinimumPrice'] as double,
      MinimumWholeQuantity: map['MinimumWholeQuantity'] as double,
      OperationalCost: map['OperationalCost'] as double,
      ReplacementCost: map['ReplacementCost'] as double,
      ReplacementCostMidle: map['ReplacementCostMidle'] as double,
      LiquidCost: map['LiquidCost'] as double,
      LiquidCostMidle: map['LiquidCostMidle'] as double,
      RealCost: map['RealCost'] as double,
      RealLiquidCost: map['RealLiquidCost'] as double,
      FiscalCost: map['FiscalCost'] as double,
      FiscalLiquidCost: map['FiscalLiquidCost'] as double,
      RetailMargin: map['RetailMargin'] as double,
      RetailOfferMargin: map['RetailOfferMargin'] as double,
      RetailMinimumMargin: map['RetailMinimumMargin'] as double,
      WholeMargin: map['WholeMargin'] as double,
      WholeOfferMargin: map['WholeOfferMargin'] as double,
      WholeMinimumMargin: map['WholeMinimumMargin'] as double,
      ECommerceMargin: map['ECommerceMargin'] as double,
      ECommerceOfferMargin: map['ECommerceOfferMargin'] as double,
      ECommerceMinimumMargin: map['ECommerceMinimumMargin'] as double,
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
