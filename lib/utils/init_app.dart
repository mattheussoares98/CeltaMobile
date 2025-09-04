import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/constants/database_keys.dart';

Future<void> initApp() async {
  await _initSupabase();
  await _initHive();
}

Future<void> _initSupabase() async {
  await Supabase.initialize(
    url: 'https://cybzhbwdqubkucsunzsi.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImN5YnpoYndkcXVia3Vjc3VuenNpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc3Nzc0NDEsImV4cCI6MjA2MzM1MzQ0MX0.LlWWL4h95_auO1ZSzneDcrc3v5JZ0n_4GAqG9DRyIn8',
  );
}

Future<void> _initHive() async {
  String? path;

  try {
    if (kIsWeb) {
      path = DatabaseKeys.application.name;
    } else {
      final appDocumentDir = await path_provider
          .getApplicationDocumentsDirectory();
      path = appDocumentDir.path;
    }
    Hive.init(path);
    await Hive.openBox(DatabaseKeys.application.name);
  } catch (e) {
    debugPrint(e.toString());
  }
}
