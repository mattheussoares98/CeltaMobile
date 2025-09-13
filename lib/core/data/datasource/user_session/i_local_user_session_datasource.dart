import '../../models/models.dart';

abstract class ILocalUserSessionDataSource {
  Future<void> save(UserSessionModel session);
  Future<UserSessionModel?> get();
  Future<void> clear();
}
