import '../../../domain/entities/entities.dart';

abstract class ISupabaseUserSessionDatasource {
  Future<void> handleUserSession({
    required String userName,
    required DeviceType deviceType,
    required int firebaseEnterpriseId,
    required String? fcmToken,
    required String appVersion,
  });

  Future<void> removeUserSession({
    required String userName,
    required DeviceType deviceType,
    required int enterpriseId,
  });
}
