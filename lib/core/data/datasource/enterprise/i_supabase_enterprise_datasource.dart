import 'package:celta_inventario/core/data/models/models.dart';

abstract class ISupabaseEnterpriseDatasource {
  Future<SupabaseEnterpriseModel?> getEnterpriseByName(String name);

  Future<List<EnabledModulesByCnpjModel>> getEnabledModulesByEnterpriseName(
    String enterpriseName,
  );

  Future<void> createSubEnterprises(
    List<SupabaseSubEnterpriseModel> subEnterprises,
    int enterpriseId,
  );
}
