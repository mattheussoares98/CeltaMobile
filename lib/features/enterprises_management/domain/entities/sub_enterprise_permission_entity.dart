import 'entities.dart';

class SubEnterprisePermissionEntity {
  final int id;
  final String name;
  final String cnpjNumber;
  final List<ModulePermissionEntity> modules;

  SubEnterprisePermissionEntity({
    required this.id,
    required this.name,
    required this.cnpjNumber,
    required this.modules,
  });
}
