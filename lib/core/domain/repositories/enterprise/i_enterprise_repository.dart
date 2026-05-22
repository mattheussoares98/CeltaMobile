import 'package:celta_inventario/core/domain/entities/entities.dart';

abstract class IEnterpriseRepository {
  Future<EnterpriseEntity?> getSupabaseEnterpriseByName(String name);

  Future<List<EnterpriseEntity>> getSoapEnterprises({
    required String url,
    required String crossIdentity,
    required List<int> existingEnterpriseCodesOnSupabase,
    required int enterpriseIdInSupabase,
    int? enterpriseOriginCode,
    int? requestTypeCode,
  });

  Future<List<EnabledModulesByCnpjEntity>> getEnabledModulesByEnterpriseName(
    String enterpriseName,
  );
}
