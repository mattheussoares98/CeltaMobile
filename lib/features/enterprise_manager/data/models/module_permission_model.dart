import 'package:equatable/equatable.dart';

import '../../domain/entities/entities.dart';

class ModulePermissionModel extends Equatable {
  final int id;
  final String moduleKey;
  final String name;
  final bool isEnabled;
  final bool isDefinedAtCnpjLevel;

  const ModulePermissionModel({
    required this.id,
    required this.moduleKey,
    required this.name,
    required this.isEnabled,
    required this.isDefinedAtCnpjLevel,
  });

  @override
  List<Object?> get props => [
    id,
    moduleKey,
    name,
    isEnabled,
    isDefinedAtCnpjLevel,
  ];

  factory ModulePermissionModel.fromJson(Map<String, dynamic> json) {
    return ModulePermissionModel(
      id: json['id'],
      moduleKey: json['module_key'],
      name: json['name'],
      isEnabled: json['is_enabled'],
      isDefinedAtCnpjLevel: json['is_defined_at_cnpj_level'],
    );
  }

  factory ModulePermissionModel.fromEntity(ModulePermissionEntity entity) {
    return ModulePermissionModel(
      id: entity.id,
      moduleKey: entity.moduleKey,
      name: entity.name,
      isEnabled: entity.isEnabled,
      isDefinedAtCnpjLevel: entity.isDefinedAtCnpjLevel,
    );
  }

  ModulePermissionEntity toEntity() {
    return ModulePermissionEntity(
      id: id,
      moduleKey: moduleKey,
      name: name,
      isEnabled: isEnabled,
      isDefinedAtCnpjLevel: isDefinedAtCnpjLevel,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'module_key': moduleKey,
    'name': name,
    'is_enabled': isEnabled,
    'is_defined_at_cnpj_level': isDefinedAtCnpjLevel,
  };
}
