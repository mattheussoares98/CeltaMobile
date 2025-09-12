import 'package:celta_intelligence/utils/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/models.dart';
import 'enterprise.dart';

class SupabaseEnterpriseDataSource implements ISupabaseEnterpriseDataSource {
  final SupabaseClient _supabase;

  SupabaseEnterpriseDataSource(this._supabase);

  @override
  Future<SupabaseEnterpriseModel?> getEnterpriseByName(String name) async {
    final response = await _supabase.rpc(
      'get_enterprise_by_name',
      params: {'p_name': name.toLowerCase().removeWhiteSpaces()},
    );

    if (response == null) {
      return null;
    }

    return SupabaseEnterpriseModel.fromJson(response);
  }
}
