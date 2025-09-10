import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../exceptions/exceptions.dart';
import '../../providers.dart';

part 'create_enterprise_controller.g.dart';

@riverpod
class CreateEnterpriseController extends _$CreateEnterpriseController
    with ErrorHandling {
  @override
  FutureOr<void> build() {}

  Future<void> createEnterprise({
    required String enterpriseName,
    required String baseUrl,
    required String userName,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    final enterpriseManagerRepository = ref.read(
      enterpriseManagerRepositoryProvider,
    );

    try {
      await enterpriseManagerRepository.createEnterprise(
        enterpriseName: enterpriseName,
        baseUrl: baseUrl,
        userName: userName,
        password: password,
      );

      ref.invalidateSelf();
    } catch (e, st) {
      state = getAsyncError(e, st);
    }
  }
}
