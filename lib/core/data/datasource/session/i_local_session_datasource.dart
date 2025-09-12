import '../../models/models.dart';

abstract class ILocalSessionDataSource {
  Future<void> save(SessionModel session);
  Future<SessionModel?> get();
  Future<void> clear();
}
