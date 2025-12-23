import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/entities/entities.dart';
import '../../../../core/providers/app_settings/app_settings.dart';

part 'app_settings_state_controller.g.dart';

@Riverpod(keepAlive: true)
class AppSettingsStateController extends _$AppSettingsStateController {
  @override
  Future<AppSettingsEntity?> build() async {
    return await ref.watch(appSettingsRepositoryProvider).loadSettings();
  }

  Future<void> changeSettings({
    SearchProductTypePreference? searchPreference,
    bool? inventoryUseContinuousScan,
    bool? expeditionUseContinuousScan,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final newValue = state.value!.copyWith(
        searchPreference: searchPreference,
        inventoryUseContinuousScan: inventoryUseContinuousScan,
        expeditionUseContinuousScan: expeditionUseContinuousScan,
      );

      await ref.read(appSettingsRepositoryProvider).changeSettings(newValue);

      return newValue;
    });
  }
}
