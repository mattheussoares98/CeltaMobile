import 'package:celta_inventario/features/buy_request/domain/entities/entities.dart';

class EcBuyRequestTypeDtoModel extends EcBuyRequestTypeDtoEntity {
  const EcBuyRequestTypeDtoModel({
    required super.code,
    required super.name,
    required super.personalizedCode,
  });

  factory EcBuyRequestTypeDtoModel.fromJson(Map json) {
    return EcBuyRequestTypeDtoModel(
      code: json['code'] as int?,
      name: json['name'] as String?,
      personalizedCode: json['personalizedCode'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'code': code, 'name': name, 'personalizedCode': personalizedCode};
  }

  factory EcBuyRequestTypeDtoModel.fromEntity(
    EcBuyRequestTypeDtoEntity entity,
  ) {
    return EcBuyRequestTypeDtoModel(
      code: entity.code,
      name: entity.name,
      personalizedCode: entity.personalizedCode,
    );
  }

  EcBuyRequestTypeDtoEntity toEntity() {
    return EcBuyRequestTypeDtoEntity(
      code: code,
      name: name,
      personalizedCode: personalizedCode,
    );
  }
}
