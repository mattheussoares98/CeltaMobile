import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../exceptions/exceptions.dart';
import '../../domain/entities/entities.dart';
import '../../providers.dart';

part 'enterprise_manager_controller.g.dart';

@riverpod
class EnterpriseManagerController extends _$EnterpriseManagerController
    with ErrorHandling {
  @override
  Future<List<EnterprisePermissionEntity>> build() {
    //dont need to put in a try catch because the riverpor already treat this and return async error if throws
    return ref
        .watch(enterpriseManagerRepositoryProvider)
        .getAllEnterprisePermissions();
  }

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
