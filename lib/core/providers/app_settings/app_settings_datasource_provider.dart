import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasource/settings/settings.dart';
import '../hive/hive.dart';

part 'app_settings_datasource_provider.g.dart';

@riverpod
IAppSettingsDatasource appSettingsDatasource(Ref ref) {
  return LocalAppSettingsDatasource(ref.watch(hiveBoxProvider));
}
