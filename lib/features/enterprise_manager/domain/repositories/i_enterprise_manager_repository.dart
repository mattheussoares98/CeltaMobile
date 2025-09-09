import '../entities/entities.dart';

abstract class IEnterpriseManagerRepository {
  Future<List<EnterprisePermissionEntity>> getAllEnterprisePermissions();
}
