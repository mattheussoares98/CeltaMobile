import 'package:celta_inventario/features/receipt/domain/entity/entity.dart';

class BSFGRGroupModel extends BSFGRGroupEntity {
  const BSFGRGroupModel({required super.code, required super.personalizedCode});

  factory BSFGRGroupModel.fromJson(Map json) => BSFGRGroupModel(
    code: json['Code'],
    personalizedCode: json['PersonalizedCode'],
  );

  Map<String, dynamic> toJson() => {
    'Code': code,
    'PersonalizedCode': personalizedCode,
  };

  factory BSFGRGroupModel.fromEntity(BSFGRGroupEntity entity) =>
      BSFGRGroupModel(
        code: entity.code,
        personalizedCode: entity.personalizedCode,
      );

  BSFGRGroupEntity toEntity() =>
      BSFGRGroupEntity(code: code, personalizedCode: personalizedCode);
}
