import '../models/models.dart';

abstract class IEnterpriseDataSource {
  Future<List<EnterprisePermissionModel>> getAllEnterprisePermissions();
}
