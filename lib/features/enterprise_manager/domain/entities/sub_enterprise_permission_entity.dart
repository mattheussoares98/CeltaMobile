import 'package:equatable/equatable.dart';

import 'entities.dart';

class SubEnterprisePermissionEntity extends Equatable {
  final int id;
  final String name;
  final String cnpjNumber;
  final String personalizedCode;
  final List<ModulePermissionEntity> modules;

  const SubEnterprisePermissionEntity({
    required this.id,
    required this.name,
    required this.cnpjNumber,
    required this.personalizedCode,
    required this.modules,
  });

  @override
  List<Object?> get props => [id, name, cnpjNumber, modules, personalizedCode];
}
