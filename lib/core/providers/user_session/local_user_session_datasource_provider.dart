import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasource/user_session/user_session.dart';
import '../hive/hive.dart';

part 'local_user_session_datasource_provider.g.dart';

@riverpod
ILocalUserSessionDatasource localUserSessionDatasource(Ref ref) {
  return LocalUserSessionDatasource(ref.watch(hiveBoxUserSessionProvider));
}
