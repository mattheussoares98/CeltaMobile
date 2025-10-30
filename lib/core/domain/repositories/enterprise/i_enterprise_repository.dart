import '../../entities/entities.dart';

abstract class IEnterpriseRepository {
  Future<EnterpriseEntity?> getSupabaseEnterpriseByName(String name);

  Future<List<EnterpriseEntity>> getSoapEnterprises({
    required String url,
    required String crossIdentity,
    int? enterpriseOriginCode,
    int? requestTypeCode,
  });

  Future<List<EnabledModulesByCnpjEntity>> getEnabledModulesByEnterpriseName(
    String enterpriseName,
  );
}
