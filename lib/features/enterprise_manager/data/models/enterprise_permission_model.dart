import 'package:equatable/equatable.dart';

import '../../domain/entities/entities.dart';
import 'models.dart';

class EnterprisePermissionModel extends Equatable {
  final int id;
  final String name;
  final String? remoteHttpUrl;
  final String? remoteHttpsUrl;
  final String? localHttpUrl;
  final String? localHttpsUrl;
  final List<ModulePermissionModel> globalModules;
  final List<SubEnterprisePermissionModel> subEnterprises;

  const EnterprisePermissionModel({
    required this.id,
    required this.name,
    required this.remoteHttpUrl,
    required this.remoteHttpsUrl,
    required this.localHttpUrl,
    required this.localHttpsUrl,
    required this.globalModules,
    required this.subEnterprises,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    remoteHttpUrl,
    remoteHttpsUrl,
    localHttpUrl,
    localHttpsUrl,
    subEnterprises,
    globalModules,
  ];

  factory EnterprisePermissionModel.fromJson(Map json) {
    return EnterprisePermissionModel(
      id: json['id'],
      name: json['name'],
      remoteHttpUrl: json['remote_http_url'],
      remoteHttpsUrl: json['remote_https_url'],
      localHttpUrl: json['local_http_url'],
      localHttpsUrl: json['local_https_url'],
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
      remoteHttpUrl: entity.remoteHttpUrl,
      remoteHttpsUrl: entity.remoteHttpsUrl,
      localHttpUrl: entity.localHttpUrl,
      localHttpsUrl: entity.localHttpsUrl,
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
      remoteHttpUrl: remoteHttpUrl,
      remoteHttpsUrl: remoteHttpsUrl,
      localHttpUrl: localHttpUrl,
      localHttpsUrl: localHttpsUrl,
      globalModules: globalModules.map((e) => e.toEntity()).toList(),
      subEnterprises: subEnterprises.map((e) => e.toEntity()).toList(),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'name': name,
    'remote_http_url': remoteHttpUrl,
    'remote_https_url': remoteHttpsUrl,
    'local_http_url': localHttpUrl,
    'local_https_url': localHttpsUrl,
    'global_enabled_modules': globalModules.map((e) => e.toJson()).toList(),
    'sub_enterprises': subEnterprises.map((e) => e.toJson()).toList(),
  };
}
