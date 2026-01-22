import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/config/secrets.dart';
import '../core/infraestructure/infrastructure.dart' show DatabaseConstants;
import '../firebase_options.dart';

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
      defaultTargetPlatform == TargetPlatform.macOS) {
    return;
  }

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
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

  await Supabase.initialize(url: supaworkingUrl, anonKey: supabaseAnonKey);
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
    for (var box in DatabaseConstants.values) {
      await Hive.openBox(box.name);
    }
  } catch (e) {
    debugPrint(e.toString());
  }
}
