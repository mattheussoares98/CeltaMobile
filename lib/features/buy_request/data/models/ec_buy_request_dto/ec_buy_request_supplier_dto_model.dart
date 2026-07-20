import 'package:celta_inventario/features/buy_request/domain/entities/entities.dart';

class EcBuyRequestSupplierDtoModel extends EcBuyRequestSupplierDtoEntity {
  const EcBuyRequestSupplierDtoModel({
    required super.code,
    required super.name,
    required super.fantasizesName,
    required super.suframaCode,
    required super.cnpjCpfNumber,
    required super.formatedCnpjCpfNumber,
    required super.inscriptionRgNumber,
  });

  factory EcBuyRequestSupplierDtoModel.fromJson(Map json) {
    return EcBuyRequestSupplierDtoModel(
      code: json['code'] as int?,
      name: json['name'] as String?,
      fantasizesName: json['fantasizesName'] as String?,
      suframaCode: json['suframaCode']?.toString(),
      cnpjCpfNumber: json['cnpjCpfNumber']?.toString(),
      formatedCnpjCpfNumber: json['formatedCnpjCpfNumber'] as String?,
      inscriptionRgNumber: json['inscriptionRgNumber']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'fantasizesName': fantasizesName,
      'suframaCode': suframaCode,
      'cnpjCpfNumber': cnpjCpfNumber,
      'formatedCnpjCpfNumber': formatedCnpjCpfNumber,
      'inscriptionRgNumber': inscriptionRgNumber,
    };
  }

  factory EcBuyRequestSupplierDtoModel.fromEntity(
    EcBuyRequestSupplierDtoEntity entity,
  ) {
    return EcBuyRequestSupplierDtoModel(
      code: entity.code,
      name: entity.name,
      fantasizesName: entity.fantasizesName,
      suframaCode: entity.suframaCode,
      cnpjCpfNumber: entity.cnpjCpfNumber,
      formatedCnpjCpfNumber: entity.formatedCnpjCpfNumber,
      inscriptionRgNumber: entity.inscriptionRgNumber,
    );
  }

  EcBuyRequestSupplierDtoEntity toEntity() {
    return EcBuyRequestSupplierDtoEntity(
      code: code,
      name: name,
      fantasizesName: fantasizesName,
      suframaCode: suframaCode,
      cnpjCpfNumber: cnpjCpfNumber,
      formatedCnpjCpfNumber: formatedCnpjCpfNumber,
      inscriptionRgNumber: inscriptionRgNumber,
    );
  }
}
