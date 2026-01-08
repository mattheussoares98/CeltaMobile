import 'package:equatable/equatable.dart';

import '../../domain/entities/entities.dart';
import 'models.dart';

class EnterprisePermissionModel extends Equatable {
  final int id;
  final String name;
  final String urlInUse;
  final List<ModulePermissionModel> globalModules;
  final List<SubEnterprisePermissionModel> subEnterprises;

  const EnterprisePermissionModel({
    required this.id,
    required this.name,
    required this.urlInUse,
    required this.globalModules,
    required this.subEnterprises,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    urlInUse,
    subEnterprises,
    globalModules,
  ];

  factory EnterprisePermissionModel.fromJson(Map json) {
    return EnterprisePermissionModel(
      id: json['id'],
      name: json['name'],
      urlInUse: json['base_url'],
      globalModules: (json['global_enabled_modules'] as List)
          .map((item) => ModulePermissionModel.fromJson(item))
          .toList(),
      subEnterprises: (json['sub_enterprises'] as List)
          .map((item) => SubEnterprisePermissionModel.fromJson(item))
          .toList(),
    );
  }

  factory EnterprisePermissionModel.fromEntity(
    EnterprisePermissionEntity entity,
  ) {
    return EnterprisePermissionModel(
      id: entity.id,
      name: entity.name,
      urlInUse: entity.urlInUse,
      globalModules: entity.globalModules
          .map((e) => ModulePermissionModel.fromEntity(e))
          .toList(),
      subEnterprises: entity.subEnterprises
          .map((e) => SubEnterprisePermissionModel.fromEntity(e))
          .toList(),
    );
  }

  EnterprisePermissionEntity toEntity() {
    return EnterprisePermissionEntity(
      id: id,
      name: name,
      urlInUse: urlInUse,
      globalModules: globalModules.map((e) => e.toEntity()).toList(),
      subEnterprises: subEnterprises.map((e) => e.toEntity()).toList(),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'name': name,
    'base_url': urlInUse,
    'global_enabled_modules': globalModules.map((e) => e.toJson()).toList(),
    'sub_enterprises': subEnterprises.map((e) => e.toJson()).toList(),
  };
}
