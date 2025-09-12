import '../../../core/data/models/session_model.dart';
import '../../data/datasource/session/session.dart';
import 'repositores.dart';

class LocalSessionRepositoryImpl implements ILocalSessionRepository {
  final ILocalSessionDataSource localSessionDataSource;
  LocalSessionRepositoryImpl(this.localSessionDataSource);

  @override
  Future<void> clear() async {
    return await localSessionDataSource.clear();
  }

  @override
  Future<SessionModel?> get() async {
    return await localSessionDataSource.get();
  }

  @override
  Future<void> save(SessionModel session) async {
    return await localSessionDataSource.save(session);
  }
}
