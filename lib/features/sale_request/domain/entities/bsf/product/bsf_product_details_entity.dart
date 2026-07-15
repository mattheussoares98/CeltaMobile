import 'package:equatable/equatable.dart';

class BSFProductDetailsEntity extends Equatable {
  //TODO delete and use BSFProductEntity from core path
  final bool? isScheduledToUnify;
  final int? code;
  final String? name;
  final bool? isDesativate;
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
  final dynamic images;
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
  final String? manufacturerString;

  const BSFProductDetailsEntity({
    required this.isScheduledToUnify,
    required this.code,
    required this.name,
    required this.isDesativate,
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
    required this.images,
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
    required this.manufacturerString,
  });

  @override
  List<Object?> get props => [
    isScheduledToUnify,
    code,
    name,
    isDesativate,
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
    images,
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
    manufacturerString,
  ];
}
