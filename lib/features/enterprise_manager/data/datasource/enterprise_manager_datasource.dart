import 'package:celta_intelligence/utils/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/models.dart';
import 'datasource.dart';

class EnterpriseManagerDatasource implements IEnterpriseManagerDatasource {
  final SupabaseClient supabase;

  EnterpriseManagerDatasource(this.supabase);
  @override
  Future<List<EnterprisePermissionModel>> getEnterprisePermissions() async {
    final response = await supabase.rpc('get_enterprise_permissions');

    if (response == null) {
      return [];
    }
    return (response as List)
        .map((item) => EnterprisePermissionModel.fromJson(item))
        .toList();
  }

  @override
  Future<void> createEnterpriseWithSubEnterprises({
    required String enterpriseName,
    required String remoteHttpUrl,
    required String? remoteHttpsUrl,
    required String? localHttpUrl,
    required String? localHttpsUrl,
    required List<SubEnterpriseModel> subEnterprises,
  }) async {
    await supabase.rpc(
      'create_enterprise_with_sub_enterprises',
      params: {
        'p_enterprise_name': enterpriseName.toLowerCase().removeWhiteSpaces(),
        'p_remote_http_url': remoteHttpUrl.toLowerCase().removeWhiteSpaces(),
        'p_remote_https_url': remoteHttpsUrl?.toLowerCase().removeWhiteSpaces(),
        'p_local_http_url': localHttpUrl?.toLowerCase().removeWhiteSpaces(),
        'p_local_https_url': localHttpsUrl?.toLowerCase().removeWhiteSpaces(),
        'p_sub_enterprises': subEnterprises.map((e) => e.toJson()).toList(),
      },
    );
  }

  @override
  Future<EnterprisePermissionModel?> getEnterprisePermissionsById(
    int id,
  ) async {
    final response = await supabase.rpc(
      'get_enterprise_permissions',
      params: {'p_enterprise_id': id},
    );

    if (response is List && response.isNotEmpty) {
      return EnterprisePermissionModel.fromJson(response.first);
    }
    return null;
  }

  @override
  Future<void> updateUrlAndPermissions({
    required int enterpriseId,
    required String remoteHttpUrl,
    required String? remoteHttpsUrl,
    required String? localHttpUrl,
    required String? localHttpsUrl,
    required List<UpdateModulePermissionModel> permissions,
  }) async {
    await supabase.rpc(
      'update_module_permission',
      params: {
        'p_enterprise_id': enterpriseId,
        'p_remote_http_url': remoteHttpUrl.toLowerCase().removeWhiteSpaces(),
        'p_remote_https_url': remoteHttpsUrl?.toLowerCase().removeWhiteSpaces(),
        'p_local_http_url': localHttpUrl?.toLowerCase().removeWhiteSpaces(),
        'p_local_https_url': localHttpsUrl?.toLowerCase().removeWhiteSpaces(),
        'p_permissions_payload': permissions.map((e) => e.toJson()).toList(),
      },
    );
  }
}
