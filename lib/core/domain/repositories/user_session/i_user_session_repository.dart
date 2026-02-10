import '../../../data/models/models.dart';
import '../../entities/entities.dart';

abstract class IUserSessionRepository {
  Future<void> save(UserSessionModel session);
  Future<UserSessionModel?> get();
  Future<void> logout({
    required String userName,
    required DeviceType deviceType,
    required int enterpriseId,
  });
}
