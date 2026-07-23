import 'package:celta_inventario/features/buy_movement/domain/entities/entities.dart';

class EcBuyMovementEnterpriseDtoModel extends EcBuyMovementEnterpriseDtoEntity {
  const EcBuyMovementEnterpriseDtoModel({
    required super.personalizedCode,
    required super.cnpjNumber,
    required super.name,
    required super.code,
  });

  factory EcBuyMovementEnterpriseDtoModel.fromJson(Map json) =>
      EcBuyMovementEnterpriseDtoModel(
        personalizedCode: json['personalizedCode']?.toString(),
        cnpjNumber: json['cnpjNumber']?.toString(),
        name: json['name'] as String?,
        code: json['code'] as int?,
      );

  Map<String, dynamic> toJson() => {
    'personalizedCode': personalizedCode,
    'cnpjNumber': cnpjNumber,
    'name': name,
    'code': code,
  };

  factory EcBuyMovementEnterpriseDtoModel.fromEntity(
    EcBuyMovementEnterpriseDtoEntity entity,
  ) => EcBuyMovementEnterpriseDtoModel(
    personalizedCode: entity.personalizedCode,
    cnpjNumber: entity.cnpjNumber,
    name: entity.name,
    code: entity.code,
  );

  EcBuyMovementEnterpriseDtoEntity toEntity() =>
      EcBuyMovementEnterpriseDtoEntity(
        personalizedCode: personalizedCode,
        cnpjNumber: cnpjNumber,
        name: name,
        code: code,
      );
}
