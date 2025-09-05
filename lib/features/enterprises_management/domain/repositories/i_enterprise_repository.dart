import '../entities/entities.dart';

abstract class IEnterpriseRepository {
  Future<List<EnterprisePermissionEntity>> getAllEnterprisePermissions();
}
