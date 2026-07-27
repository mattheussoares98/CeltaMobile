import 'package:celta_inventario/core/domain/entities/entities.dart';

abstract class ISupabaseUserSessionDatasource {
  Future<void> handleUserSession({
    required String userName,
    required DeviceType deviceType,
    required int firebaseEnterpriseId,
    required String? fcmToken,
    required String appVersion,
    required String installationId,
  });

  Future<void> removeUserSession({required String installationId});
}
