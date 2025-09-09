import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/models.dart';
import 'datasource.dart';

class EnterpriseManagerDataSource implements IEnterpriseManagerDataSource {
  final SupabaseClient supabase;

  EnterpriseManagerDataSource(this.supabase);
  @override
  Future<List<EnterprisePermissionModel>> getAllEnterprisePermissions() async {
    final response = await supabase.rpc('get_all_enterprise_permissions');

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
    required String baseUrl,
    required List<SubEnterpriseModel> subEnterprises,
  }) async {
    //TODO test what happens when throws in application
    await supabase.rpc(
      'create_enterprise_with_sub_enterprises',
      params: {
        'p_enterprise_name': enterpriseName,
        'p_base_url': baseUrl,
        'p_sub_enterprises': subEnterprises.map((e) => e.toJson()).toList(),
      },
    );
  }
}
