import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/infraestructure/infrastructure.dart' show DatabaseConstants;

Future<void> initApp() async {
  await _initSupabase();
  await _initHive();
}

Future<void> _initSupabase() async {
  await Supabase.initialize(
    url: 'https://ktodulvteumcqjcdezon.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imt0b2R1bHZ0ZXVtY3FqY2Rlem9uIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTMxOTUzOTQsImV4cCI6MjA2ODc3MTM5NH0.nfw-hJjRVtHexnd7-jEyY3g7aj5y2csE6WSRyXNKCpU',
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
    for (var box in DatabaseConstants.values) {
      await Hive.openBox(box.name);
    }
  } catch (e) {
    debugPrint(e.toString());
  }
}
