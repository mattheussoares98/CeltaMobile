import '../models/models.dart';

abstract class IEnterpriseManagerDatasource {
  Future<List<EnterprisePermissionModel>> getEnterprisePermissions();
  Future<EnterprisePermissionModel?> getEnterprisePermissionsById(int id);
  Future<void> createEnterpriseWithSubEnterprises({
    required String enterpriseName,
    required String baseUrl,
    required List<SubEnterpriseModel> subEnterprises,
  });
  Future<void> updateModulePermissions({
    required int enterpriseId,
    required List<UpdateModulePermissionModel> permissions,
  });
  Future<List<EnabledModulesByCnpModel>> getEnabledModulesByEnterpriseName(
    String enterpriseName,
  );
}
