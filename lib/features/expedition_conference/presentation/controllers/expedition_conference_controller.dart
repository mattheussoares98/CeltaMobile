import 'dart:async';

import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../domain/entities/entities.dart';
import '../../providers.dart';
import 'controllers.dart';

part 'expedition_conference_controller.g.dart';

@riverpod
class ExpeditionConferenceController extends _$ExpeditionConferenceController {
  @override
  FutureOr<ExpeditionConferenceState> build(int expeditionControlCode) async {
    final userSession = await ref.watch(validatedUserSessionProvider.future);

    final initialProducts = await ref
        .read(soapLoadPendingProductsRepositoryProvider)
        .load(
          baseUrl: userSession!.enterprise!.baseUrl!,
          crossIdentity: userSession.user.CrossIdentity_Usuario!,
          expeditionControlCode: expeditionControlCode,
        );

    return ExpeditionConferenceState(
      initialProducts: initialProducts,
      pendingQuantities: {
        for (var p in initialProducts) p.ProductPackingCode: p.Quantity,
      },
      scannedQuantities: const {},
    );
  }

  Future<void> scanProduct(
    ProductPackingCodeID productPackingCode,
    int stepCode,
  ) async {
    if (state.value == null) return;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final currentState = state.value!;
      final pendingQty = currentState.pendingQuantities[productPackingCode];

      if (pendingQty == null || pendingQty <= 0) {
        throw AsyncError(
          Exception(
            'Esse produto não está pendente para conferência'.hardcoded,
          ),
          StackTrace.current,
        );
      }

      final newPending = Map.of(currentState.pendingQuantities);
      final newScanned = Map.of(currentState.scannedQuantities);

      newPending[productPackingCode] = pendingQty - 1;
      newScanned[productPackingCode] =
          (newScanned[productPackingCode] ?? 0) + 1;

      final newState = currentState.copyWith(
        pendingQuantities: newPending,
        scannedQuantities: newScanned,
      );

      if (newState.isComplete) {
        await ref
            .read(confirmConferenceControllerProvider.notifier)
            .confirm(
              expeditionControlCode: expeditionControlCode,
              stepCode: stepCode,
            );
      }

      return newState;
    });
  }
}
