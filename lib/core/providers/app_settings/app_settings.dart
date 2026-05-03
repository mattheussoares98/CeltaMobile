import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasource/settings/settings.dart';
import '../../domain/repositories/settings/settings.dart';
import '../../data/repositories/settings/settings.dart';
import '../hive/hive.dart';

part 'app_settings.g.dart';

@riverpod
IAppSettingsDatasource appSettingsDatasource(Ref ref) {
  return LocalAppSettingsDatasource(ref.watch(hiveBoxAppSettingsProvider));
}

@riverpod
IAppSettingsRepository appSettingsRepository(Ref ref) {
  return LocalAppSettingsRepository(ref.watch(appSettingsDatasourceProvider));
}
