import 'package:celta_inventario/core/data/datasource/app_usage/app_usage.dart';
import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RemoteAppUsageDatasource implements IRemoteAppUsageDatasource {
  final SupabaseClient _supabase;

  RemoteAppUsageDatasource(this._supabase);

  @override
  Future<void> insert(List<AppUsageModel> model) async {
    await _supabase.rpc(
      'batch_increment_app_usage',
      params: {'p_usage_data': model.map((e) => e.toJson()).toList()},
    );
  }

  @override
  Future<List<AppUsageModel>> load(LoadAppUsageParams params) async {
    final result = await _supabase.rpc(
      'get_app_usage_report',
      params: {
        'p_enterprise_id': params.enterpriseId,
        'p_start_date': params.startDate.toIso8601String(),
        'p_end_date': params.endDate.toIso8601String(),
      },
    );

    return (result as List).map((e) => AppUsageModel.fromJson(e)).toList();
  }

  @override
  Future<List<GroupedUsageModel>> loadGroupedByEnterprise(
    LoadAppUsageParams params,
  ) async {
    final result = await _supabase.rpc(
      'get_app_usage_report_grouped',
      params: {
        'p_enterprise_id': params.enterpriseId,
        'p_start_date': params.startDate.toIso8601String(),
        'p_end_date': params.endDate.toIso8601String(),
      },
    );
    return await compute(_parseGroupedUsages, result as List);
  }
}

List<GroupedUsageModel> _parseGroupedUsages(List response) {
  return (response).map((e) => GroupedUsageModel.fromJson(e)).toList();
}
