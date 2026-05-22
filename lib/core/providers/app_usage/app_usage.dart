import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:celta_inventario/core/data/datasource/app_usage/app_usage.dart';
import 'package:celta_inventario/core/domain/repositories/app_usage/app_usage.dart';
import 'package:celta_inventario/core/data/repositories/app_usage/app_usage.dart';
import 'package:celta_inventario/core/providers/hive/hive.dart';
import 'package:celta_inventario/core/providers/supabase/supabase.dart';

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
