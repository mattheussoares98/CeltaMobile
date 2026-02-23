import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasource/app_usage/app_usage.dart';
import '../hive/hive.dart';
import '../supabase/supabase.dart';

part 'app_usage.g.dart';

@riverpod
ISupabaseAppUsageDatasource supabaseAppUsageDatasource(Ref ref) {
  return SupabaseAppUsageDatasource(ref.watch(supabaseClientProvider));
  //TODO ask gemini about change how is organized this core path. Maybe will be better if create files like feature first separation
}

@riverpod
ILocalAppUsageDatasource localAppUsageDatasource(Ref ref) {
  return LocalAppUsageDatasource(ref.watch(hiveBoxAppUsageProvider));
}
