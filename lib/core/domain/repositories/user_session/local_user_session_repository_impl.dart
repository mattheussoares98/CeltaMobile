import '../../../data/models/user_session_model.dart';
import '../../../data/datasource/user_session/user_session.dart';
import 'user_session.dart';

class LocalUserSessionRepositoryImpl implements ILocalUserSessionRepository {
  final ILocalUserSessionDatasource localUserSessionDatasource;
  LocalUserSessionRepositoryImpl(this.localUserSessionDatasource);

  @override
  Future<void> logout() async {
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
