import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/config/secrets.dart';
import '../core/infraestructure/infrastructure.dart' show DatabaseConstants;

Future<void> initApp() async {
  await _initSupabase();
  await _initHive();
}

Future<void> _initSupabase() async {
  const String supabaseUrl = AppSecrets.supabaseUrl;
  const String supabaseAnonKey = AppSecrets.supabaseAnonKey;

  if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
    throw Exception('Secrets not found. Check your secrets.dart file.');
  }

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
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
