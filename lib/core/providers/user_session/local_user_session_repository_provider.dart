import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/repositories/user_session/user_session.dart';
import 'user_session.dart';

@riverpod
ILocalUserSessionRepository localUserSessionRepository(Ref ref) {
  return LocalUserSessionRepositoryImpl(
    ref.watch(localUserSessionDatasourceProvider),
  );
}
