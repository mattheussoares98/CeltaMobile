// lib/core/data/models/eletronic_access_key/bsf/bsf_eletronic_access_key_model.dart
import 'package:celta_inventario/core/domain/entities/entities.dart';

class BSFEletronicAccessKeyModel extends BSFEletronicAccessKeyEntity {
  const BSFEletronicAccessKeyModel({
    super.stateCode,
    super.stateDescription,
    super.emission,
    super.year,
    super.month,
    super.cnpjEmitter,
    super.fiscalNoteNumber,
    super.documentType,
    super.documentTypeCode,
    super.fiscalNoteSerial,
    super.fiscalNoteSerialString,
    super.emissionType,
    super.emissionTypeCode,
    super.codeRandomToNfeV2,
    super.codeRandomComplete,
    super.digit,
  });

  factory BSFEletronicAccessKeyModel.fromJson(Map<String, dynamic> json) =>
      BSFEletronicAccessKeyModel(
        stateCode: json['StateCode'],
        stateDescription: json['StateDescription']?.toString(),
        emission: json['Emission']?.toString(),
        year: json['Year'],
        month: json['Month'],
        cnpjEmitter: json['CnpjEmitter']?.toString(),
        fiscalNoteNumber: json['FiscalNoteNumber'],
        documentType: json['DocumentType'],
        documentTypeCode: json['DocumentTypeCode'],
        fiscalNoteSerial: json['FiscalNoteSerial'],
        fiscalNoteSerialString: json['FiscalNoteSerialString']?.toString(),
        emissionType: json['EmissionType'],
        emissionTypeCode: json['EmissionTypeCode'],
        codeRandomToNfeV2: json['CodeRandomToNfeV2'],
        codeRandomComplete: json['CodeRandomComplete'],
        digit: json['Digit'],
      );

  Map<String, dynamic> toJson() => {
        'StateCode': stateCode,
        'StateDescription': stateDescription,
        'Emission': emission,
        'Year': year,
        'Month': month,
        'CnpjEmitter': cnpjEmitter,
        'FiscalNoteNumber': fiscalNoteNumber,
        'DocumentType': documentType,
        'DocumentTypeCode': documentTypeCode,
        'FiscalNoteSerial': fiscalNoteSerial,
        'FiscalNoteSerialString': fiscalNoteSerialString,
        'EmissionType': emissionType,
        'EmissionTypeCode': emissionTypeCode,
        'CodeRandomToNfeV2': codeRandomToNfeV2,
        'CodeRandomComplete': codeRandomComplete,
        'Digit': digit,
      };

  factory BSFEletronicAccessKeyModel.fromEntity(
          BSFEletronicAccessKeyEntity entity) =>
      BSFEletronicAccessKeyModel(
        stateCode: entity.stateCode,
        stateDescription: entity.stateDescription,
        emission: entity.emission,
        year: entity.year,
        month: entity.month,
        cnpjEmitter: entity.cnpjEmitter,
        fiscalNoteNumber: entity.fiscalNoteNumber,
        documentType: entity.documentType,
        documentTypeCode: entity.documentTypeCode,
        fiscalNoteSerial: entity.fiscalNoteSerial,
        fiscalNoteSerialString: entity.fiscalNoteSerialString,
        emissionType: entity.emissionType,
        emissionTypeCode: entity.emissionTypeCode,
        codeRandomToNfeV2: entity.codeRandomToNfeV2,
        codeRandomComplete: entity.codeRandomComplete,
        digit: entity.digit,
      );
}
