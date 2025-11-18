import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../../enterprises/presentation/controllers/controllers.dart';
import '../../providers/providers.dart';

part 'insert_update_research_controller.g.dart';

@riverpod
class InsertUpdateResearchController extends _$InsertUpdateResearchController {
  @override
  FutureOr<void> build() {}

  Future<void> insertUpdate({
    required String name,
    required String? observations,
    required int? researchCode,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final validatedUser = await ref.watch(
        validatedUserSessionProvider.future,
      );
      final repository = ref.watch(soapInsertUpdateResearchRepositoryProvider);
      final selectedEnterprise = ref.watch(
        selectedEnterpriseStateControllerProvider,
      );
      await repository.insertUpdate(
        crossIdentity: validatedUser!.user.CrossIdentity_Usuario!,
        baseUrl: validatedUser.enterprise!.baseUrl!,
        enterpriseCode: selectedEnterprise!.Code!,
        name: name,
        observations: observations,
        researchCode: researchCode,
      );
    });
  }
}
