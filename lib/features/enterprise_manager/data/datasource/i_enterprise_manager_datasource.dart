import '../models/models.dart';

abstract class IEnterpriseManagerDatasource {
  Future<List<EnterprisePermissionModel>> getEnterprisePermissions();
  Future<EnterprisePermissionModel?> getEnterprisePermissionsById(int id);
  Future<void> createEnterpriseWithSubEnterprises({
    required String enterpriseName,
    required String urlInUse,
    required List<SubEnterpriseModel> subEnterprises,
  });
  Future<void> updateUrlAndPermissions({
    required int enterpriseId,
    required String urlInUse,
    required List<UpdateModulePermissionModel> permissions,
  });
}
