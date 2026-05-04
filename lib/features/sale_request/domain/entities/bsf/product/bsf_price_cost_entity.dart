import 'package:equatable/equatable.dart';

class BSFPriceCostEntity extends Equatable {
  final double? saleRetailPricePractice;
  final double? lastSaleRetailPrice;
  final double? wholeSalePricePractice;
  final double? lastWholeSalePrice;
  final double? eCommercePricePractice;
  final double? lastECommercePrice;
  final double? saleRetailOfferPractice;
  final double? lastSaleRetailOffer;
  final double? wholeSaleOfferPractice;
  final double? lastWholeSaleOffer;
  final double? eCommerceOfferPractice;
  final double? lastECommerceOffer;
  final double? replacementCost;
  final double? lastReplacementCost;
  final double? mediumReplacementCost;
  final double? subsidizedReplacementCost;
  final double? activeSubsidizedReplacementCost;
  final double? liquidCost;
  final double? lastLiquidCost;
  final double? lastUnitValue;
  final double? baseCalcIcmsSubstUnit;
  final double? valueOfIcmsSubstUnit;
  final double? valueOfIcmsOwnerUnit;
  final double? mininumQuantityForWholeSale;
  final double? mediumLiquidCost;
  final double? subsidizedLiquidCost;
  final double? activeSubsidizedLiquidCost;
  final double? fiscalBaseCalcSubstitute;
  final double? fiscalBaseCalcSubstitutePrevious;
  final double? replacementCostReal;
  final double? lastReplacementCostReal;
  final double? liquidCostReal;
  final double? lastLiquidCostReal;
  final double? replacementCostFiscal;
  final double? lastReplacementCostFiscal;
  final double? liquidCostFiscal;
  final double? lastLiquidCostFiscal;
  final double? operationCost;
  final double? bonusSubsidyValue;
  final double? bonusSubsidyActiveValue;
  final double? bonusSubsidyUnitaryValue;
  final double? bonusSubsidyActiveUnitaryValue;
  final bool? isOfferInRetail;
  final int? salePracticedTypeInSaleRetail;
  final double? salePracticedInSaleRetail;
  final bool? isOfferInWhole;
  final int? salePracticedTypeInWholeSale;
  final double? salePracticedInWholeSale;
  final bool? isOfferInECommerce;
  final int? salePriceTypePracticedInECommerce;
  final double? salePracticedInECommerce;

  const BSFPriceCostEntity({
    required this.saleRetailPricePractice,
    required this.lastSaleRetailPrice,
    required this.wholeSalePricePractice,
    required this.lastWholeSalePrice,
    required this.eCommercePricePractice,
    required this.lastECommercePrice,
    required this.saleRetailOfferPractice,
    required this.lastSaleRetailOffer,
    required this.wholeSaleOfferPractice,
    required this.lastWholeSaleOffer,
    required this.eCommerceOfferPractice,
    required this.lastECommerceOffer,
    required this.replacementCost,
    required this.lastReplacementCost,
    required this.mediumReplacementCost,
    required this.subsidizedReplacementCost,
    required this.activeSubsidizedReplacementCost,
    required this.liquidCost,
    required this.lastLiquidCost,
    required this.lastUnitValue,
    required this.baseCalcIcmsSubstUnit,
    required this.valueOfIcmsSubstUnit,
    required this.valueOfIcmsOwnerUnit,
    required this.mininumQuantityForWholeSale,
    required this.mediumLiquidCost,
    required this.subsidizedLiquidCost,
    required this.activeSubsidizedLiquidCost,
    required this.fiscalBaseCalcSubstitute,
    required this.fiscalBaseCalcSubstitutePrevious,
    required this.replacementCostReal,
    required this.lastReplacementCostReal,
    required this.liquidCostReal,
    required this.lastLiquidCostReal,
    required this.replacementCostFiscal,
    required this.lastReplacementCostFiscal,
    required this.liquidCostFiscal,
    required this.lastLiquidCostFiscal,
    required this.operationCost,
    required this.bonusSubsidyValue,
    required this.bonusSubsidyActiveValue,
    required this.bonusSubsidyUnitaryValue,
    required this.bonusSubsidyActiveUnitaryValue,
    required this.isOfferInRetail,
    required this.salePracticedTypeInSaleRetail,
    required this.salePracticedInSaleRetail,
    required this.isOfferInWhole,
    required this.salePracticedTypeInWholeSale,
    required this.salePracticedInWholeSale,
    required this.isOfferInECommerce,
    required this.salePriceTypePracticedInECommerce,
    required this.salePracticedInECommerce,
  });

  @override
  List<Object?> get props => [
        saleRetailPricePractice,
        lastSaleRetailPrice,
        wholeSalePricePractice,
        lastWholeSalePrice,
        eCommercePricePractice,
        lastECommercePrice,
        saleRetailOfferPractice,
        lastSaleRetailOffer,
        wholeSaleOfferPractice,
        lastWholeSaleOffer,
        eCommerceOfferPractice,
        lastECommerceOffer,
        replacementCost,
        lastReplacementCost,
        mediumReplacementCost,
        subsidizedReplacementCost,
        activeSubsidizedReplacementCost,
        liquidCost,
        lastLiquidCost,
        lastUnitValue,
        baseCalcIcmsSubstUnit,
        valueOfIcmsSubstUnit,
        valueOfIcmsOwnerUnit,
        mininumQuantityForWholeSale,
        mediumLiquidCost,
        subsidizedLiquidCost,
        activeSubsidizedLiquidCost,
        fiscalBaseCalcSubstitute,
        fiscalBaseCalcSubstitutePrevious,
        replacementCostReal,
        lastReplacementCostReal,
        liquidCostReal,
        lastLiquidCostReal,
        replacementCostFiscal,
        lastReplacementCostFiscal,
        liquidCostFiscal,
        lastLiquidCostFiscal,
        operationCost,
        bonusSubsidyValue,
        bonusSubsidyActiveValue,
        bonusSubsidyUnitaryValue,
        bonusSubsidyActiveUnitaryValue,
        isOfferInRetail,
        salePracticedTypeInSaleRetail,
        salePracticedInSaleRetail,
        isOfferInWhole,
        salePracticedTypeInWholeSale,
        salePracticedInWholeSale,
        isOfferInECommerce,
        salePriceTypePracticedInECommerce,
        salePracticedInECommerce,
      ];
}
