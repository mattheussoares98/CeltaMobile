import 'package:celta_inventario/core/domain/entities/entities.dart';

class BSFStateModel extends BSFStateEntity {
  const BSFStateModel({
    super.code,
    required super.acronym,
    required super.description,
    super.extensions,
    super.nationalSimpleLimitByStateForSmallCompany,
    super.containsValidNationalStateCode,
    super.nationalStateCode,
    super.isSignatoryDIFAL,
    super.isDoubleBaseDIFAL,
    super.isDIFALInOperationValue,
    super.icmsIncludedInPrice,
    super.icmsSubtractedInPrice,
    super.allowEmissionNFeByNFCe,
  });

  factory BSFStateModel.fromJson(Map json) => BSFStateModel(
        code: json['Code']?.toString(),
        acronym: json['Acronym'],
        description: json['Description'],
        extensions: json['Extensions'] != null
            ? Map<String, dynamic>.from(json['Extensions'])
            : null,
        nationalSimpleLimitByStateForSmallCompany:
            json['NationalSimpleLimitByStateForSmallCompany']?.toDouble(),
        containsValidNationalStateCode: json['ContainsValidNationalStateCode'],
        nationalStateCode: json['NationalStateCode'],
        isSignatoryDIFAL: json['IsSignatoryDIFAL'],
        isDoubleBaseDIFAL: json['IsDoubleBaseDIFAL'],
        isDIFALInOperationValue: json['IsDIFALInOperationValue'],
        icmsIncludedInPrice: json['IcmsIncludedInPrice'],
        icmsSubtractedInPrice: json['IcmsSubtractedInPrice'],
        allowEmissionNFeByNFCe: json['AllowEmissionNFeByNFCe'],
      );

  Map<String, dynamic> toJson() => {
        'Code': code,
        'Acronym': acronym,
        'Description': description,
        'Extensions': extensions,
        'NationalSimpleLimitByStateForSmallCompany':
            nationalSimpleLimitByStateForSmallCompany,
        'ContainsValidNationalStateCode': containsValidNationalStateCode,
        'NationalStateCode': nationalStateCode,
        'IsSignatoryDIFAL': isSignatoryDIFAL,
        'IsDoubleBaseDIFAL': isDoubleBaseDIFAL,
        'IsDIFALInOperationValue': isDIFALInOperationValue,
        'IcmsIncludedInPrice': icmsIncludedInPrice,
        'IcmsSubtractedInPrice': icmsSubtractedInPrice,
        'AllowEmissionNFeByNFCe': allowEmissionNFeByNFCe,
      };

  factory BSFStateModel.fromEntity(BSFStateEntity entity) => BSFStateModel(
        code: entity.code,
        acronym: entity.acronym,
        description: entity.description,
        extensions: entity.extensions,
        nationalSimpleLimitByStateForSmallCompany:
            entity.nationalSimpleLimitByStateForSmallCompany,
        containsValidNationalStateCode: entity.containsValidNationalStateCode,
        nationalStateCode: entity.nationalStateCode,
        isSignatoryDIFAL: entity.isSignatoryDIFAL,
        isDoubleBaseDIFAL: entity.isDoubleBaseDIFAL,
        isDIFALInOperationValue: entity.isDIFALInOperationValue,
        icmsIncludedInPrice: entity.icmsIncludedInPrice,
        icmsSubtractedInPrice: entity.icmsSubtractedInPrice,
        allowEmissionNFeByNFCe: entity.allowEmissionNFeByNFCe,
      );

  BSFStateEntity toEntity() => BSFStateEntity(
        code: code,
        acronym: acronym,
        description: description,
        extensions: extensions,
        nationalSimpleLimitByStateForSmallCompany:
            nationalSimpleLimitByStateForSmallCompany,
        containsValidNationalStateCode: containsValidNationalStateCode,
        nationalStateCode: nationalStateCode,
        isSignatoryDIFAL: isSignatoryDIFAL,
        isDoubleBaseDIFAL: isDoubleBaseDIFAL,
        isDIFALInOperationValue: isDIFALInOperationValue,
        icmsIncludedInPrice: icmsIncludedInPrice,
        icmsSubtractedInPrice: icmsSubtractedInPrice,
        allowEmissionNFeByNFCe: allowEmissionNFeByNFCe,
      );
}
