import 'dart:async';

import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/features/competing_prices/domain/entities/entities.dart';
import 'package:celta_inventario/features/competing_prices/providers/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:celta_inventario/utils/utils.dart';
part 'researchs_state_controller.g.dart';

@riverpod
class ResearchsStateController extends _$ResearchsStateController {
  @override
  Future<List<ResearchEntity>> build(int enterpriseCode) async {
    ref.cache();
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
    final researchs = await repository.load(
      crossIdentity: validatedUserSession!.user.CrossIdentity_Usuario!,
      workingUrl: validatedUserSession.enterprise!.workingUrl!,
      enterpriseCode: enterpriseCode,
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
    final currentState = state.value;
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
