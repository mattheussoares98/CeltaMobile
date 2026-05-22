import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:celta_inventario/features/enterprise_manager/providers.dart';

part 'create_enterprise_controller.g.dart';

@riverpod
class CreateEnterpriseController extends _$CreateEnterpriseController {
  @override
  FutureOr<void> build() {}

  Future<void> createEnterprise({
    required String enterpriseName,
    required String remoteHttpUrl,
    required String? remoteHttpsUrl,
    required String? localHttpUrl,
    required String? localHttpsUrl,
    required String userName,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(enterpriseManagerRepositoryProvider)
          .createEnterprise(
            enterpriseName: enterpriseName,
            remoteHttpUrl: remoteHttpUrl,
            remoteHttpsUrl: remoteHttpsUrl,
            localHttpUrl: localHttpUrl,
            localHttpsUrl: localHttpsUrl,
            userName: userName,
            password: password,
          );
      ref.invalidateSelf();
    });
  }
}
