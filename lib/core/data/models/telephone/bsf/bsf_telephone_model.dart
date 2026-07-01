// lib/core/data/models/telephone/bsf/bsf_telephone_model.dart
import 'package:celta_inventario/core/domain/entities/entities.dart';

class BSFTelephoneModel extends BSFTelephoneEntity {
  const BSFTelephoneModel({
    super.code,
    super.customerCode,
    super.areaCode,
    super.phoneNumber,
    super.phoneComplement,
    super.telephoneExtension,
    super.name,
    super.mainPhone,
    super.phoneType,
    super.isValid,
    super.isWellFormatted,
    super.areaCodeIsRequired,
  });

  factory BSFTelephoneModel.fromJson(Map json) => BSFTelephoneModel(
        code: json['Code'],
        customerCode: json['CustomerCode'],
        areaCode: json['AreaCode']?.toString(),
        phoneNumber: json['PhoneNumber']?.toString(),
        phoneComplement: json['PhoneComplement']?.toString(),
        telephoneExtension: json['TelephoneExtension']?.toString(),
        name: json['Name']?.toString(),
        mainPhone: json['MainPhone'],
        phoneType: json['PhoneType'],
        isValid: json['IsValid'],
        isWellFormatted: json['IsWellFormatted'],
        areaCodeIsRequired: json['AreaCodeIsRequired'],
      );

  Map<String, dynamic> toJson() => {
        'Code': code,
        'CustomerCode': customerCode,
        'AreaCode': areaCode,
        'PhoneNumber': phoneNumber,
        'PhoneComplement': phoneComplement,
        'TelephoneExtension': telephoneExtension,
        'Name': name,
        'MainPhone': mainPhone,
        'PhoneType': phoneType,
        'IsValid': isValid,
        'IsWellFormatted': isWellFormatted,
        'AreaCodeIsRequired': areaCodeIsRequired,
      };

  factory BSFTelephoneModel.fromEntity(BSFTelephoneEntity entity) =>
      BSFTelephoneModel(
        code: entity.code,
        customerCode: entity.customerCode,
        areaCode: entity.areaCode,
        phoneNumber: entity.phoneNumber,
        phoneComplement: entity.phoneComplement,
        telephoneExtension: entity.telephoneExtension,
        name: entity.name,
        mainPhone: entity.mainPhone,
        phoneType: entity.phoneType,
        isValid: entity.isValid,
        isWellFormatted: entity.isWellFormatted,
        areaCodeIsRequired: entity.areaCodeIsRequired,
      );

  BSFTelephoneEntity toEntity() => BSFTelephoneEntity(
        code: code,
        customerCode: customerCode,
        areaCode: areaCode,
        phoneNumber: phoneNumber,
        phoneComplement: phoneComplement,
        telephoneExtension: telephoneExtension,
        name: name,
        mainPhone: mainPhone,
        phoneType: phoneType,
        isValid: isValid,
        isWellFormatted: isWellFormatted,
        areaCodeIsRequired: areaCodeIsRequired,
      );
}
