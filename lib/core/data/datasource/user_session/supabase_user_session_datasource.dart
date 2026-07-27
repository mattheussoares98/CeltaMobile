import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/data/datasource/user_session/user_session.dart';

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
    required String installationId,
  }) async {
    await _supabase.rpc(
      'handle_user_session_v2',
      params: {
        'p_user_name': userName,
        'p_device_type': deviceType.name.toLowerCase(),
        'p_enterprise_id': firebaseEnterpriseId,
        'p_fcm_token': fcmToken,
        'p_app_version': appVersion,
        'p_installation_id': installationId,
      },
    );
  }

  @override
  Future<void> removeUserSession({required String installationId}) async {
    await _supabase.rpc(
      'delete_user_session_v2',
      params: {'p_installation_id': installationId},
    );
  }
}
