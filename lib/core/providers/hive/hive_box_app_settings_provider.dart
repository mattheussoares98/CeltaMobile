import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../infraestructure/infrastructure.dart';

part 'hive_box_app_settings_provider.g.dart';

@Riverpod(keepAlive: true)
Box hiveBoxAppSettings(Ref ref) {
  return Hive.box(DatabaseConstants.appSettings.name);
}
