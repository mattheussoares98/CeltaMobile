import 'package:celta_inventario/core/data/models/app_usage/app_usage_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app_usage.dart';

class SupabaseAppUsageDatasource implements ISupabaseAppUsageDatasource {
  final SupabaseClient _supabase;

  SupabaseAppUsageDatasource(this._supabase);

  @override
  Future<void> insert(List<AppUsageModel> model) async {
    await _supabase.rpc(
      'batch_increment_app_usage',
      params: {'p_usage_data': model.map((e) => e.toJson()).toList()},
    );
  }

  @override
  Future<List<AppUsageModel>> load({
    required int enterpriseId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final result = await _supabase.rpc(
      'get_app_usage_report',
      params: {
        'p_enterprise_id': enterpriseId,
        'p_start_date': startDate,
        'p_end_date': endDate,
      },
    );

    return (result as List).map((e) => AppUsageModel.fromJson(e)).toList();
  }
}
