import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/providers/app_settings/app_settings.dart';

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
    bool? receiptUseContinuousScan,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final newValue = state.value!.copyWith(
        searchPreference: searchPreference,
        inventoryUseContinuousScan: inventoryUseContinuousScan,
        expeditionUseContinuousScan: expeditionUseContinuousScan,
        receiptUseContinuousScan: receiptUseContinuousScan,
      );

      await ref.read(appSettingsRepositoryProvider).changeSettings(newValue);

      return newValue;
    });
  }
}
