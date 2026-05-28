import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/infraestructure/services/services.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class CrashlyticsService implements ICrashlyticsService {
  final FirebaseCrashlytics _crashlytics;

  CrashlyticsService(this._crashlytics);

  /// Sets custom keys for the current session
  @override
  Future<void> setCustomKeys(
    List<CrashlyticsCustomKeyEntity> customKeys,
  ) async {
    // Centralized platform check to avoid repeating logic in UI
    if (PlatformUtil.isDesktop || PlatformUtil.isWeb) {
      return;
    }

    await Future.wait(
      customKeys.map((item) => _crashlytics.setCustomKey(item.key, item.value)),
    );
  }
}
