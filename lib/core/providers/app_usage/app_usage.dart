import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasource/app_usage/app_usage.dart';
import '../../domain/repositories/app_usage/app_usage.dart';
import '../../data/repositories/app_usage/app_usage.dart';
import '../hive/hive.dart';
import '../supabase/supabase.dart';

part 'app_usage.g.dart';

@riverpod
IRemoteAppUsageDatasource remoteAppUsageDatasource(Ref ref) {
  return RemoteAppUsageDatasource(ref.watch(supabaseClientProvider));
}

@riverpod
ILocalAppUsageDatasource localAppUsageDatasource(Ref ref) {
  return LocalAppUsageDatasource(ref.watch(hiveBoxAppUsageProvider));
}

@riverpod
IAppUsageRepository appUsageRepository(Ref ref) {
  return AppUsageRepositoryImpl(
    ref.watch(remoteAppUsageDatasourceProvider),
    ref.watch(localAppUsageDatasourceProvider),
  );
}
