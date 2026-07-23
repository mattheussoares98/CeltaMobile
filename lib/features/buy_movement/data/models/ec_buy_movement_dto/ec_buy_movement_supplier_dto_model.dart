import 'package:celta_inventario/features/buy_movement/domain/entities/entities.dart';

class EcBuyMovementSupplierDtoModel extends EcBuyMovementSupplierDtoEntity {
  const EcBuyMovementSupplierDtoModel({
    required super.code,
    required super.name,
    required super.fantasizesName,
    required super.suframaCode,
    required super.cnpjCpfNumber,
    required super.formatedCnpjCpfNumber,
    required super.inscriptionRgNumber,
  });

  factory EcBuyMovementSupplierDtoModel.fromJson(Map json) =>
      EcBuyMovementSupplierDtoModel(
        code: json['code'] as int?,
        name: json['name'] as String?,
        fantasizesName: json['fantasizesName'] as String?,
        suframaCode: json['suframaCode']?.toString(),
        cnpjCpfNumber: json['cnpjCpfNumber']?.toString(),
        formatedCnpjCpfNumber: json['formatedCnpjCpfNumber'] as String?,
        inscriptionRgNumber: json['inscriptionRgNumber']?.toString(),
      );

  Map<String, dynamic> toJson() => {
    'code': code,
    'name': name,
    'fantasizesName': fantasizesName,
    'suframaCode': suframaCode,
    'cnpjCpfNumber': cnpjCpfNumber,
    'formatedCnpjCpfNumber': formatedCnpjCpfNumber,
    'inscriptionRgNumber': inscriptionRgNumber,
  };

  factory EcBuyMovementSupplierDtoModel.fromEntity(
    EcBuyMovementSupplierDtoEntity entity,
  ) => EcBuyMovementSupplierDtoModel(
    code: entity.code,
    name: entity.name,
    fantasizesName: entity.fantasizesName,
    suframaCode: entity.suframaCode,
    cnpjCpfNumber: entity.cnpjCpfNumber,
    formatedCnpjCpfNumber: entity.formatedCnpjCpfNumber,
    inscriptionRgNumber: entity.inscriptionRgNumber,
  );

  EcBuyMovementSupplierDtoEntity toEntity() => EcBuyMovementSupplierDtoEntity(
    code: code,
    name: name,
    fantasizesName: fantasizesName,
    suframaCode: suframaCode,
    cnpjCpfNumber: cnpjCpfNumber,
    formatedCnpjCpfNumber: formatedCnpjCpfNumber,
    inscriptionRgNumber: inscriptionRgNumber,
  );
}
