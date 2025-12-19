import '../models/models.dart';

abstract class IEnterpriseManagerDatasource {
  Future<List<EnterprisePermissionModel>> getEnterprisePermissions();
  Future<EnterprisePermissionModel?> getEnterprisePermissionsById(int id);
  Future<void> createEnterpriseWithSubEnterprises({
    required String enterpriseName,
    required String baseUrl,
    required List<SubEnterpriseModel> subEnterprises,
  });
  Future<void> updateUrlAndPermissions({
    required int enterpriseId,
    required String baseUrl,
    required List<UpdateModulePermissionModel> permissions,
  });
}
