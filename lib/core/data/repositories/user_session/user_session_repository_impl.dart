import 'package:flutter/foundation.dart';

import '../../../data/models/user_session_model.dart';
import '../../../data/datasource/user_session/user_session.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/domain/repositories/user_session/user_session.dart';

class UserSessionRepositoryImpl implements IUserSessionRepository {
  final ILocalUserSessionDatasource localUserSessionDatasource;
  final ISupabaseUserSessionDatasource supabaseUserSessionDatasource;
  UserSessionRepositoryImpl(
    this.localUserSessionDatasource,
    this.supabaseUserSessionDatasource,
  );

  @override
  Future<void> logout({
    required String userName,
    required DeviceType deviceType,
    required int enterpriseId,
  }) async {
    try {
      supabaseUserSessionDatasource.removeUserSession(
        userName: userName,
        deviceType: deviceType,
        enterpriseId: enterpriseId,
      );
      //*should call local logout event supabase throws because can't disable the user to do logout
    } catch (e) {
      debugPrint(e.toString());
    }
    return await localUserSessionDatasource.logout();
  }

  @override
  Future<UserSessionModel?> get() async {
    return await localUserSessionDatasource.get();
  }

  @override
  Future<void> save(UserSessionModel session) async {
    return await localUserSessionDatasource.save(session);
  }
}
