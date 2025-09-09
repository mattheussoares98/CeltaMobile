import '../models/models.dart';

abstract class IEnterpriseManagerDataSource {
  Future<List<EnterprisePermissionModel>> getAllEnterprisePermissions();
}
