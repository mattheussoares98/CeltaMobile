import 'package:celta_inventario/features/receipt/domain/entity/entity.dart';

class BSFGoodsReceivingGroupModel extends BSFGoodsReceivingGroupEntity {
  const BSFGoodsReceivingGroupModel({
    required super.code,
    required super.personalizedCode,
  });

  factory BSFGoodsReceivingGroupModel.fromJson(Map json) =>
      BSFGoodsReceivingGroupModel(
        code: json['Code'],
        personalizedCode: json['PersonalizedCode'],
      );

  Map<String, dynamic> toJson() => {
    'Code': code,
    'PersonalizedCode': personalizedCode,
  };

  factory BSFGoodsReceivingGroupModel.fromEntity(
    BSFGoodsReceivingGroupEntity entity,
  ) => BSFGoodsReceivingGroupModel(
    code: entity.code,
    personalizedCode: entity.personalizedCode,
  );

  BSFGoodsReceivingGroupEntity toEntity() => BSFGoodsReceivingGroupEntity(
    code: code,
    personalizedCode: personalizedCode,
  );
}
