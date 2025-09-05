import 'entities.dart';

class EnterprisePermissionEntity {
  final int id;
  final String name;
  final String baseUrl;
  final List<SubEnterprisePermissionEntity> subEnterprises;

  EnterprisePermissionEntity({
    required this.id,
    required this.name,
    required this.baseUrl,
    required this.subEnterprises,
  });
}
