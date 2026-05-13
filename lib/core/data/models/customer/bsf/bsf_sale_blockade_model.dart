import '../../../../../core/domain/entities/entities.dart';

class BsfSaleBlockadeModel extends BsfSaleBlockadeEntity {
  const BsfSaleBlockadeModel({
    required super.code,
    required super.personalizedCode,
    required super.legacyCode,
    required super.description,
    required super.allowSale,
    required super.allowSaleRequest,
    required super.allowSaleWithPaymentFinalizationTypeCheckOrPortion,
    required super.stringAllowSale,
    required super.stringAllowSaleRequest,
    required super.stringAllowSaleWithPaymentFinalizationTypeCheckOrPortion,
  });

  factory BsfSaleBlockadeModel.fromJson(Map<String, dynamic> json) =>
      BsfSaleBlockadeModel(
        code: json['Code'] as int?,
        personalizedCode: json['PersonalizedCode'] as String?,
        legacyCode: json['LegacyCode'] as String?,
        description: json['Description'] as String?,
        allowSale: json['AllowSale'] as bool?,
        allowSaleRequest: json['AllowSaleRequest'] as bool?,
        allowSaleWithPaymentFinalizationTypeCheckOrPortion:
            json['AllowSaleWithPaymentFinalizationTypeCheckOrPortion'] as bool?,
        stringAllowSale: json['StringAllowSale'] as String?,
        stringAllowSaleRequest: json['StringAllowSaleRequest'] as String?,
        stringAllowSaleWithPaymentFinalizationTypeCheckOrPortion:
            json['StringAllowSaleWithPaymentFinalizationTypeCheckOrPortion']
                as String?,
      );

  Map<String, dynamic> toJson() => {
        'Code': code,
        'PersonalizedCode': personalizedCode,
        'LegacyCode': legacyCode,
        'Description': description,
        'AllowSale': allowSale,
        'AllowSaleRequest': allowSaleRequest,
        'AllowSaleWithPaymentFinalizationTypeCheckOrPortion':
            allowSaleWithPaymentFinalizationTypeCheckOrPortion,
        'StringAllowSale': stringAllowSale,
        'StringAllowSaleRequest': stringAllowSaleRequest,
        'StringAllowSaleWithPaymentFinalizationTypeCheckOrPortion':
            stringAllowSaleWithPaymentFinalizationTypeCheckOrPortion,
      };

  factory BsfSaleBlockadeModel.fromEntity(BsfSaleBlockadeEntity entity) =>
      BsfSaleBlockadeModel(
        code: entity.code,
        personalizedCode: entity.personalizedCode,
        legacyCode: entity.legacyCode,
        description: entity.description,
        allowSale: entity.allowSale,
        allowSaleRequest: entity.allowSaleRequest,
        allowSaleWithPaymentFinalizationTypeCheckOrPortion:
            entity.allowSaleWithPaymentFinalizationTypeCheckOrPortion,
        stringAllowSale: entity.stringAllowSale,
        stringAllowSaleRequest: entity.stringAllowSaleRequest,
        stringAllowSaleWithPaymentFinalizationTypeCheckOrPortion:
            entity.stringAllowSaleWithPaymentFinalizationTypeCheckOrPortion,
      );

  BsfSaleBlockadeEntity toEntity() => BsfSaleBlockadeEntity(
        code: code,
        personalizedCode: personalizedCode,
        legacyCode: legacyCode,
        description: description,
        allowSale: allowSale,
        allowSaleRequest: allowSaleRequest,
        allowSaleWithPaymentFinalizationTypeCheckOrPortion:
            allowSaleWithPaymentFinalizationTypeCheckOrPortion,
        stringAllowSale: stringAllowSale,
        stringAllowSaleRequest: stringAllowSaleRequest,
        stringAllowSaleWithPaymentFinalizationTypeCheckOrPortion:
            stringAllowSaleWithPaymentFinalizationTypeCheckOrPortion,
      );
}
