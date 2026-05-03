import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasource/user_session/user_session.dart';
import '../../domain/repositories/user_session/user_session.dart';
import '../../data/repositories/user_session/user_session.dart';
import '../hive/hive.dart';
import '../supabase/supabase.dart';

part 'user_session.g.dart';

@riverpod
ILocalUserSessionDatasource userSessionDatasource(Ref ref) {
  return LocalUserSessionDatasource(ref.watch(hiveBoxUserSessionProvider));
}

@riverpod
IUserSessionRepository userSessionRepository(Ref ref) {
  return UserSessionRepositoryImpl(
    ref.watch(userSessionDatasourceProvider),
    ref.watch(supabaseUserSessionDatasourceProvider),
  );
}

@riverpod
ISupabaseUserSessionDatasource supabaseUserSessionDatasource(Ref ref) {
  return SupabaseUserSessionDatasource(ref.watch(supabaseClientProvider));
}
