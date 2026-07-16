// lib/features/receipt/data/model/bsf/bsf_gr_product_model.dart
import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/features/receipt/domain/entity/entity.dart';

class BSFGRProductModel extends BSFGRProductEntity {
  const BSFGRProductModel({
    required super.document,
    required super.code,
    required super.quantity,
    required super.quantityString,
    required super.quantityOfXml,
    required super.quantityWithoutRequest,
    required super.unitLiquidValue,
    required super.unitLiquidValueOnBuyRequests,
    required super.unitValue,
    required super.unitValueOnBuyRequests,
    required super.judgementStatusRequestForFiscalNote,
    required super.judgementStatusFiscalNoteForCounting,
    required super.judgementStatusRequestForCounting,
    required super.availableQuantityInAssociatesBuyRequests,
    required super.availableQuantityInAnotherBuyRequests,
    required super.reservedQuantityByAnotherGRDoc,
    required super.referenceOfXml,
    required super.divergencyUnitLiquidValue,
    required super.totalDivergencyLiquidValue,
    required super.divergenceQuantityRequestForCounting,
    required super.divergenceQuantityRequestForFiscalNote,
    required super.divergenceQuantityFiscalNoteForCounting,
    required super.productString,
    required super.productPackingPersonalizedCodeString,
    required super.fiscalCode,
    required super.isUpdate,
    required super.hasDivergencyQuantity,
    required super.product,
  });

  factory BSFGRProductModel.fromJson(Map json) => BSFGRProductModel(
    document: json['Document'],
    code: json['Code'] ?? 0,
    quantity: double.tryParse(json['Quantity'].toString()) ?? 0.0,
    quantityString: json['QuantityString']?.toString() ?? '',
    quantityOfXml: double.tryParse(json['QuantityOfXml'].toString()) ?? 0.0,
    quantityWithoutRequest: json['QuantityWithoutRequest'] ?? 0,
    unitLiquidValue: double.tryParse(json['UnitLiquidValue'].toString()) ?? 0.0,
    unitLiquidValueOnBuyRequests:
        double.tryParse(json['UnitLiquidValueOnBuyRequests'].toString()) ?? 0.0,
    unitValue: double.tryParse(json['UnitValue'].toString()) ?? 0.0,
    unitValueOnBuyRequests:
        double.tryParse(json['UnitValueOnBuyRequests'].toString()) ?? 0.0,
    judgementStatusRequestForFiscalNote: BsfGRProductJudgmentStatus.fromValue(
      json['JudgementStatusRequestForFiscalNote'],
    ),
    judgementStatusFiscalNoteForCounting: BsfGRProductJudgmentStatus.fromValue(
      json['JudgementStatusFiscalNoteForCounting'],
    ),
    judgementStatusRequestForCounting: BsfGRProductJudgmentStatus.fromValue(
      json['JudgementStatusRequestForCounting'],
    ),
    availableQuantityInAssociatesBuyRequests:
        double.tryParse(
          json['AvailableQuantityInAssociatesBuyRequests'].toString(),
        ) ??
        0.0,
    availableQuantityInAnotherBuyRequests:
        double.tryParse(
          json['AvailableQuantityInAnotherBuyRequests'].toString(),
        ) ??
        0.0,
    reservedQuantityByAnotherGRDoc:
        double.tryParse(json['ReservedQuantityByAnotherGRDoc'].toString()) ??
        0.0,
    referenceOfXml: json['ReferenceOfXml']?.toString() ?? '',
    divergencyUnitLiquidValue:
        double.tryParse(json['DivergencyUnitLiquidValue'].toString()) ?? 0.0,
    totalDivergencyLiquidValue:
        double.tryParse(json['TotalDivergencyLiquidValue'].toString()) ?? 0.0,
    divergenceQuantityRequestForCounting:
        double.tryParse(
          json['DivergenceQuantityRequestForCounting'].toString(),
        ) ??
        0.0,
    divergenceQuantityRequestForFiscalNote:
        double.tryParse(
          json['DivergenceQuantityRequestForFiscalNote'].toString(),
        ) ??
        0.0,
    divergenceQuantityFiscalNoteForCounting:
        double.tryParse(
          json['DivergenceQuantityFiscalNoteForCounting'].toString(),
        ) ??
        0.0,
    productString: json['ProductString']?.toString() ?? '',
    productPackingPersonalizedCodeString:
        json['ProductPackingPersonalizedCodeString']?.toString() ?? '',
    fiscalCode: json['FiscalCode'],
    isUpdate: json['IsUpdate'] ?? false,
    hasDivergencyQuantity: json['HasDivergencyQuantity'] ?? false,
    product: BSFProductModel.fromJson(json['Product']),
  );

  Map<String, dynamic> toJson() => {
    'Document': document,
    'Code': code,
    'Quantity': quantity,
    'QuantityString': quantityString,
    'QuantityOfXml': quantityOfXml,
    'QuantityWithoutRequest': quantityWithoutRequest,
    'UnitLiquidValue': unitLiquidValue,
    'UnitLiquidValueOnBuyRequests': unitLiquidValueOnBuyRequests,
    'UnitValue': unitValue,
    'UnitValueOnBuyRequests': unitValueOnBuyRequests,
    'JudgementStatusRequestForFiscalNote':
        judgementStatusRequestForFiscalNote.value,
    'JudgementStatusFiscalNoteForCounting':
        judgementStatusFiscalNoteForCounting.value,
    'JudgementStatusRequestForCounting':
        judgementStatusRequestForCounting.value,
    'AvailableQuantityInAssociatesBuyRequests':
        availableQuantityInAssociatesBuyRequests,
    'AvailableQuantityInAnotherBuyRequests':
        availableQuantityInAnotherBuyRequests,
    'ReservedQuantityByAnotherGRDoc': reservedQuantityByAnotherGRDoc,
    'ReferenceOfXml': referenceOfXml,
    'DivergencyUnitLiquidValue': divergencyUnitLiquidValue,
    'TotalDivergencyLiquidValue': totalDivergencyLiquidValue,
    'DivergenceQuantityRequestForCounting':
        divergenceQuantityRequestForCounting,
    'DivergenceQuantityRequestForFiscalNote':
        divergenceQuantityRequestForFiscalNote,
    'DivergenceQuantityFiscalNoteForCounting':
        divergenceQuantityFiscalNoteForCounting,
    'ProductString': productString,
    'ProductPackingPersonalizedCodeString':
        productPackingPersonalizedCodeString,
    'FiscalCode': fiscalCode,
    'IsUpdate': isUpdate,
    'HasDivergencyQuantity': hasDivergencyQuantity,
    'Product': BSFProductModel.fromEntity(product).toJson(),
  };

  factory BSFGRProductModel.fromEntity(BSFGRProductEntity entity) =>
      BSFGRProductModel(
        document: entity.document,
        code: entity.code,
        quantity: entity.quantity,
        quantityString: entity.quantityString,
        quantityOfXml: entity.quantityOfXml,
        quantityWithoutRequest: entity.quantityWithoutRequest,
        unitLiquidValue: entity.unitLiquidValue,
        unitLiquidValueOnBuyRequests: entity.unitLiquidValueOnBuyRequests,
        unitValue: entity.unitValue,
        unitValueOnBuyRequests: entity.unitValueOnBuyRequests,
        judgementStatusRequestForFiscalNote:
            entity.judgementStatusRequestForFiscalNote,
        judgementStatusFiscalNoteForCounting:
            entity.judgementStatusFiscalNoteForCounting,
        judgementStatusRequestForCounting:
            entity.judgementStatusRequestForCounting,
        availableQuantityInAssociatesBuyRequests:
            entity.availableQuantityInAssociatesBuyRequests,
        availableQuantityInAnotherBuyRequests:
            entity.availableQuantityInAnotherBuyRequests,
        reservedQuantityByAnotherGRDoc: entity.reservedQuantityByAnotherGRDoc,
        referenceOfXml: entity.referenceOfXml,
        divergencyUnitLiquidValue: entity.divergencyUnitLiquidValue,
        totalDivergencyLiquidValue: entity.totalDivergencyLiquidValue,
        divergenceQuantityRequestForCounting:
            entity.divergenceQuantityRequestForCounting,
        divergenceQuantityRequestForFiscalNote:
            entity.divergenceQuantityRequestForFiscalNote,
        divergenceQuantityFiscalNoteForCounting:
            entity.divergenceQuantityFiscalNoteForCounting,
        productString: entity.productString,
        productPackingPersonalizedCodeString:
            entity.productPackingPersonalizedCodeString,
        fiscalCode: entity.fiscalCode,
        isUpdate: entity.isUpdate,
        hasDivergencyQuantity: entity.hasDivergencyQuantity,
        product: BSFProductModel.fromEntity(entity.product),
      );

  BSFGRProductEntity toEntity() => BSFGRProductEntity(
    product: product,
    document: document,
    code: code,
    quantity: quantity,
    quantityString: quantityString,
    quantityOfXml: quantityOfXml,
    quantityWithoutRequest: quantityWithoutRequest,
    unitLiquidValue: unitLiquidValue,
    unitLiquidValueOnBuyRequests: unitLiquidValueOnBuyRequests,
    unitValue: unitValue,
    unitValueOnBuyRequests: unitValueOnBuyRequests,
    judgementStatusRequestForFiscalNote: judgementStatusRequestForFiscalNote,
    judgementStatusFiscalNoteForCounting: judgementStatusFiscalNoteForCounting,
    judgementStatusRequestForCounting: judgementStatusRequestForCounting,
    availableQuantityInAssociatesBuyRequests:
        availableQuantityInAssociatesBuyRequests,
    availableQuantityInAnotherBuyRequests:
        availableQuantityInAnotherBuyRequests,
    reservedQuantityByAnotherGRDoc: reservedQuantityByAnotherGRDoc,
    referenceOfXml: referenceOfXml,
    divergencyUnitLiquidValue: divergencyUnitLiquidValue,
    totalDivergencyLiquidValue: totalDivergencyLiquidValue,
    divergenceQuantityRequestForCounting: divergenceQuantityRequestForCounting,
    divergenceQuantityRequestForFiscalNote:
        divergenceQuantityRequestForFiscalNote,
    divergenceQuantityFiscalNoteForCounting:
        divergenceQuantityFiscalNoteForCounting,
    productString: productString,
    productPackingPersonalizedCodeString: productPackingPersonalizedCodeString,
    fiscalCode: fiscalCode,
    isUpdate: isUpdate,
    hasDivergencyQuantity: hasDivergencyQuantity,
  );
}
