import '../../../data/models/models.dart';

abstract class IUserSessionRepository {
  Future<void> save(UserSessionModel session);
  Future<UserSessionModel?> get();
  Future<void> logout();
}
