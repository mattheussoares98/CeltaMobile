import '../../../data/models/models.dart';

abstract class ILocalUserSessionRepository {
  Future<void> save(UserSessionModel session);
  Future<UserSessionModel?> get();
  Future<void> clear();
}
