import '../models/models.dart';

abstract class IEnterpriseManagerDataSource {
  Future<List<EnterprisePermissionModel>> getAllEnterprisePermissions();
  //TODO add function to create enterprise
}
