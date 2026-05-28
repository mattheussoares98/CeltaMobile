import 'package:celta_inventario/core/infraestructure/services/services.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'crashlytics_service.g.dart';

@Riverpod(keepAlive: true)
ICrashlyticsService crashlyticsService(Ref ref) {
  return CrashlyticsService(FirebaseCrashlytics.instance);
}
