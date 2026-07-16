import 'package:celta_inventario/features/receipt/domain/entity/entity.dart';

class BSFGRTypeModel extends BSFGRTypeEntity {
  const BSFGRTypeModel({super.code, super.name});

  factory BSFGRTypeModel.fromJson(Map<String, dynamic> json) =>
      BSFGRTypeModel(code: json['Code'], name: json['Name']?.toString());

  Map<String, dynamic> toJson() => {'Code': code, 'Name': name};

  factory BSFGRTypeModel.fromEntity(BSFGRTypeEntity entity) =>
      BSFGRTypeModel(code: entity.code, name: entity.name);

  BSFGRTypeEntity toEntity() => BSFGRTypeEntity(code: code, name: name);
}
