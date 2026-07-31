import 'dart:async';

import 'package:celta_inventario/core/providers/ec_request_params/ec_request_params.dart';
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';
import 'package:celta_inventario/features/synchronizer/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mark_synchronizer_items_to_read_again_controller.g.dart';

@riverpod
class MarkSynchronizerItemsToReadAgainController
    extends _$MarkSynchronizerItemsToReadAgainController {
  @override
  FutureOr<void> build(SynchronizerErrorDetailType detailType) {
    switch (detailType) {
      case SynchronizerErrorDetailType.coupon:
        break;
      default:
        throw UnsupportedError('Rereading is not implemented for $detailType');
    }
  }

  Future<void> markToReadAgain(List<int> codes) async {
    if (codes.isEmpty) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(ecSynchronizerRepositoryProvider);
      final ecParams = await ref.read(ecRequestParamsProvider().future);

      switch (detailType) {
        case SynchronizerErrorDetailType.coupon:
          await repository.markCouponsToReadAgain(ecParams, codes);
        default:
          throw UnsupportedError(
            'Rereading is not implemented for $detailType',
          );
      }
    });
  }
}
