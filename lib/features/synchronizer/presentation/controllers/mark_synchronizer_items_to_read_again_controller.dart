import 'dart:async';

import 'package:celta_inventario/core/providers/ec_request_params/ec_request_params.dart';
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';
import 'package:celta_inventario/features/synchronizer/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/synchronizer/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mark_synchronizer_items_to_read_again_controller.g.dart';

@riverpod
class MarkSynchronizerItemsToReadAgainController
    extends _$MarkSynchronizerItemsToReadAgainController {
  //TODO change to markCouponsToReadAgainController
  @override
  FutureOr<void> build() {}

  Future<void> markToReadAgain(List<int> codes, String errorKey) async {
    if (codes.isEmpty) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(ecSynchronizerRepositoryProvider);
      final ecParams = await ref.read(ecRequestParamsProvider().future);

      await repository.markCouponsToReadAgain(ecParams, codes);

      ref.invalidate(synchronizerDetailsStateControllerProvider(errorKey));
      ref.invalidate(
        selectedSynchronizerCodesStateControllerProvider(
          SynchronizerErrorDetailType.couponMarkedToReadAgain,
        ),
      );
    });
  }
}
