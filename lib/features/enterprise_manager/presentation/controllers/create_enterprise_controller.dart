import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../providers.dart';

part 'create_enterprise_controller.g.dart';

@riverpod
class CreateEnterpriseController extends _$CreateEnterpriseController {
  @override
  FutureOr<void> build() {}

  Future<void> createEnterprise({
    required String enterpriseName,
    required String urlInUse,
    required String userName,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(enterpriseManagerRepositoryProvider)
          .createEnterprise(
            enterpriseName: enterpriseName,
            urlInUse: urlInUse,
            userName: userName,
            password: password,
          );
      ref.invalidateSelf();
    });
  }
}
