import '../../data/models/user_session_model.dart';
import '../../data/datasource/user_session/user_session.dart';
import 'repositores.dart';

class LocalUserSessionRepositoryImpl implements ILocalUserSessionRepository {
  final ILocalUserSessionDataSource localUserSessionDataSource;
  LocalUserSessionRepositoryImpl(this.localUserSessionDataSource);

  @override
  Future<void> clear() async {
    return await localUserSessionDataSource.clear();
  }

  @override
  Future<UserSessionModel?> get() async {
    return await localUserSessionDataSource.get();
  }

  @override
  Future<void> save(UserSessionModel session) async {
    return await localUserSessionDataSource.save(session);
  }
}
