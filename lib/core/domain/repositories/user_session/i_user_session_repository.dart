import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';

abstract class IUserSessionRepository {
  Future<void> save(UserSessionModel session);
  Future<UserSessionModel?> get();
  Future<void> synchronizeRemoteSession({
    required String userName,
    required DeviceType deviceType,
    required int enterpriseId,
    required String? fcmToken,
    required String appVersion,
  });
  Future<void> logout();
}
