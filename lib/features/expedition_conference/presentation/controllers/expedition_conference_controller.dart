import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../domain/entities/entities.dart';
import '../../providers.dart';

part 'expedition_conference_controller.g.dart';

@riverpod
class ExpeditionConferenceController extends _$ExpeditionConferenceController {
  @override
  FutureOr<ExpeditionConferenceState> build(
    int expeditionControlCode,
    String enterpriseName,
  ) async {
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

  void scanProduct(ProductPackingCodeID productPackingCode) {
    if (state.value == null) return;
    final currentState = state.value!;
    final pendingQty = currentState.pendingQuantities[productPackingCode];

    if (pendingQty != null && pendingQty > 0) {
      final newPending = Map.of(currentState.pendingQuantities);
      final newScanned = Map.of(currentState.scannedQuantities);

      newPending[productPackingCode] = pendingQty - 1;
      newScanned[productPackingCode] =
          (newScanned[productPackingCode] ?? 0) + 1;

      state = AsyncData(
        currentState.copyWith(
          pendingQuantities: newPending,
          scannedQuantities: newScanned,
        ),
      );
    }
  }
}
