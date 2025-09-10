import '../models/models.dart';

abstract class IEnterpriseManagerDataSource {
  Future<List<EnterprisePermissionModel>> getEnterprisePermissions();
  Future<void> createEnterpriseWithSubEnterprises({
    required String enterpriseName,
    required String baseUrl,
    required List<SubEnterpriseModel> subEnterprises,
  });
}
