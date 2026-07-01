// lib/features/process_authorization/data/models/bsf_authorization_process_item_model.dart
import 'package:celta_inventario/features/process_authorization/data/models/models.dart';
import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';

class BSFAuthorizationProcessItemModel extends BSFAuthorizationProcessItemEntity {
  const BSFAuthorizationProcessItemModel({
    super.code,
    super.name,
    super.description,
    super.type,
    super.category,
  });

  factory BSFAuthorizationProcessItemModel.fromJson(Map json) =>
      BSFAuthorizationProcessItemModel(
        code: json['Code'],
        name: json['Name']?.toString(),
        description: json['Description']?.toString(),
        type: BSFAuthorizationProcessItemType.fromValue(json['Type']),
        category: json['Category'] != null
            ? BSFAuthorizationProcessCategoryModel.fromJson(json['Category'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        'Code': code,
        'Name': name,
        'Description': description,
        'Type': type?.value,
        'Category': category != null
            ? BSFAuthorizationProcessCategoryModel.fromEntity(category!).toJson()
            : null,
      };

  factory BSFAuthorizationProcessItemModel.fromEntity(
          BSFAuthorizationProcessItemEntity entity) =>
      BSFAuthorizationProcessItemModel(
        code: entity.code,
        name: entity.name,
        description: entity.description,
        type: entity.type,
        category: entity.category,
      );

  BSFAuthorizationProcessItemEntity toEntity() =>
      BSFAuthorizationProcessItemEntity(
        code: code,
        name: name,
        description: description,
        type: type,
        category: category,
      );
}
