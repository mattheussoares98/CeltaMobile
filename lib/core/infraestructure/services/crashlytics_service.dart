import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

import '../../domain/entities/entities.dart';
import 'services.dart';

class CrashlyticsService implements ICrashlyticsService {
  final FirebaseCrashlytics _crashlytics;

  CrashlyticsService(this._crashlytics);

  /// Sets custom keys for the current session
  @override
  Future<void> setCustomKeys(
    List<CrashlyticsCustomKeyEntity> customKeys,
  ) async {
    // Centralized platform check to avoid repeating logic in UI
    if (kIsWeb ||
        (defaultTargetPlatform != TargetPlatform.iOS &&
            defaultTargetPlatform != TargetPlatform.android)) {
      return;
    }

    await Future.wait(
      customKeys.map((item) => _crashlytics.setCustomKey(item.key, item.value)),
    );
  }
}
