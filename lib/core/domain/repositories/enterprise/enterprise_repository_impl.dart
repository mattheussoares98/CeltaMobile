import '../../../data/datasource/enterprise/enterprise.dart';
import '../../../data/models/models.dart';
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
    required List<String> existingCnpjsInSupabase,
    required int enterpriseIdInSupabase,
    int? enterpriseOriginCode,
    int? requestTypeCode,
  }) async {
    final erpEnterprises = await soapEnterpriseDatasource.getEnterprises(
      workingUrl: url,
      crossIdentity: crossIdentity,
      enterpriseOriginCode: enterpriseOriginCode,
      requestTypeCode: requestTypeCode,
    );

    if (erpEnterprises.isNotEmpty) {
      await _syncMissingEnterprisesWithSupabase(
        erpList: erpEnterprises,
        existingCnpjs: existingCnpjsInSupabase.toSet(),
        enterpriseIdInSupabase: enterpriseIdInSupabase,
      );
    }

    return erpEnterprises.map((e) => e.toEntity()).toList();
  }

  Future<void> _syncMissingEnterprisesWithSupabase({
    required List<SoapEnterpriseModel> erpList,
    required Set<String> existingCnpjs,
    required int enterpriseIdInSupabase,
  }) async {
    try {
      final missingModels = erpList
          .where(
            (erp) =>
                erp.CnpjNumber != null &&
                !existingCnpjs.contains(erp.CnpjNumber),
          )
          .map(
            (erp) => SupabaseSubEnterpriseModel(
              id: null,
              idFromErp: erp.Code!,
              name: erp.Name!,
              cnpjNumber: erp.CnpjNumber!,
              personalizedCode: erp.PersonalizedCode ?? '',
            ),
          )
          .toList();

      if (missingModels.isNotEmpty) {
        await supabaseEnterpriseDatasource.createSubEnterprises(
          missingModels,
          enterpriseIdInSupabase,
        );
      }
    } catch (e) {
      // Silent fail to avoid blocking the ERP data display
    }
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
