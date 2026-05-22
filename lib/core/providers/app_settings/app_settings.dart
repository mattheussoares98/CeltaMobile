import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:celta_inventario/core/data/datasource/settings/settings.dart';
import 'package:celta_inventario/core/domain/repositories/settings/settings.dart';
import 'package:celta_inventario/core/data/repositories/settings/settings.dart';
import 'package:celta_inventario/core/providers/hive/hive.dart';

part 'app_settings.g.dart';

@riverpod
IAppSettingsDatasource appSettingsDatasource(Ref ref) {
  return LocalAppSettingsDatasource(ref.watch(hiveBoxAppSettingsProvider));
}

@riverpod
IAppSettingsRepository appSettingsRepository(Ref ref) {
  return LocalAppSettingsRepository(ref.watch(appSettingsDatasourceProvider));
}
