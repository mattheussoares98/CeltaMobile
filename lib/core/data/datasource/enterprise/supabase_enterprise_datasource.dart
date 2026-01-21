import 'package:celta_inventario/utils/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/models.dart';
import 'enterprise.dart';

class SupabaseEnterpriseDatasource implements ISupabaseEnterpriseDatasource {
  final SupabaseClient _supabase;

  SupabaseEnterpriseDatasource(this._supabase);

  @override
  Future<SupabaseEnterpriseModel?> getEnterpriseByName(String name) async {
    final response = await _supabase.rpc(
      'get_enterprise_by_name',
      params: {'p_enterprise_name': name.toLowerCase().removeWhiteSpaces()},
    );

    if (response == null) {
      return null;
    }

    return SupabaseEnterpriseModel.fromJson(response);
  }

  @override
  Future<List<EnabledModulesByCnpjModel>> getEnabledModulesByEnterpriseName(
    String enterpriseName,
  ) async {
    final response = await _supabase.rpc(
      'get_enabled_modules_for_enterprise',
      params: {'p_enterprise_name': enterpriseName},
    );

    if (response is List && response.isNotEmpty) {
      return response
          .map((e) => EnabledModulesByCnpjModel.fromJson(e))
          .toList();
    }
    return [];
  }

  @override
  Future<void> createSubEnterprises(
    List<SupabaseSubEnterpriseModel> subEnterprises,
    int enterpriseId,
  ) async {
    await _supabase.rpc(
      'insert_sub_enterprises',
      params: {
        'p_enterprise_id': enterpriseId,
        'p_sub_enterprises': subEnterprises.map((e) => e.toJson()).toList(),
      },
    );
  }
}
