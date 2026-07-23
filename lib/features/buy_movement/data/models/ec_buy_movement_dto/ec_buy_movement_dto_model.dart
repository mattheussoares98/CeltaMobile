import 'package:celta_inventario/features/buy_movement/data/models/ec_buy_movement_dto/ec_buy_movement_dto.dart';
import 'package:celta_inventario/features/buy_movement/domain/entities/entities.dart';

class EcBuyMovementDtoModel extends EcBuyMovementDtoEntity {
  const EcBuyMovementDtoModel({
    required super.code,
    required super.isCancelled,
    required super.dateOfCancellation,
    required super.userOfCancellation,
    required super.userOfEntrance,
    required super.fiscalNoteType,
    required super.enterprise,
    required super.buyers,
    required super.supplier,
    required super.documentNumber,
    required super.documentNumberComplement,
    required super.dateOfCreation,
    required super.dateOfEmission,
    required super.dateOfEntrance,
    required super.deliveryTax,
    required super.increment,
    required super.compensation,
    required super.discounts,
    required super.requests,
    required super.observations,
    required super.hasGoodsReceivingDocument,
    required super.totalLiquid,
    required super.totalBruteFromProductsAndServices,
    required super.totalDiscount,
    required super.totalCompensation,
    required super.totalIncrement,
    required super.totalDeliveryTax,
    required super.icmsAndIssBase,
    required super.icmsAndIssValue,
    required super.icmsSubstituteBase,
    required super.icmsSubstituteValueOnFiscalNote,
    required super.icmsSubstituteValueOnGnre,
    required super.fcpSubstituteValue,
    required super.totalLiquidOfFreight,
    required super.totalSecurityOfFreight,
    required super.totalExpenseAccessory,
    required super.ipiValue,
    required super.icmsValueAtDestiny,
    required super.icmsValueAtOrigin,
    required super.totalFundToCombatPovertyStateDestinyValue,
    required super.totalCalculatedLiquid,
    required super.products,
  });

  factory EcBuyMovementDtoModel.fromJson(Map json) {
    DateTime? date(String key) =>
        json[key] == null ? null : DateTime.tryParse(json[key] as String);
    double? number(String key) => (json[key] as num?)?.toDouble();

    return EcBuyMovementDtoModel(
      code: json['code'] as int,
      isCancelled: json['isCancelled'] as bool?,
      dateOfCancellation: date('dateOfCancellation'),
      userOfCancellation: json['userOfCancellation'] == null
          ? null
          : EcBuyMovementUserDtoModel.fromJson(
              json['userOfCancellation'] as Map,
            ),
      userOfEntrance: json['userOfEntrance'] == null
          ? null
          : EcBuyMovementUserDtoModel.fromJson(json['userOfEntrance'] as Map),
      fiscalNoteType: json['fiscalNoteType'] == null
          ? null
          : EcBuyMovementFiscalNoteTypeDtoModel.fromJson(
              json['fiscalNoteType'] as Map,
            ),
      enterprise: json['enterprise'] == null
          ? null
          : EcBuyMovementEnterpriseDtoModel.fromJson(json['enterprise'] as Map),
      buyers: (json['buyers'] as List?)
          ?.map((item) => EcBuyMovementBuyerDtoModel.fromJson(item as Map))
          .toList(),
      supplier: json['supplier'] == null
          ? null
          : EcBuyMovementSupplierDtoModel.fromJson(json['supplier'] as Map),
      documentNumber: json['documentNumber'] as int?,
      documentNumberComplement: json['documentNumberComplement'] as String?,
      dateOfCreation: date('dateOfCreation'),
      dateOfEmission: date('dateOfEmission'),
      dateOfEntrance: date('dateOfEntrance'),
      deliveryTax: json['deliveryTax']?.toString(),
      increment: json['increment']?.toString(),
      compensation: json['compensation']?.toString(),
      discounts: json['discounts']?.toString(),
      requests: (json['requests'] as List?)
          ?.map((request) => request.toString())
          .toList(),
      observations: json['observations'] as String?,
      hasGoodsReceivingDocument: json['hasGoodsReceivingDocument'] as bool?,
      totalLiquid: number('totalLiquid'),
      totalBruteFromProductsAndServices: number(
        'totalBruteFromProductsAndServices',
      ),
      totalDiscount: number('totalDiscount'),
      totalCompensation: number('totalCompensation'),
      totalIncrement: number('totalIncrement'),
      totalDeliveryTax: number('totalDeliveryTax'),
      icmsAndIssBase: number('icmsAndIssBase'),
      icmsAndIssValue: number('icmsAndIssValue'),
      icmsSubstituteBase: number('icmsSubstituteBase'),
      icmsSubstituteValueOnFiscalNote: number(
        'icmsSubstituteValueOnFiscalNote',
      ),
      icmsSubstituteValueOnGnre: number('icmsSubstituteValueOnGnre'),
      fcpSubstituteValue: number('fcpSubstituteValue'),
      totalLiquidOfFreight: number('totalLiquidOfFreight'),
      totalSecurityOfFreight: number('totalSecurityOfFreight'),
      totalExpenseAccessory: number('totalExpenseAccessory'),
      ipiValue: number('ipiValue'),
      icmsValueAtDestiny: number('icmsValueAtDestiny'),
      icmsValueAtOrigin: number('icmsValueAtOrigin'),
      totalFundToCombatPovertyStateDestinyValue: number(
        'totalFundToCombatPovertyStateDestinyValue',
      ),
      totalCalculatedLiquid: number('totalCalculatedLiquid'),
      products: (json['products'] as List?)
          ?.map((item) => EcBuyMovementProductDtoModel.fromJson(item as Map))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'code': code,
    'isCancelled': isCancelled,
    'dateOfCancellation': dateOfCancellation?.toIso8601String(),
    'userOfCancellation': userOfCancellation == null
        ? null
        : EcBuyMovementUserDtoModel.fromEntity(userOfCancellation!).toJson(),
    'userOfEntrance': userOfEntrance == null
        ? null
        : EcBuyMovementUserDtoModel.fromEntity(userOfEntrance!).toJson(),
    'fiscalNoteType': fiscalNoteType == null
        ? null
        : EcBuyMovementFiscalNoteTypeDtoModel.fromEntity(
            fiscalNoteType!,
          ).toJson(),
    'enterprise': enterprise == null
        ? null
        : EcBuyMovementEnterpriseDtoModel.fromEntity(enterprise!).toJson(),
    'buyers': buyers
        ?.map((item) => EcBuyMovementBuyerDtoModel.fromEntity(item).toJson())
        .toList(),
    'supplier': supplier == null
        ? null
        : EcBuyMovementSupplierDtoModel.fromEntity(supplier!).toJson(),
    'documentNumber': documentNumber,
    'documentNumberComplement': documentNumberComplement,
    'dateOfCreation': dateOfCreation?.toIso8601String(),
    'dateOfEmission': dateOfEmission?.toIso8601String(),
    'dateOfEntrance': dateOfEntrance?.toIso8601String(),
    'deliveryTax': deliveryTax,
    'increment': increment,
    'compensation': compensation,
    'discounts': discounts,
    'requests': requests,
    'observations': observations,
    'hasGoodsReceivingDocument': hasGoodsReceivingDocument,
    'totalLiquid': totalLiquid,
    'totalBruteFromProductsAndServices': totalBruteFromProductsAndServices,
    'totalDiscount': totalDiscount,
    'totalCompensation': totalCompensation,
    'totalIncrement': totalIncrement,
    'totalDeliveryTax': totalDeliveryTax,
    'icmsAndIssBase': icmsAndIssBase,
    'icmsAndIssValue': icmsAndIssValue,
    'icmsSubstituteBase': icmsSubstituteBase,
    'icmsSubstituteValueOnFiscalNote': icmsSubstituteValueOnFiscalNote,
    'icmsSubstituteValueOnGnre': icmsSubstituteValueOnGnre,
    'fcpSubstituteValue': fcpSubstituteValue,
    'totalLiquidOfFreight': totalLiquidOfFreight,
    'totalSecurityOfFreight': totalSecurityOfFreight,
    'totalExpenseAccessory': totalExpenseAccessory,
    'ipiValue': ipiValue,
    'icmsValueAtDestiny': icmsValueAtDestiny,
    'icmsValueAtOrigin': icmsValueAtOrigin,
    'totalFundToCombatPovertyStateDestinyValue':
        totalFundToCombatPovertyStateDestinyValue,
    'totalCalculatedLiquid': totalCalculatedLiquid,
    'products': products
        ?.map((item) => EcBuyMovementProductDtoModel.fromEntity(item).toJson())
        .toList(),
  };

  factory EcBuyMovementDtoModel.fromEntity(EcBuyMovementDtoEntity entity) =>
      EcBuyMovementDtoModel(
        code: entity.code,
        isCancelled: entity.isCancelled,
        dateOfCancellation: entity.dateOfCancellation,
        userOfCancellation: entity.userOfCancellation,
        userOfEntrance: entity.userOfEntrance,
        fiscalNoteType: entity.fiscalNoteType,
        enterprise: entity.enterprise,
        buyers: entity.buyers,
        supplier: entity.supplier,
        documentNumber: entity.documentNumber,
        documentNumberComplement: entity.documentNumberComplement,
        dateOfCreation: entity.dateOfCreation,
        dateOfEmission: entity.dateOfEmission,
        dateOfEntrance: entity.dateOfEntrance,
        deliveryTax: entity.deliveryTax,
        increment: entity.increment,
        compensation: entity.compensation,
        discounts: entity.discounts,
        requests: entity.requests,
        observations: entity.observations,
        hasGoodsReceivingDocument: entity.hasGoodsReceivingDocument,
        totalLiquid: entity.totalLiquid,
        totalBruteFromProductsAndServices:
            entity.totalBruteFromProductsAndServices,
        totalDiscount: entity.totalDiscount,
        totalCompensation: entity.totalCompensation,
        totalIncrement: entity.totalIncrement,
        totalDeliveryTax: entity.totalDeliveryTax,
        icmsAndIssBase: entity.icmsAndIssBase,
        icmsAndIssValue: entity.icmsAndIssValue,
        icmsSubstituteBase: entity.icmsSubstituteBase,
        icmsSubstituteValueOnFiscalNote: entity.icmsSubstituteValueOnFiscalNote,
        icmsSubstituteValueOnGnre: entity.icmsSubstituteValueOnGnre,
        fcpSubstituteValue: entity.fcpSubstituteValue,
        totalLiquidOfFreight: entity.totalLiquidOfFreight,
        totalSecurityOfFreight: entity.totalSecurityOfFreight,
        totalExpenseAccessory: entity.totalExpenseAccessory,
        ipiValue: entity.ipiValue,
        icmsValueAtDestiny: entity.icmsValueAtDestiny,
        icmsValueAtOrigin: entity.icmsValueAtOrigin,
        totalFundToCombatPovertyStateDestinyValue:
            entity.totalFundToCombatPovertyStateDestinyValue,
        totalCalculatedLiquid: entity.totalCalculatedLiquid,
        products: entity.products,
      );

  EcBuyMovementDtoEntity toEntity() => EcBuyMovementDtoEntity(
    code: code,
    isCancelled: isCancelled,
    dateOfCancellation: dateOfCancellation,
    userOfCancellation: userOfCancellation == null
        ? null
        : EcBuyMovementUserDtoModel.fromEntity(userOfCancellation!).toEntity(),
    userOfEntrance: userOfEntrance == null
        ? null
        : EcBuyMovementUserDtoModel.fromEntity(userOfEntrance!).toEntity(),
    fiscalNoteType: fiscalNoteType == null
        ? null
        : EcBuyMovementFiscalNoteTypeDtoModel.fromEntity(
            fiscalNoteType!,
          ).toEntity(),
    enterprise: enterprise == null
        ? null
        : EcBuyMovementEnterpriseDtoModel.fromEntity(enterprise!).toEntity(),
    buyers: buyers
        ?.map((item) => EcBuyMovementBuyerDtoModel.fromEntity(item).toEntity())
        .toList(),
    supplier: supplier == null
        ? null
        : EcBuyMovementSupplierDtoModel.fromEntity(supplier!).toEntity(),
    documentNumber: documentNumber,
    documentNumberComplement: documentNumberComplement,
    dateOfCreation: dateOfCreation,
    dateOfEmission: dateOfEmission,
    dateOfEntrance: dateOfEntrance,
    deliveryTax: deliveryTax,
    increment: increment,
    compensation: compensation,
    discounts: discounts,
    requests: requests,
    observations: observations,
    hasGoodsReceivingDocument: hasGoodsReceivingDocument,
    totalLiquid: totalLiquid,
    totalBruteFromProductsAndServices: totalBruteFromProductsAndServices,
    totalDiscount: totalDiscount,
    totalCompensation: totalCompensation,
    totalIncrement: totalIncrement,
    totalDeliveryTax: totalDeliveryTax,
    icmsAndIssBase: icmsAndIssBase,
    icmsAndIssValue: icmsAndIssValue,
    icmsSubstituteBase: icmsSubstituteBase,
    icmsSubstituteValueOnFiscalNote: icmsSubstituteValueOnFiscalNote,
    icmsSubstituteValueOnGnre: icmsSubstituteValueOnGnre,
    fcpSubstituteValue: fcpSubstituteValue,
    totalLiquidOfFreight: totalLiquidOfFreight,
    totalSecurityOfFreight: totalSecurityOfFreight,
    totalExpenseAccessory: totalExpenseAccessory,
    ipiValue: ipiValue,
    icmsValueAtDestiny: icmsValueAtDestiny,
    icmsValueAtOrigin: icmsValueAtOrigin,
    totalFundToCombatPovertyStateDestinyValue:
        totalFundToCombatPovertyStateDestinyValue,
    totalCalculatedLiquid: totalCalculatedLiquid,
    products: products
        ?.map(
          (item) => EcBuyMovementProductDtoModel.fromEntity(item).toEntity(),
        )
        .toList(),
  );
}
