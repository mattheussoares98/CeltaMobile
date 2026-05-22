import 'package:celta_inventario/features/enterprise_manager/data/models/models.dart';

abstract class IEnterpriseManagerDatasource {
  Future<List<EnterprisePermissionModel>> getEnterprisePermissions();
  Future<EnterprisePermissionModel?> getEnterprisePermissionsById(int id);
  Future<void> createEnterpriseWithSubEnterprises({
    required String enterpriseName,
    required String remoteHttpUrl,
    required String? remoteHttpsUrl,
    required String? localHttpUrl,
    required String? localHttpsUrl,
    required List<SubEnterpriseModel> subEnterprises,
  });
  Future<void> updateUrlAndPermissions({
    required int enterpriseId,
    required String remoteHttpUrl,
    required String? remoteHttpsUrl,
    required String? localHttpUrl,
    required String? localHttpsUrl,
    required List<UpdateModulePermissionModel> permissions,
  });
}
