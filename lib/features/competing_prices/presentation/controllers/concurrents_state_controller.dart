import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/entities/entities.dart';
import '../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../domain/entities/entities.dart';
import '../../providers/providers.dart';

part 'concurrents_state_controller.g.dart';

@riverpod
class ConcurrentsStateController extends _$ConcurrentsStateController {
  @override
  Future<List<ConcurrentEntity>> build() async {
    final validatedUser = await ref.watch(validatedUserSessionProvider.future);

    return await ref
        .read(soapConcurrentsRepositoryProvider)
        .load(
          crossIdentity: validatedUser!.user.CrossIdentity_Usuario!,
          urlInUse: validatedUser.enterprise!.urlInUse!,
          searchValue: null,
        );
  }

  Future<void> insertUpdate({
    required int? concurrentCode,
    required String name,
    required String observation,
    required AddressEntity? address,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(soapConcurrentsRepositoryProvider);
      final validatedUser = await ref.watch(
        validatedUserSessionProvider.future,
      );

      await repository.insertUpdate(
        crossIdentity: validatedUser!.user.CrossIdentity_Usuario!,
        urlInUse: validatedUser.enterprise!.urlInUse!,
        concurrentCode: concurrentCode,
        concurrentName: name,
        observation: observation,
        address: address,
      );

      if (concurrentCode != null) {
        final concurrentUpdated = state.value!
            .firstWhere((e) => e.ConcurrentCode == concurrentCode)
            .copyWith(Name: name, Observation: observation, Address: address);

        final updatedList = List<ConcurrentEntity>.from(state.value!);
        final index = updatedList.indexWhere(
          (e) => e.ConcurrentCode == concurrentCode,
        );
        updatedList[index] = concurrentUpdated;
        return updatedList;
      } else {
        ref.invalidateSelf();
        return [];
      }
    });
  }
}
