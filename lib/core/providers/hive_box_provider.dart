import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../constants/database_keys.dart';

part 'hive_box_provider.g.dart';

@Riverpod(keepAlive: true)
Box hiveBox(Ref ref) {
  return Hive.box(DatabaseKeys.application.name);
}
