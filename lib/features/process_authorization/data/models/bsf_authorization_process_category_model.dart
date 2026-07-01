// lib/features/process_authorization/data/models/bsf_authorization_process_category_model.dart
import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';

class BSFAuthorizationProcessCategoryModel extends BSFAuthorizationProcessCategoryEntity {
  const BSFAuthorizationProcessCategoryModel({
    super.code,
    super.name,
  });

  factory BSFAuthorizationProcessCategoryModel.fromJson(Map json) =>
      BSFAuthorizationProcessCategoryModel(
        code: json['Code'],
        name: json['Name']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        'Code': code,
        'Name': name,
      };

  factory BSFAuthorizationProcessCategoryModel.fromEntity(
          BSFAuthorizationProcessCategoryEntity entity) =>
      BSFAuthorizationProcessCategoryModel(
        code: entity.code,
        name: entity.name,
      );

  BSFAuthorizationProcessCategoryEntity toEntity() =>
      BSFAuthorizationProcessCategoryEntity(
        code: code,
        name: name,
      );
}
