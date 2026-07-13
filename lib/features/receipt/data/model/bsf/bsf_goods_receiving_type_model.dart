import 'package:celta_inventario/features/receipt/domain/entity/entity.dart';

class BSFGoodsReceivingTypeModel extends BSFGoodsReceivingTypeEntity {
  const BSFGoodsReceivingTypeModel({super.code, super.name});

  factory BSFGoodsReceivingTypeModel.fromJson(Map<String, dynamic> json) =>
      BSFGoodsReceivingTypeModel(
        code: json['Code'],
        name: json['Name']?.toString(),
      );

  Map<String, dynamic> toJson() => {'Code': code, 'Name': name};

  factory BSFGoodsReceivingTypeModel.fromEntity(
    BSFGoodsReceivingTypeEntity entity,
  ) => BSFGoodsReceivingTypeModel(code: entity.code, name: entity.name);

  BSFGoodsReceivingTypeEntity toEntity() =>
      BSFGoodsReceivingTypeEntity(code: code, name: name);
}
