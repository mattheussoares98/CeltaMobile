import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../domain/entities/entities.dart';
import 'user_session.dart';

class SupabaseUserSessionDatasource implements ISupabaseUserSessionDatasource {
  final SupabaseClient _supabase;
  SupabaseUserSessionDatasource(this._supabase);

  @override
  Future<void> handleUserSession({
    required String userName,
    required DeviceType deviceType,
    required int firebaseEnterpriseId,
    required String? fcmToken,
    required String appVersion,
  }) async {
    await _supabase.rpc(
      'handle_user_session',
      params: {
        'p_user_name': userName,
        'p_device_type': deviceType.name.toLowerCase(),
        'p_enterprise_id': firebaseEnterpriseId,
        'p_fcm_token': fcmToken,
        'p_app_version': appVersion,
      },
    );
  }

  @override
  Future<void> removeUserSession({
    required String userName,
    required DeviceType deviceType,
    required int enterpriseId,
  }) async {
    await _supabase.rpc(
      'delete_user_session',
      params: {
        'p_user_name': userName,
        'p_device_type': deviceType.name.toLowerCase(),
        'p_enterprise_id': enterpriseId,
      },
    );
  }
}
