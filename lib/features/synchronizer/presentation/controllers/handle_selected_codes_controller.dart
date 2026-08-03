import 'dart:async';

import 'package:celta_inventario/core/providers/ec_request_params/ec_request_params.dart';
import 'package:celta_inventario/exceptions/exceptions.dart';
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';
import 'package:celta_inventario/features/synchronizer/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/synchronizer/providers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'handle_selected_codes_controller.g.dart';

@riverpod
class HandleSelectedCodesController extends _$HandleSelectedCodesController {
  @override
  FutureOr<void> build() {}

  Future<void> handle(
    List<int> codes,
    String errorKey,
    SynchronizerErrorDetailType detailType,
  ) async {
    if (codes.isEmpty) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(ecSynchronizerRepositoryProvider);
      final ecParams = await ref.read(ecRequestParamsProvider().future);

      final method = switch (detailType) {
        SynchronizerErrorDetailType.couponMarkedToReadAgain =>
          repository.markCouponsToReadAgain(ecParams, codes),
        SynchronizerErrorDetailType.schedule => repository.deleteScheduleErrors(
          ecParams,
          codes,
        ),
        SynchronizerErrorDetailType.saleRequestWithError =>
          repository.markSaleRequestsWithErrorToReadAgain(ecParams, codes),
        _ => throw AppException('Tipo de detalhe não implementado'.hardcoded),
      };

      await method;

      ref.invalidate(synchronizerDetailsStateControllerProvider(errorKey));
      ref.invalidate(
        selectedSynchronizerCodesStateControllerProvider(detailType),
      );
    });
  }
}
