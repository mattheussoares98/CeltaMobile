import '../entities/entities.dart';

abstract class IEnterpriseManagerRepository {
  Future<List<EnterprisePermissionEntity>> getAllEnterprisePermissions();
  Future<void> createEnterprise({
    required String enterpriseName,
    required String baseUrl,
    required String userName,
    required String password,
  });
}
