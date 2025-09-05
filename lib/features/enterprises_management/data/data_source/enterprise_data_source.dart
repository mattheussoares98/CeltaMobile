import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/models.dart';
import './data_source.dart';

class EnterpriseDataSource implements IEnterpriseDataSource {
  final SupabaseClient supabase;

  EnterpriseDataSource(this.supabase);
  @override
  Future<List<EnterprisePermissionModel>> getAllEnterprisePermissions() async {
    //TODO create tests
    final response = await supabase.rpc('get_all_enterprise_permissions');

    if (response == null) {
      return [];
    }
    return (response as List)
        .map((item) => EnterprisePermissionModel.fromJson(item))
        .toList();
  }
}
