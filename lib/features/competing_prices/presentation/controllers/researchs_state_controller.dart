import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../../enterprises/presentation/controllers/controllers.dart';
import '../../domain/entities/entities.dart';
import '../../providers/providers.dart';

part 'researchs_state_controller.g.dart';

@riverpod
class ResearchsStateController extends _$ResearchsStateController {
  @override
  Future<List<ResearchEntity>> build() async {
    Timer? timer;
    final link = ref.keepAlive();
    ref.onCancel(() {
      timer = Timer(const Duration(seconds: 20), () {
        link.close();
      });
    });
    ref.onResume(() {
      timer?.cancel();
    });
    ref.onDispose(() {
      timer?.cancel();
    });
    return await _load(null);
  }

  Future<void> load(String? searchValue) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await _load(searchValue);
    });
  }

  Future<List<ResearchEntity>> _load(String? searchValue) async {
    final repository = ref.read(soapLoadResearchsRepositoryProvider);
    final validatedUserSession = await ref.watch(
      validatedUserSessionProvider.future,
    );
    final selectedEnterprise = ref.watch(
      selectedEnterpriseStateControllerProvider,
    );

    final researchs = await repository.load(
      crossIdentity: validatedUserSession!.user.CrossIdentity_Usuario!,
      workingUrl: validatedUserSession.enterprise!.workingUrl!,
      enterpriseCode: selectedEnterprise!.Code!,
      searchValue: searchValue,
    );

    return researchs;
  }

  void updateResearchLocally({
    required int code,
    required String name,
    required String? observations,
    ConcurrentEntity? newConcurrent,
  }) {
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    final index = currentState.indexWhere((e) => e.Code == code);
    if (index != -1) {
      final updatedList = List<ResearchEntity>.from(currentState);
      final oldValue = updatedList[index];
      updatedList[index] = oldValue.copyWith(
        Name: name,
        Observation: observations,
        Concurrents: [...?oldValue.Concurrents, ?newConcurrent],
      );
      state = AsyncData(updatedList);
    }
  }
}
