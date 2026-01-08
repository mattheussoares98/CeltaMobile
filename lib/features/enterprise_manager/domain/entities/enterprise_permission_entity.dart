import 'package:equatable/equatable.dart';

import 'entities.dart';

class EnterprisePermissionEntity extends Equatable {
  final int id;
  final String name;
  final String urlInUse;
  final List<ModulePermissionEntity> globalModules;
  final List<SubEnterprisePermissionEntity> subEnterprises;

  const EnterprisePermissionEntity({
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
}
