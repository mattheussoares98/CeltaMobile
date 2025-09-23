import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/repositories/settings/settings.dart';
import 'app_settings.dart';

part 'app_settings_repository_provider.g.dart';

@riverpod
IAppSettingsRepository appSettingsRepository(Ref ref) {
  return LocalAppSettingsRepository(ref.watch(appSettingsDatasourceProvider));
}
