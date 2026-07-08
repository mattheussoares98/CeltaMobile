import 'package:celta_inventario/core/config/secrets.dart';
import 'package:celta_inventario/core/infraestructure/infrastructure.dart'
    show DatabaseConstants;
import 'package:celta_inventario/core/infraestructure/services/services.dart';
import 'package:celta_inventario/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> initApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Future.wait([
    _initFirebase(),
    _initSupabase(),
    _initHive(),
    _setOnlyPortraitMode(),
  ]);
}

Future<void> _initFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.macOS ||
      kIsWeb) {
    return;
  }

  _startNotificationService();

  FlutterError.onError = (errorDetails) {
    // PERFORMANCE: Silent errors are flagged by the framework to be ignored.
    // Checking this avoids unnecessary network traffic for non-breaking issues.
    if (errorDetails.silent) return;

    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  };
}

void _startNotificationService() {
  // We call this without 'await' so the main thread can continue
  // to the next initialization step or the first frame.
  NotificationsService.instance
      .initialize()
      .then((_) {
        debugPrint('Notifications: Async Init Complete');
      })
      .catchError((e) {
        debugPrint('Notifications Error: Async Init Failed - $e');
      });
}

Future<void> _setOnlyPortraitMode() async {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

Future<void> _initSupabase() async {
  const String supaworkingUrl = AppSecrets.supaUrl;
  const String supabaseAnonKey = AppSecrets.supabaseAnonKey;

  if (supaworkingUrl.isEmpty || supabaseAnonKey.isEmpty) {
    throw Exception('Secrets not found. Check your secrets.dart file.');
  }

  await Supabase.initialize(
    url: supaworkingUrl,
    publishableKey: supabaseAnonKey,
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
    ),
  );
}

Future<void> _initHive() async {
  String? path;

  try {
    if (kIsWeb) {
      path = 'path';
    } else {
      final appDocumentDir = await path_provider
          .getApplicationDocumentsDirectory();
      path = appDocumentDir.path;
    }
    Hive.init(path);
    await Future.wait(
      DatabaseConstants.values.map((e) => Hive.openBox(e.name)),
    );
  } catch (e) {
    debugPrint(e.toString());
  }
}
