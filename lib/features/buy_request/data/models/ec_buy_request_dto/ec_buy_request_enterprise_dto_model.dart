import 'package:celta_inventario/features/buy_request/domain/entities/entities.dart';

class EcBuyRequestEnterpriseDtoModel extends EcBuyRequestEnterpriseDtoEntity {
  const EcBuyRequestEnterpriseDtoModel({
    required super.personalizedCode,
    required super.cnpjNumber,
    required super.name,
    required super.code,
  });

  factory EcBuyRequestEnterpriseDtoModel.fromJson(Map json) {
    return EcBuyRequestEnterpriseDtoModel(
      personalizedCode: json['personalizedCode']?.toString(),
      cnpjNumber: json['cnpjNumber']?.toString(),
      name: json['name'] as String?,
      code: json['code'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'personalizedCode': personalizedCode,
      'cnpjNumber': cnpjNumber,
      'name': name,
      'code': code,
    };
  }

  factory EcBuyRequestEnterpriseDtoModel.fromEntity(
    EcBuyRequestEnterpriseDtoEntity entity,
  ) {
    return EcBuyRequestEnterpriseDtoModel(
      personalizedCode: entity.personalizedCode,
      cnpjNumber: entity.cnpjNumber,
      name: entity.name,
      code: entity.code,
    );
  }

  EcBuyRequestEnterpriseDtoEntity toEntity() {
    return EcBuyRequestEnterpriseDtoEntity(
      personalizedCode: personalizedCode,
      cnpjNumber: cnpjNumber,
      name: name,
      code: code,
    );
  }
}
