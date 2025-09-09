import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/models.dart';
import 'enterprise.dart';

class SupabaseEnterpriseDataSource implements ISupabaseEnterpriseDataSource {
  final SupabaseClient _supabase;

  SupabaseEnterpriseDataSource(this._supabase);

  @override
  Future<SupabaseEnterpriseModel?> getEnterpriseByName(String name) async {
    try {
      final response = await _supabase.rpc(
        'get_enterprise_by_name',
        params: {'p_name': name},
      );

      if (response == null) {
        return null;
      }

      return SupabaseEnterpriseModel.fromJson(response);
    } catch (e) {
      debugPrint('Error fetching enterprise: $e');
      rethrow;
    }
  }
}
