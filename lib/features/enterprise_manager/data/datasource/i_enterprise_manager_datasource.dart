import '../models/models.dart';

abstract class IEnterpriseManagerDataSource {
  Future<List<EnterprisePermissionModel>> getEnterprisePermissions();
  Future<List<EnterprisePermissionModel>> getEnterprisePermissionsById(int id);
  Future<void> createEnterpriseWithSubEnterprises({
    required String enterpriseName,
    required String baseUrl,
    required List<SubEnterpriseModel> subEnterprises,
  });
}
