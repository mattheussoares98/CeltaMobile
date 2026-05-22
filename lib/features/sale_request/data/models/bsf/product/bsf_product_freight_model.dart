import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/data/models/bsf/bsf.dart';

class BSFProductFreightModel extends BSFProductFreightEntity {
  const BSFProductFreightModel({
    required super.discount,
    required super.increment,
    required super.value,
  });

  @override
  List<Object?> get props => [discount, increment, value];

  factory BSFProductFreightModel.fromJson(Map<String, dynamic> json) =>
      BSFProductFreightModel(
        discount: json['Discount'] != null
            ? BSFValueTypeModel.fromJson(json['Discount'])
            : null,
        increment: json['Increment'] != null
            ? BSFValueTypeModel.fromJson(json['Increment'])
            : null,
        value: (json['Value'] as num?)?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
    'Discount': (discount as BSFValueTypeModel?)?.toJson(),
    'Increment': (increment as BSFValueTypeModel?)?.toJson(),
    'Value': value,
  };

  factory BSFProductFreightModel.fromEntity(BSFProductFreightEntity entity) =>
      BSFProductFreightModel(
        discount: entity.discount == null
            ? null
            : BSFValueTypeModel.fromEntity(entity.discount!),
        increment: entity.increment == null
            ? null
            : BSFValueTypeModel.fromEntity(entity.increment!),
        value: entity.value,
      );

  BSFProductFreightEntity toEntity() => BSFProductFreightEntity(
    discount: (discount as BSFValueTypeModel?)?.toEntity(),
    increment: (increment as BSFValueTypeModel?)?.toEntity(),
    value: value,
  );
}
