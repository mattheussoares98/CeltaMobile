import 'package:equatable/equatable.dart';

import 'package:celta_inventario/features/enterprise_manager/domain/entities/entities.dart';

class EnterprisePermissionEntity extends Equatable {
  final int id;
  final String name;
  final String? remoteHttpUrl;
  final String? remoteHttpsUrl;
  final String? localHttpUrl;
  final String? localHttpsUrl;
  final List<ModulePermissionEntity> globalModules;
  final List<SubEnterprisePermissionEntity> subEnterprises;

  const EnterprisePermissionEntity({
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
}
