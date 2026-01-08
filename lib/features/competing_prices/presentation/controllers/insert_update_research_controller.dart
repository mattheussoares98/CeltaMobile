import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../../enterprises/presentation/controllers/controllers.dart';
import '../../domain/entities/entities.dart';
import '../../providers/providers.dart';
import 'controllers.dart';

part 'insert_update_research_controller.g.dart';

@riverpod
class InsertUpdateResearchController extends _$InsertUpdateResearchController {
  @override
  FutureOr<void> build() {}

  Future<bool> insertUpdate({
    required String name,
    required String? observations,
    required int? researchCode,
    ConcurrentEntity? concurrentToAssociate,
  }) async {
    state = const AsyncValue.loading();
    bool succeeds = false;
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
        urlInUse: validatedUser.enterprise!.urlInUse!,
        enterpriseCode: selectedEnterprise!.Code!,
        name: name,
        observations: observations,
        researchCode: researchCode,
        concurrentToAssociate: concurrentToAssociate,
      );

      succeeds = true;
      if (researchCode != null) {
        ref
            .read(researchsStateControllerProvider.notifier)
            .updateResearchLocally(
              code: researchCode,
              name: name,
              observations: observations,
              newConcurrent: concurrentToAssociate,
            );
      } else {
        ref.invalidate(researchsStateControllerProvider);
      }
    });
    return succeeds;
  }
}
