import '../../data/models/models.dart';
import '../entities/entities.dart';

abstract class IEnterpriseManagerRepository {
  Future<List<EnterprisePermissionEntity>> getAllEnterprisePermissions();
  Future<EnterprisePermissionEntity?> getEnterprisePermissionsById(int id);
  Future<void> createEnterprise({
    required String enterpriseName,
    required String baseUrl,
    required String userName,
    required String password,
  });
  Future<void> updateModulePermissions({
    required int enterpriseId,
    required List<UpdateModulePermissionModel> permissions,
  });
  Future<List<EnabledModulesByCnpjEntity>> getEnabledModulesByEnterpriseName(
    String enterpriseName,
  );
}
