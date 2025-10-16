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
      scannedQuantities: {},
    );
  }

  Future<void> scanProduct(
    ProductPackingCodeID productPackingCode,
    int stepCode,
  ) async {
    if (state.value == null) return;
    final currentState = state.value!;
    final pendingQty = currentState.pendingQuantities[productPackingCode];

    if (pendingQty == null || pendingQty <= 0) {
      state = AsyncError(
        Exception('Esse produto não está pendente para conferência'.hardcoded),
        StackTrace.current,
      );
      return;
    }

    if (pendingQty > 0) {
      final newPending = Map.of(currentState.pendingQuantities);
      final newScanned = Map.of(currentState.scannedQuantities);

      newPending[productPackingCode] = pendingQty - 1;
      newScanned[productPackingCode] =
          (newScanned[productPackingCode] ?? 0) + 1;

      final newState = currentState.copyWith(
        pendingQuantities: newPending,
        scannedQuantities: newScanned,
      );

      state = AsyncData(newState);

      if (newState.isComplete) {
        await ref
            .read(confirmConferenceControllerProvider.notifier)
            .confirm(
              expeditionControlCode: expeditionControlCode,
              stepCode: stepCode,
            );
      }
    }
  }
}
