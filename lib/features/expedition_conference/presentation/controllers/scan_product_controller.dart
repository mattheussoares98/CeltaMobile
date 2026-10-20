import 'package:celta_inventario/core/domain/errors/errors.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:celta_inventario/exceptions/exceptions.dart';
import 'package:celta_inventario/features/expedition_conference/domain/entities/entities.dart';
import 'package:celta_inventario/features/expedition_conference/presentation/controllers/controllers.dart';

part 'scan_product_controller.g.dart';

@riverpod
class ScanProductController extends _$ScanProductController {
  @override
  FutureOr<void> build() async {}

  FutureOr<bool> scan({
    required int expeditionControlCode,
    required ProductPackingCodeID productPackingCode,
    required int stepCode,
  }) async {
    bool succeeds = false;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final currentState = await ref.read(
        expeditionConferenceControllerProvider(expeditionControlCode).future,
      );
      final pendingQty = currentState.pendingQuantities[productPackingCode];

      if (pendingQty == null || pendingQty <= 0) {
        throw AppException.localized(
          CoreFailure.thisProductIsNotPendingVerification,
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

      ref
          .read(
            expeditionConferenceControllerProvider(
              expeditionControlCode,
            ).notifier,
          )
          .updateState(newState);
      succeeds = true;
    });
    return succeeds;
  }
}
