import '../models/models.dart';

abstract class IEnterpriseManagerDataSource {
  Future<List<EnterprisePermissionModel>> getAllEnterprisePermissions();
  Future<void> createEnterpriseWithSubEnterprises({
    required String enterpriseName,
    required String baseUrl,
    required List<SubEnterpriseModel> subEnterprises,
  });
}
