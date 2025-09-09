import 'package:equatable/equatable.dart';

import 'entities.dart';

class SubEnterprisePermissionEntity extends Equatable {
  final String id;
  final String name;
  final String cnpjNumber;
  final List<ModulePermissionEntity> modules;

  const SubEnterprisePermissionEntity({
    required this.id,
    required this.name,
    required this.cnpjNumber,
    required this.modules,
  });

  @override
  List<Object?> get props => [id, name, cnpjNumber, modules];
}
