import 'package:celta_inventario/features/buy_movement/domain/entities/entities.dart';

class EcBuyMovementUserDtoModel extends EcBuyMovementUserDtoEntity {
  const EcBuyMovementUserDtoModel({required super.code, required super.name});

  factory EcBuyMovementUserDtoModel.fromJson(Map json) =>
      EcBuyMovementUserDtoModel(
        code: json['code'] as int?,
        name: json['name'] as String?,
      );

  Map<String, dynamic> toJson() => {'code': code, 'name': name};

  factory EcBuyMovementUserDtoModel.fromEntity(
    EcBuyMovementUserDtoEntity entity,
  ) => EcBuyMovementUserDtoModel(code: entity.code, name: entity.name);

  EcBuyMovementUserDtoEntity toEntity() =>
      EcBuyMovementUserDtoEntity(code: code, name: name);
}
