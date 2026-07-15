// lib/core/domain/entities/product/bsf/bsf_product_entity.dart
import 'package:equatable/equatable.dart';

class BSFProductEntity extends Equatable {
  final bool? isScheduledToUnify;
  final int? code;
  final String? name;
  final DateTime? dateOfCadaster;
  final DateTime? dateOfDesativation;
  final DateTime? dateOutOfLine;
  final DateTime? dateLastChange;
  final bool? isDesativate;
  final String? isDesativateString;
  final bool? isOutOfLine;
  final bool? practicePriceRoundRules;
  final bool? isPriceControlled;
  final bool? isReturnablePacking;
  final bool? isAlcoholicProduct;
  final bool? isFloatingProduct;
  final bool? isFatherOfGrate;
  final int? fatherGrateCode;
  final bool? isBasicBasketItem;
  final bool? consolidateGrateChildsInFiscalNote;
  final bool? fatherOfGrateIsLiberatedSale;
  final String? complement;
  final String? personalizedCode;
  final bool? isProductForComplementFiscalNote;
  final String? legacyCode;
  final String? productPackingString;
  final String? productPackingTypeString;
  final double? productPackingQuantity;
  final String? productPackingQuantityString;
  final String? productPackingPersonalizedCodeString;
  final String? productPackingSpecificationString;
  final String? productPackingPriceLookUpString;
  final String? productPackingEanString;
  final List<String>? eans;
  final String? productPackingSaleRetailPriceString;
  final String? productPackingWholeSalePriceString;
  final String? productPackingECommercePriceString;
  final String? productPackingSupplierReferenceString;
  final String? productPackingStockBalanceForSaleString;
  final String? productPackingStockBalanceForBuyString;
  final String? productPackingCurrentStockString;
  final String? productEnterpriseCurveString;
  final String? productPackingMininumQuantityForWholeSaleString;
  final String? commercializationPackingDescription;
  final double? commercializationPackingQuantity;
  final String? sizeScale;
  final String? inmetroNumber;
  final String? manufacturerString;
  final bool? useShallowSearch;

  const BSFProductEntity({
    required this.isScheduledToUnify,
    required this.code,
    required this.name,
    required this.dateOfCadaster,
    required this.dateOfDesativation,
    required this.dateOutOfLine,
    required this.dateLastChange,
    required this.isDesativate,
    required this.isDesativateString,
    required this.isOutOfLine,
    required this.practicePriceRoundRules,
    required this.isPriceControlled,
    required this.isReturnablePacking,
    required this.isAlcoholicProduct,
    required this.isFloatingProduct,
    required this.isFatherOfGrate,
    required this.fatherGrateCode,
    required this.isBasicBasketItem,
    required this.consolidateGrateChildsInFiscalNote,
    required this.fatherOfGrateIsLiberatedSale,
    required this.complement,
    required this.personalizedCode,
    required this.isProductForComplementFiscalNote,
    required this.legacyCode,
    required this.productPackingString,
    required this.productPackingTypeString,
    required this.productPackingQuantity,
    required this.productPackingQuantityString,
    required this.productPackingPersonalizedCodeString,
    required this.productPackingSpecificationString,
    required this.productPackingPriceLookUpString,
    required this.productPackingEanString,
    required this.eans,
    required this.productPackingSaleRetailPriceString,
    required this.productPackingWholeSalePriceString,
    required this.productPackingECommercePriceString,
    required this.productPackingSupplierReferenceString,
    required this.productPackingStockBalanceForSaleString,
    required this.productPackingStockBalanceForBuyString,
    required this.productPackingCurrentStockString,
    required this.productEnterpriseCurveString,
    required this.productPackingMininumQuantityForWholeSaleString,
    required this.commercializationPackingDescription,
    required this.commercializationPackingQuantity,
    required this.sizeScale,
    required this.inmetroNumber,
    required this.manufacturerString,
    required this.useShallowSearch,
  });

  @override
  List<Object?> get props => [
    isScheduledToUnify,
    code,
    name,
    dateOfCadaster,
    dateOfDesativation,
    dateOutOfLine,
    dateLastChange,
    isDesativate,
    isDesativateString,
    isOutOfLine,
    practicePriceRoundRules,
    isPriceControlled,
    isReturnablePacking,
    isAlcoholicProduct,
    isFloatingProduct,
    isFatherOfGrate,
    fatherGrateCode,
    isBasicBasketItem,
    consolidateGrateChildsInFiscalNote,
    fatherOfGrateIsLiberatedSale,
    complement,
    personalizedCode,
    isProductForComplementFiscalNote,
    legacyCode,
    productPackingString,
    productPackingTypeString,
    productPackingQuantity,
    productPackingQuantityString,
    productPackingPersonalizedCodeString,
    productPackingSpecificationString,
    productPackingPriceLookUpString,
    productPackingEanString,
    eans,
    productPackingSaleRetailPriceString,
    productPackingWholeSalePriceString,
    productPackingECommercePriceString,
    productPackingSupplierReferenceString,
    productPackingStockBalanceForSaleString,
    productPackingStockBalanceForBuyString,
    productPackingCurrentStockString,
    productEnterpriseCurveString,
    productPackingMininumQuantityForWholeSaleString,
    commercializationPackingDescription,
    commercializationPackingQuantity,
    sizeScale,
    inmetroNumber,
    manufacturerString,
    useShallowSearch,
  ];
}
