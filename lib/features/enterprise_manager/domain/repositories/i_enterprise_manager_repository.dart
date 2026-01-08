import '../../data/models/models.dart';
import '../entities/entities.dart';

abstract class IEnterpriseManagerRepository {
  Future<List<EnterprisePermissionEntity>> getAllEnterprisePermissions();
  Future<EnterprisePermissionEntity?> getEnterprisePermissionsById(int id);
  Future<void> createEnterprise({
    required String enterpriseName,
    required String remoteHttpUrl,
    required String? remoteHttpsUrl,
    required String? localHttpUrl,
    required String? localHttpsUrl,
    required String userName,
    required String password,
  });
  Future<void> updateModulePermissions({
    required int enterpriseId,
    required String remoteHttpUrl,
    required String? remoteHttpsUrl,
    required String? localHttpUrl,
    required String? localHttpsUrl,
    required List<UpdateModulePermissionModel> permissions,
  });
}
