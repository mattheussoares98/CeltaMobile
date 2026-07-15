// lib/core/data/models/product/bsf/bsf_product_model.dart
import 'package:celta_inventario/core/domain/entities/entities.dart';

class BSFProductModel extends BSFProductEntity {
  const BSFProductModel({
    required super.isScheduledToUnify,
    required super.code,
    required super.name,
    required super.dateOfCadaster,
    required super.dateOfDesativation,
    required super.dateOutOfLine,
    required super.dateLastChange,
    required super.isDesativate,
    required super.isDesativateString,
    required super.isOutOfLine,
    required super.practicePriceRoundRules,
    required super.isPriceControlled,
    required super.isReturnablePacking,
    required super.isAlcoholicProduct,
    required super.isFloatingProduct,
    required super.isFatherOfGrate,
    required super.fatherGrateCode,
    required super.isBasicBasketItem,
    required super.consolidateGrateChildsInFiscalNote,
    required super.fatherOfGrateIsLiberatedSale,
    required super.complement,
    required super.personalizedCode,
    required super.isProductForComplementFiscalNote,
    required super.legacyCode,
    required super.productPackingString,
    required super.productPackingTypeString,
    required super.productPackingQuantity,
    required super.productPackingQuantityString,
    required super.productPackingPersonalizedCodeString,
    required super.productPackingSpecificationString,
    required super.productPackingPriceLookUpString,
    required super.productPackingEanString,
    required super.eans,
    required super.productPackingSaleRetailPriceString,
    required super.productPackingWholeSalePriceString,
    required super.productPackingECommercePriceString,
    required super.productPackingSupplierReferenceString,
    required super.productPackingStockBalanceForSaleString,
    required super.productPackingStockBalanceForBuyString,
    required super.productPackingCurrentStockString,
    required super.productEnterpriseCurveString,
    required super.productPackingMininumQuantityForWholeSaleString,
    required super.commercializationPackingDescription,
    required super.commercializationPackingQuantity,
    required super.sizeScale,
    required super.inmetroNumber,
    required super.manufacturerString,
    required super.useShallowSearch,
  });

  factory BSFProductModel.fromJson(Map json) => BSFProductModel(
    isScheduledToUnify: json['IsScheduledToUnify'],
    code: json['Code'],
    name: json['Name']?.toString(),
    dateOfCadaster: json['DateOfCadaster'] != null
        ? DateTime.tryParse(json['DateOfCadaster'].toString())
        : null,
    dateOfDesativation: json['DateOfDesativation'] != null
        ? DateTime.tryParse(json['DateOfDesativation'].toString())
        : null,
    dateOutOfLine: json['DateOutOfLine'] != null
        ? DateTime.tryParse(json['DateOutOfLine'].toString())
        : null,
    dateLastChange: json['DateLastChange'] != null
        ? DateTime.tryParse(json['DateLastChange'].toString())
        : null,
    isDesativate: json['IsDesativate'],
    isDesativateString: json['IsDesativateString']?.toString(),
    isOutOfLine: json['IsOutOfLine'],
    practicePriceRoundRules: json['PracticePriceRoundRules'],
    isPriceControlled: json['IsPriceControlled'],
    isReturnablePacking: json['IsReturnablePacking'],
    isAlcoholicProduct: json['IsAlcoholicProduct'],
    isFloatingProduct: json['IsFloatingProduct'],
    isFatherOfGrate: json['IsFatherOfGrate'],
    fatherGrateCode: json['FatherGrateCode'],
    isBasicBasketItem: json['IsBasicBasketItem'],
    consolidateGrateChildsInFiscalNote:
        json['ConsolidateGrateChildsInFiscalNote'],
    fatherOfGrateIsLiberatedSale: json['FatherOfGrateIsLiberatedSale'],
    complement: json['Complement']?.toString(),
    personalizedCode: json['PersonalizedCode']?.toString(),
    isProductForComplementFiscalNote: json['IsProductForComplementFiscalNote'],
    legacyCode: json['LegacyCode']?.toString(),
    productPackingString: json['ProductPackingString']?.toString(),
    productPackingTypeString: json['ProductPackingTypeString']?.toString(),
    productPackingQuantity: json['ProductPackingQuantity'] != null
        ? double.tryParse(json['ProductPackingQuantity'].toString())
        : null,
    productPackingQuantityString: json['ProductPackingQuantityString']
        ?.toString(),
    productPackingPersonalizedCodeString:
        json['ProductPackingPersonalizedCodeString']?.toString(),
    productPackingSpecificationString: json['ProductPackingSpecificationString']
        ?.toString(),
    productPackingPriceLookUpString: json['ProductPackingPriceLookUpString']
        ?.toString(),
    productPackingEanString: json['ProductPackingEanString']?.toString(),
    eans: json['Eans'] != null
        ? (json['Eans'] as List).map((e) => e.toString()).toList()
        : null,
    productPackingSaleRetailPriceString:
        json['ProductPackingSaleRetailPriceString']?.toString(),
    productPackingWholeSalePriceString:
        json['ProductPackingWholeSalePriceString']?.toString(),
    productPackingECommercePriceString:
        json['ProductPackingECommercePriceString']?.toString(),
    productPackingSupplierReferenceString:
        json['ProductPackingSupplierReferenceString']?.toString(),
    productPackingStockBalanceForSaleString:
        json['ProductPackingStockBalanceForSaleString']?.toString(),
    productPackingStockBalanceForBuyString:
        json['ProductPackingStockBalanceForBuyString']?.toString(),
    productPackingCurrentStockString: json['ProductPackingCurrentStockString']
        ?.toString(),
    productEnterpriseCurveString: json['ProductEnterpriseCurveString']
        ?.toString(),
    productPackingMininumQuantityForWholeSaleString:
        json['ProductPackingMininumQuantityForWholeSaleString']?.toString(),
    commercializationPackingDescription:
        json['CommercializationPackingDescription']?.toString(),
    commercializationPackingQuantity:
        json['CommercializationPackingQuantity'] != null
        ? double.tryParse(json['CommercializationPackingQuantity'].toString())
        : null,
    sizeScale: json['SizeScale']?.toString(),
    inmetroNumber: json['InmetroNumber']?.toString(),
    manufacturerString: json['ManufacturerString']?.toString(),
    useShallowSearch: json['UseShallowSearch'],
  );

  Map<String, dynamic> toJson() => {
    'IsScheduledToUnify': isScheduledToUnify,
    'Code': code,
    'Name': name,
    'DateOfCadaster': dateOfCadaster?.toIso8601String(),
    'DateOfDesativation': dateOfDesativation?.toIso8601String(),
    'DateOutOfLine': dateOutOfLine?.toIso8601String(),
    'DateLastChange': dateLastChange?.toIso8601String(),
    'IsDesativate': isDesativate,
    'IsDesativateString': isDesativateString,
    'IsOutOfLine': isOutOfLine,
    'PracticePriceRoundRules': practicePriceRoundRules,
    'IsPriceControlled': isPriceControlled,
    'IsReturnablePacking': isReturnablePacking,
    'IsAlcoholicProduct': isAlcoholicProduct,
    'IsFloatingProduct': isFloatingProduct,
    'IsFatherOfGrate': isFatherOfGrate,
    'FatherGrateCode': fatherGrateCode,
    'IsBasicBasketItem': isBasicBasketItem,
    'ConsolidateGrateChildsInFiscalNote': consolidateGrateChildsInFiscalNote,
    'FatherOfGrateIsLiberatedSale': fatherOfGrateIsLiberatedSale,
    'Complement': complement,
    'PersonalizedCode': personalizedCode,
    'IsProductForComplementFiscalNote': isProductForComplementFiscalNote,
    'LegacyCode': legacyCode,
    'ProductPackingString': productPackingString,
    'ProductPackingTypeString': productPackingTypeString,
    'ProductPackingQuantity': productPackingQuantity,
    'ProductPackingQuantityString': productPackingQuantityString,
    'ProductPackingPersonalizedCodeString':
        productPackingPersonalizedCodeString,
    'ProductPackingSpecificationString': productPackingSpecificationString,
    'ProductPackingPriceLookUpString': productPackingPriceLookUpString,
    'ProductPackingEanString': productPackingEanString,
    'Eans': eans,
    'ProductPackingSaleRetailPriceString': productPackingSaleRetailPriceString,
    'ProductPackingWholeSalePriceString': productPackingWholeSalePriceString,
    'ProductPackingECommercePriceString': productPackingECommercePriceString,
    'ProductPackingSupplierReferenceString':
        productPackingSupplierReferenceString,
    'ProductPackingStockBalanceForSaleString':
        productPackingStockBalanceForSaleString,
    'ProductPackingStockBalanceForBuyString':
        productPackingStockBalanceForBuyString,
    'ProductPackingCurrentStockString': productPackingCurrentStockString,
    'ProductEnterpriseCurveString': productEnterpriseCurveString,
    'ProductPackingMininumQuantityForWholeSaleString':
        productPackingMininumQuantityForWholeSaleString,
    'CommercializationPackingDescription': commercializationPackingDescription,
    'CommercializationPackingQuantity': commercializationPackingQuantity,
    'SizeScale': sizeScale,
    'InmetroNumber': inmetroNumber,
    'ManufacturerString': manufacturerString,
    'UseShallowSearch': useShallowSearch,
  };

  factory BSFProductModel.fromEntity(
    BSFProductEntity entity,
  ) => BSFProductModel(
    isScheduledToUnify: entity.isScheduledToUnify,
    code: entity.code,
    name: entity.name,
    dateOfCadaster: entity.dateOfCadaster,
    dateOfDesativation: entity.dateOfDesativation,
    dateOutOfLine: entity.dateOutOfLine,
    dateLastChange: entity.dateLastChange,
    isDesativate: entity.isDesativate,
    isDesativateString: entity.isDesativateString,
    isOutOfLine: entity.isOutOfLine,
    practicePriceRoundRules: entity.practicePriceRoundRules,
    isPriceControlled: entity.isPriceControlled,
    isReturnablePacking: entity.isReturnablePacking,
    isAlcoholicProduct: entity.isAlcoholicProduct,
    isFloatingProduct: entity.isFloatingProduct,
    isFatherOfGrate: entity.isFatherOfGrate,
    fatherGrateCode: entity.fatherGrateCode,
    isBasicBasketItem: entity.isBasicBasketItem,
    consolidateGrateChildsInFiscalNote:
        entity.consolidateGrateChildsInFiscalNote,
    fatherOfGrateIsLiberatedSale: entity.fatherOfGrateIsLiberatedSale,
    complement: entity.complement,
    personalizedCode: entity.personalizedCode,
    isProductForComplementFiscalNote: entity.isProductForComplementFiscalNote,
    legacyCode: entity.legacyCode,
    productPackingString: entity.productPackingString,
    productPackingTypeString: entity.productPackingTypeString,
    productPackingQuantity: entity.productPackingQuantity,
    productPackingQuantityString: entity.productPackingQuantityString,
    productPackingPersonalizedCodeString:
        entity.productPackingPersonalizedCodeString,
    productPackingSpecificationString: entity.productPackingSpecificationString,
    productPackingPriceLookUpString: entity.productPackingPriceLookUpString,
    productPackingEanString: entity.productPackingEanString,
    eans: entity.eans,
    productPackingSaleRetailPriceString:
        entity.productPackingSaleRetailPriceString,
    productPackingWholeSalePriceString:
        entity.productPackingWholeSalePriceString,
    productPackingECommercePriceString:
        entity.productPackingECommercePriceString,
    productPackingSupplierReferenceString:
        entity.productPackingSupplierReferenceString,
    productPackingStockBalanceForSaleString:
        entity.productPackingStockBalanceForSaleString,
    productPackingStockBalanceForBuyString:
        entity.productPackingStockBalanceForBuyString,
    productPackingCurrentStockString: entity.productPackingCurrentStockString,
    productEnterpriseCurveString: entity.productEnterpriseCurveString,
    productPackingMininumQuantityForWholeSaleString:
        entity.productPackingMininumQuantityForWholeSaleString,
    commercializationPackingDescription:
        entity.commercializationPackingDescription,
    commercializationPackingQuantity: entity.commercializationPackingQuantity,
    sizeScale: entity.sizeScale,
    inmetroNumber: entity.inmetroNumber,
    manufacturerString: entity.manufacturerString,
    useShallowSearch: entity.useShallowSearch,
  );

  BSFProductEntity toEntity() => BSFProductEntity(
    isScheduledToUnify: isScheduledToUnify,
    code: code,
    name: name,
    dateOfCadaster: dateOfCadaster,
    dateOfDesativation: dateOfDesativation,
    dateOutOfLine: dateOutOfLine,
    dateLastChange: dateLastChange,
    isDesativate: isDesativate,
    isDesativateString: isDesativateString,
    isOutOfLine: isOutOfLine,
    practicePriceRoundRules: practicePriceRoundRules,
    isPriceControlled: isPriceControlled,
    isReturnablePacking: isReturnablePacking,
    isAlcoholicProduct: isAlcoholicProduct,
    isFloatingProduct: isFloatingProduct,
    isFatherOfGrate: isFatherOfGrate,
    fatherGrateCode: fatherGrateCode,
    isBasicBasketItem: isBasicBasketItem,
    consolidateGrateChildsInFiscalNote: consolidateGrateChildsInFiscalNote,
    fatherOfGrateIsLiberatedSale: fatherOfGrateIsLiberatedSale,
    complement: complement,
    personalizedCode: personalizedCode,
    isProductForComplementFiscalNote: isProductForComplementFiscalNote,
    legacyCode: legacyCode,
    productPackingString: productPackingString,
    productPackingTypeString: productPackingTypeString,
    productPackingQuantity: productPackingQuantity,
    productPackingQuantityString: productPackingQuantityString,
    productPackingPersonalizedCodeString: productPackingPersonalizedCodeString,
    productPackingSpecificationString: productPackingSpecificationString,
    productPackingPriceLookUpString: productPackingPriceLookUpString,
    productPackingEanString: productPackingEanString,
    eans: eans,
    productPackingSaleRetailPriceString: productPackingSaleRetailPriceString,
    productPackingWholeSalePriceString: productPackingWholeSalePriceString,
    productPackingECommercePriceString: productPackingECommercePriceString,
    productPackingSupplierReferenceString:
        productPackingSupplierReferenceString,
    productPackingStockBalanceForSaleString:
        productPackingStockBalanceForSaleString,
    productPackingStockBalanceForBuyString:
        productPackingStockBalanceForBuyString,
    productPackingCurrentStockString: productPackingCurrentStockString,
    productEnterpriseCurveString: productEnterpriseCurveString,
    productPackingMininumQuantityForWholeSaleString:
        productPackingMininumQuantityForWholeSaleString,
    commercializationPackingDescription: commercializationPackingDescription,
    commercializationPackingQuantity: commercializationPackingQuantity,
    sizeScale: sizeScale,
    inmetroNumber: inmetroNumber,
    manufacturerString: manufacturerString,
    useShallowSearch: useShallowSearch,
  );
}
