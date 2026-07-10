// lib/features/process_authorization/data/models/bsf_authorization_process_item_model.dart
import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';

class BSFProcessAuthorizationItemModel
    extends BSFProcessAuthorizationItemEntity {
  const BSFProcessAuthorizationItemModel({
    super.code,
    super.name,
    super.description,
    super.type,
    // super.category,
    super.typeAccordingToTheCode,
  });

  factory BSFProcessAuthorizationItemModel.fromJson(Map json) =>
      BSFProcessAuthorizationItemModel(
        code: json['Code'],
        typeAccordingToTheCode: TypeAccordingToTheCode.fromCode(json['Code']),
        name: json['Name']?.toString(),
        description: json['Description']?.toString(),
        type: BSFProcessAuthorizationItemType.fromValue(json['Type']),
        // category: json['Category']?['Code'] != null
        //     ? BSFProcessAuthorizationCategoryType.fromCode(
        //         json['Category']?['Code'],
        //       )
        //     : null,
      );

  Map<String, dynamic> toJson() => {
    'Code': code,
    'Name': name,
    'Description': description,
    'Type': type?.value,
    // 'Category': {'Code': category?.code},
  };

  factory BSFProcessAuthorizationItemModel.fromEntity(
    BSFProcessAuthorizationItemEntity entity,
  ) => BSFProcessAuthorizationItemModel(
    code: entity.code,
    name: entity.name,
    description: entity.description,
    type: entity.type,
    typeAccordingToTheCode: entity.typeAccordingToTheCode,
  );

  BSFProcessAuthorizationItemEntity toEntity() =>
      BSFProcessAuthorizationItemEntity(
        code: code,
        name: name,
        description: description,
        type: type,
        typeAccordingToTheCode: typeAccordingToTheCode,
      );
}
