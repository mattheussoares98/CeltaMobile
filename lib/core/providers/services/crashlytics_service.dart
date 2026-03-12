import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../infraestructure/services/services.dart';

part 'crashlytics_service.g.dart';

@riverpod
ICrashlyticsService crashlyticsService(Ref ref) {
  return CrashlyticsService(FirebaseCrashlytics.instance);
}
