import 'package:flutter/material.dart';

import '../../../data/datasource/enterprise/enterprise.dart';
import '../../../data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/domain/repositories/enterprise/enterprise.dart';

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
    required List<int> existingEnterpriseCodesOnSupabase,
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
        existingCodes: existingEnterpriseCodesOnSupabase.toSet(),
        enterpriseIdInSupabase: enterpriseIdInSupabase,
      );
    }

    return erpEnterprises.map((e) => e.toEntity()).toList();
  }

  Future<void> _syncMissingEnterprisesWithSupabase({
    required List<SoapEnterpriseModel> erpList,
    required Set<int> existingCodes,
    required int enterpriseIdInSupabase,
  }) async {
    try {
      final missingModels = erpList
          .where((erp) => erp.Code != null && !existingCodes.contains(erp.Code))
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
      debugPrint(e.toString());
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
