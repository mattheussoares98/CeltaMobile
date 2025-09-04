import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../data/models/models.dart';
import 'enterprise.dart';

class RemoteSupabaseEnterpriseDatasource
    implements SupabaseEnterpriseDatasource {
  final SupabaseClient _supabase;

  RemoteSupabaseEnterpriseDatasource(this._supabase);

  @override
  Future<EnterpriseModel?> getEnterprise(String name) async {
    try {
      //TODO create tests
      final response = await _supabase.rpc(
        'get_enterprise_by_name',
        params: {'p_name': name},
      );

      if (response == null) {
        return null;
      }

      return EnterpriseModel.fromJson(response);
    } catch (e) {
      debugPrint('Error fetching enterprise: $e');
      rethrow;
    }
  }
}
