import 'dart:async';

import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/providers/ec_request_params/ec_request_params.dart';
import 'package:celta_inventario/exceptions/exceptions.dart';
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';
import 'package:celta_inventario/features/synchronizer/domain/repositories/repositories.dart';
import 'package:celta_inventario/features/synchronizer/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/synchronizer/providers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'handle_selected_codes_controller.g.dart';

@riverpod
class HandleSelectedCodesController extends _$HandleSelectedCodesController {
  @override
  FutureOr<void> build() {}

  Future<void> markToReadAgain(
    List<int> codes,
    String errorKey,
    SynchronizerErrorDetailType detailType,
  ) async {
    if (codes.isEmpty) return;

    await _execute(
      errorKey,
      detailType,
      (repository, ecParams) => switch (detailType) {
        SynchronizerErrorDetailType.coupon => repository.markCouponsToReadAgain(
          ecParams,
          codes,
        ),
        SynchronizerErrorDetailType.saleRequestWithError =>
          repository.markSaleRequestsWithErrorToReadAgain(ecParams, codes),
        _ => throw AppException(
          'Tipo de detalhe para ler novamente não implementado'.hardcoded,
        ),
      },
    );
  }

  Future<void> deleteSelected(
    List<int> codes,
    String errorKey,
    SynchronizerErrorDetailType detailType,
  ) async {
    if (codes.isEmpty) return;

    await _execute(
      errorKey,
      detailType,
      (repository, ecParams) => switch (detailType) {
        SynchronizerErrorDetailType.schedule => repository.deleteScheduleErrors(
          ecParams,
          codes,
        ),
        SynchronizerErrorDetailType.saleRequestWithError =>
          repository.deleteSaleRequestsWithError(ecParams, codes),
        _ => throw AppException(
          'Tipo de detalhe para deletar não implementado'.hardcoded,
        ),
      },
    );
  }

  Future<bool> insertSaleRequestsToReadAgain(
    String errorKey, {
    required int enterpriseCode,
    required int enterpriseCommerceSiteCode,
    required List<String> saleRequestIds,
  }) async {
    if (saleRequestIds.isEmpty) return false;

    return await _execute(
      errorKey,
      SynchronizerErrorDetailType.saleRequestWithError,
      (repository, ecParams) => repository.insertSaleRequestsToReadAgain(
        ecParams,
        enterpriseCode: enterpriseCode,
        enterpriseCommerceSiteCode: enterpriseCommerceSiteCode,
        saleRequestIds: saleRequestIds,
      ),
    );
  }

  Future<bool> _execute(
    String errorKey,
    SynchronizerErrorDetailType detailType,
    Future<void> Function(IEcSynchronizerRepository, EcRequestParams) operation,
  ) async {
    bool succeeds = false;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(ecSynchronizerRepositoryProvider);
      final ecParams = await ref.read(ecRequestParamsProvider().future);

      await operation(repository, ecParams);
      succeeds = true;
      _invalidateAfterSuccess(errorKey, detailType);
    });
    return succeeds;
  }

  void _invalidateAfterSuccess(
    String errorKey,
    SynchronizerErrorDetailType detailType,
  ) {
    ref.invalidate(synchronizerDetailsStateControllerProvider(errorKey));
    ref.invalidate(
      selectedSynchronizerCodesStateControllerProvider(detailType),
    );
  }
}
