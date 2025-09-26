import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../infraestructure/infrastructure.dart';

part 'hive_box_user_session_provider.g.dart';

@Riverpod(keepAlive: true)
Box hiveBoxUserSession(Ref ref) {
  return Hive.box(DatabaseConstants.userSession.name);
}
