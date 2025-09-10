import 'package:equatable/equatable.dart';

import '../../domain/entities/entities.dart';
import 'models.dart';

class EnterprisePermissionModel extends Equatable {
  final int id;
  final String name;
  final String baseUrl;
  final List<String> globalEnabledModules;
  final List<SubEnterprisePermissionModel> subEnterprises;

  const EnterprisePermissionModel({
    required this.id,
    required this.name,
    required this.baseUrl,
    required this.globalEnabledModules,
    required this.subEnterprises,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    baseUrl,
    subEnterprises,
    globalEnabledModules,
  ];

  factory EnterprisePermissionModel.fromJson(Map<String, dynamic> json) {
    return EnterprisePermissionModel(
      id: json['id'],
      name: json['name'],
      baseUrl: json['base_url'],
      globalEnabledModules: (json['global_enabled_modules'] as List).isEmpty
          ? []
          : json['global_enabled_modules'],
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
      baseUrl: entity.baseUrl,
      globalEnabledModules: entity.globalEnabledModules,
      subEnterprises: entity.subEnterprises
          .map((e) => SubEnterprisePermissionModel.fromEntity(e))
          .toList(),
    );
  }

  EnterprisePermissionEntity toEntity() {
    return EnterprisePermissionEntity(
      id: id,
      name: name,
      baseUrl: baseUrl,
      globalEnabledModules: globalEnabledModules,
      subEnterprises: subEnterprises.map((e) => e.toEntity()).toList(),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'name': name,
    'base_url': baseUrl,
    'global_enabled_modules': globalEnabledModules,
    'sub_enterprises': subEnterprises.map((e) => e.toJson()).toList(),
  };
}
