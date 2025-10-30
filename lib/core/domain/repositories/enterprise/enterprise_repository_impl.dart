import '../../../data/datasource/enterprise/enterprise.dart';
import '../../entities/entities.dart';
import 'i_enterprise_repository.dart';

class EnterpriseRepositoryImpl implements IEnterpriseRepository {
  final ISupabaseEnterpriseDatasource supabaseEnterpriseDatasource;
  final ISoapEnterpriseDatasource soapEnterpriseDatasource;
  EnterpriseRepositoryImpl({
    required this.supabaseEnterpriseDatasource,
    required this.soapEnterpriseDatasource,
  });

  @override
  Future<EnterpriseEntity?> getSupabaseEnterpriseByName(String name) async {
    final model = await supabaseEnterpriseDatasource.getEnterpriseByName(name);
    return model?.toEntity();
  }

  @override
  Future<List<EnterpriseEntity>> getSoapEnterprises({
    required String url,
    required String crossIdentity,
    int? enterpriseOriginCode,
    int? requestTypeCode,
  }) async {
    final models = await soapEnterpriseDatasource.getEnterprises(
      baseUrl: url,
      crossIdentity: crossIdentity,
      enterpriseOriginCode: enterpriseOriginCode,
      requestTypeCode: requestTypeCode,
    );

    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Future<List<EnabledModulesByCnpjEntity>> getEnabledModulesByEnterpriseName(
    String enterpriseName,
  ) async {
    final enterprises = await supabaseEnterpriseDatasource
        .getEnabledModulesByEnterpriseName(enterpriseName);

    return enterprises.map((e) => e.toEntity()).toList();
  }
}
