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
  ];

  BSFPriceCostEntity copyWith({
    double? saleRetailPricePractice,
    double? lastSaleRetailPrice,
    double? wholeSalePricePractice,
    double? lastWholeSalePrice,
    double? eCommercePricePractice,
    double? lastECommercePrice,
    double? saleRetailOfferPractice,
    double? lastSaleRetailOffer,
    double? wholeSaleOfferPractice,
    double? lastWholeSaleOffer,
    double? eCommerceOfferPractice,
    double? lastECommerceOffer,
    double? replacementCost,
    double? lastReplacementCost,
    double? mediumReplacementCost,
    double? subsidizedReplacementCost,
    double? activeSubsidizedReplacementCost,
    double? liquidCost,
    double? lastLiquidCost,
    double? lastUnitValue,
    double? baseCalcIcmsSubstUnit,
    double? valueOfIcmsSubstUnit,
    double? valueOfIcmsOwnerUnit,
    double? mininumQuantityForWholeSale,
    double? mediumLiquidCost,
    double? subsidizedLiquidCost,
    double? activeSubsidizedLiquidCost,
    double? fiscalBaseCalcSubstitute,
    double? fiscalBaseCalcSubstitutePrevious,
    double? replacementCostReal,
    double? lastReplacementCostReal,
    double? liquidCostReal,
    double? lastLiquidCostReal,
    double? replacementCostFiscal,
    double? lastReplacementCostFiscal,
    double? liquidCostFiscal,
    double? lastLiquidCostFiscal,
    double? operationCost,
    double? bonusSubsidyValue,
    double? bonusSubsidyActiveValue,
    double? bonusSubsidyUnitaryValue,
    double? bonusSubsidyActiveUnitaryValue,
    bool? isOfferInRetail,
    int? salePracticedTypeInSaleRetail,
    double? salePracticedInSaleRetail,
    bool? isOfferInWhole,
    int? salePracticedTypeInWholeSale,
    double? salePracticedInWholeSale,
    bool? isOfferInECommerce,
    int? salePriceTypePracticedInECommerce,
    double? salePracticedInECommerce,
    bool anullSalePracticedInSaleRetail = false,
    bool anullSalePracticedInWholeSale = false,
    bool? anullMininumQuantityForWholeSale,
    bool anullSaleRetailPricePractice = false,
  }) {
    return BSFPriceCostEntity(
      saleRetailPricePractice: anullSaleRetailPricePractice
          ? null
          : (saleRetailPricePractice ?? this.saleRetailPricePractice),
      lastSaleRetailPrice: lastSaleRetailPrice ?? this.lastSaleRetailPrice,
      wholeSalePricePractice:
          wholeSalePricePractice ?? this.wholeSalePricePractice,
      lastWholeSalePrice: lastWholeSalePrice ?? this.lastWholeSalePrice,
      eCommercePricePractice:
          eCommercePricePractice ?? this.eCommercePricePractice,
      lastECommercePrice: lastECommercePrice ?? this.lastECommercePrice,
      saleRetailOfferPractice:
          saleRetailOfferPractice ?? this.saleRetailOfferPractice,
      lastSaleRetailOffer: lastSaleRetailOffer ?? this.lastSaleRetailOffer,
      wholeSaleOfferPractice:
          wholeSaleOfferPractice ?? this.wholeSaleOfferPractice,
      lastWholeSaleOffer: lastWholeSaleOffer ?? this.lastWholeSaleOffer,
      eCommerceOfferPractice:
          eCommerceOfferPractice ?? this.eCommerceOfferPractice,
      lastECommerceOffer: lastECommerceOffer ?? this.lastECommerceOffer,
      replacementCost: replacementCost ?? this.replacementCost,
      lastReplacementCost: lastReplacementCost ?? this.lastReplacementCost,
      mediumReplacementCost:
          mediumReplacementCost ?? this.mediumReplacementCost,
      subsidizedReplacementCost:
          subsidizedReplacementCost ?? this.subsidizedReplacementCost,
      activeSubsidizedReplacementCost:
          activeSubsidizedReplacementCost ??
          this.activeSubsidizedReplacementCost,
      liquidCost: liquidCost ?? this.liquidCost,
      lastLiquidCost: lastLiquidCost ?? this.lastLiquidCost,
      lastUnitValue: lastUnitValue ?? this.lastUnitValue,
      baseCalcIcmsSubstUnit:
          baseCalcIcmsSubstUnit ?? this.baseCalcIcmsSubstUnit,
      valueOfIcmsSubstUnit: valueOfIcmsSubstUnit ?? this.valueOfIcmsSubstUnit,
      valueOfIcmsOwnerUnit: valueOfIcmsOwnerUnit ?? this.valueOfIcmsOwnerUnit,
      mininumQuantityForWholeSale: anullMininumQuantityForWholeSale == true
          ? null
          : mininumQuantityForWholeSale ?? this.mininumQuantityForWholeSale,
      mediumLiquidCost: mediumLiquidCost ?? this.mediumLiquidCost,
      subsidizedLiquidCost: subsidizedLiquidCost ?? this.subsidizedLiquidCost,
      activeSubsidizedLiquidCost:
          activeSubsidizedLiquidCost ?? this.activeSubsidizedLiquidCost,
      fiscalBaseCalcSubstitute:
          fiscalBaseCalcSubstitute ?? this.fiscalBaseCalcSubstitute,
      fiscalBaseCalcSubstitutePrevious:
          fiscalBaseCalcSubstitutePrevious ??
          this.fiscalBaseCalcSubstitutePrevious,
      replacementCostReal: replacementCostReal ?? this.replacementCostReal,
      lastReplacementCostReal:
          lastReplacementCostReal ?? this.lastReplacementCostReal,
      liquidCostReal: liquidCostReal ?? this.liquidCostReal,
      lastLiquidCostReal: lastLiquidCostReal ?? this.lastLiquidCostReal,
      replacementCostFiscal:
          replacementCostFiscal ?? this.replacementCostFiscal,
      lastReplacementCostFiscal:
          lastReplacementCostFiscal ?? this.lastReplacementCostFiscal,
      liquidCostFiscal: liquidCostFiscal ?? this.liquidCostFiscal,
      lastLiquidCostFiscal: lastLiquidCostFiscal ?? this.lastLiquidCostFiscal,
      operationCost: operationCost ?? this.operationCost,
      bonusSubsidyValue: bonusSubsidyValue ?? this.bonusSubsidyValue,
      bonusSubsidyActiveValue:
          bonusSubsidyActiveValue ?? this.bonusSubsidyActiveValue,
      bonusSubsidyUnitaryValue:
          bonusSubsidyUnitaryValue ?? this.bonusSubsidyUnitaryValue,
      bonusSubsidyActiveUnitaryValue:
          bonusSubsidyActiveUnitaryValue ?? this.bonusSubsidyActiveUnitaryValue,
      isOfferInRetail: isOfferInRetail ?? this.isOfferInRetail,
      salePracticedTypeInSaleRetail:
          salePracticedTypeInSaleRetail ?? this.salePracticedTypeInSaleRetail,
      salePracticedInSaleRetail: anullSalePracticedInSaleRetail
          ? null
          : (salePracticedInSaleRetail ?? this.salePracticedInSaleRetail),
      isOfferInWhole: isOfferInWhole ?? this.isOfferInWhole,
      salePracticedTypeInWholeSale:
          salePracticedTypeInWholeSale ?? this.salePracticedTypeInWholeSale,
      salePracticedInWholeSale: anullSalePracticedInWholeSale
          ? null
          : (salePracticedInWholeSale ?? this.salePracticedInWholeSale),
      isOfferInECommerce: isOfferInECommerce ?? this.isOfferInECommerce,
      salePriceTypePracticedInECommerce:
          salePriceTypePracticedInECommerce ??
          this.salePriceTypePracticedInECommerce,
      salePracticedInECommerce:
          salePracticedInECommerce ?? this.salePracticedInECommerce,
    );
  }
}
