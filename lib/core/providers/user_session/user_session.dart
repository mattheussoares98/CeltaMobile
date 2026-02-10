import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasource/user_session/user_session.dart';
import '../../domain/repositories/user_session/user_session.dart';
import '../hive/hive.dart';
import '../supabase/supabase.dart';

part 'user_session.g.dart';

@riverpod
ILocalUserSessionDatasource localUserSessionDatasource(Ref ref) {
  return LocalUserSessionDatasource(ref.watch(hiveBoxUserSessionProvider));
}

@riverpod
ILocalUserSessionRepository localUserSessionRepository(Ref ref) {
  return LocalUserSessionRepositoryImpl(
    ref.watch(localUserSessionDatasourceProvider),
  );
}

@riverpod
ISupabaseUserSessionDatasource supabaseUserSessionDatasource(Ref ref) {
  return SupabaseUserSessionDatasource(ref.watch(supabaseClientProvider));
}
