// lib/features/process_authorization/data/models/bsf_authorization_process_category_model.dart
import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';

class BSFProcessAuthorizationCategoryModel
    extends BSFProcessAuthorizationCategoryEntity {
  const BSFProcessAuthorizationCategoryModel({super.code, super.name});

  factory BSFProcessAuthorizationCategoryModel.fromJson(Map json) =>
      BSFProcessAuthorizationCategoryModel(
        code: json['Code'],
        name: json['Name']?.toString(),
      );

  Map<String, dynamic> toJson() => {'Code': code, 'Name': name};

  factory BSFProcessAuthorizationCategoryModel.fromEntity(
    BSFProcessAuthorizationCategoryEntity entity,
  ) => BSFProcessAuthorizationCategoryModel(
    code: entity.code,
    name: entity.name,
  );

  BSFProcessAuthorizationCategoryEntity toEntity() =>
      BSFProcessAuthorizationCategoryEntity(code: code, name: name);
}
