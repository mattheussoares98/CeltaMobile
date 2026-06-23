import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:collection/collection.dart';

class BSFValueTypeModel extends BSFValueTypeEntity {
  const BSFValueTypeModel({required super.type, required super.value});

  factory BSFValueTypeModel.fromJson(Map json) => BSFValueTypeModel(
    type: PercentageOrValue.values.firstWhereOrNull(
      (e) => e.code == json['Type'],
    ),
    value: (json['Value'] as num?)?.toDouble(),
  );

  Map<String, dynamic> toJson() => {'Type': type?.code, 'Value': value};

  factory BSFValueTypeModel.fromEntity(BSFValueTypeEntity entity) =>
      BSFValueTypeModel(type: entity.type, value: entity.value);

  BSFValueTypeEntity toEntity() => BSFValueTypeEntity(type: type, value: value);
}
