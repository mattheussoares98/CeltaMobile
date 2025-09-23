import 'package:celta_intelligence/core/providers/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/entities/entities.dart';

part 'app_settings_state_controller.g.dart';

@Riverpod(keepAlive: true)
class AppSettingsStateController extends _$AppSettingsStateController {
  @override
  Future<AppSettingsEntity?> build() async {
    return await ref.watch(appSettingsRepositoryProvider).loadSettings();
  }

  Future<void> changeSettings(AppSettingsEntity userPreferredSearchType) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(appSettingsRepositoryProvider)
          .changeSettings(userPreferredSearchType);

      return userPreferredSearchType;
    });
  }
}
