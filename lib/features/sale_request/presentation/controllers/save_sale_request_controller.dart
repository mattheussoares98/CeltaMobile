import 'package:celta_inventario/exceptions/exceptions.dart';
import 'package:celta_inventario/localization/localization.dart';
import 'package:celta_inventario/localization/providers.dart';
import 'dart:async';

import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/app_usage/app_usage.dart';
import 'package:celta_inventario/core/presentation/controllers/resource/resource.dart';
import 'package:celta_inventario/core/providers/ec_request_params/ec_request_params.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/sale_request/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'save_sale_request_controller.g.dart';

@Riverpod(
  dependencies: [InsertUpdateStateController, saleRequestNeedsProcessing],
)
class SaveSaleRequestController extends _$SaveSaleRequestController {
  AppLocalizations get _l10n => ref.read(appLocalizationsProvider);

  @override
  FutureOr<void> build(int enterpriseCode) {}

  Future<(String?, bool)> saveBsfSaleRequest(bool isOnlyValidating) async {
    String? errorMessage;
    bool canSaveAndNeedProcessCart = false;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final params = await ref.read(ecRequestParamsProvider().future);
      final saleRequest = await ref.read(
        insertUpdateStateControllerProvider.future,
      );
      final customerCode = saleRequest.customer?.code;
      final saleRequestId = saleRequest.code ?? 0;

      if (customerCode == null) {
        errorMessage = _l10n.pleaseSelectACustomerBeforeSaving;
        return;
      } else if (saleRequest.products == null ||
          saleRequest.products!.isEmpty) {
        errorMessage = _l10n.addAtLeastOneProductToTheOrder;
        return;
      } else if (saleRequest.requestType == null ||
          saleRequest.requestType?.code == null) {
        errorMessage =
            _l10n.noOrderTemplateSelectedThisIsAProgrammingErrorPlease;
        return;
      } else if (!saleRequest.isPaymentValid) {
        errorMessage =
            _l10n.thisOrderTemplateRequiresPaymentDetailsPleaseFillInThe;
        return;
      }

      final needsProcessingCart = ref.read(saleRequestNeedsProcessingProvider);

      if (needsProcessingCart) {
        final requestTypeAllowChangePriceOrCost =
            saleRequest.requestType?.allowAlterCostOrSalePrice == true;

        canSaveAndNeedProcessCart =
            await ref.read(
              canAccessResourceStateControllerProvider(
                BsRoutine.saleRequest,
                BsResource.saleRequestChangeTPrice,
              ).future,
            ) &&
            requestTypeAllowChangePriceOrCost;

        if (!requestTypeAllowChangePriceOrCost) {
          errorMessage =
              _l10n.thisOrderTemplateDoesNotAllowPriceChangesProcessThe;
          return;
        } else if (!canSaveAndNeedProcessCart) {
          errorMessage = _l10n.yourUserDoesNotHavePermissionToChangeOrderPrices;
          return;
        }
      }

      if (needsProcessingCart && isOnlyValidating) {
        errorMessage = _l10n.thisOrderHasNotBeenProcessedToCalculatePricesBased;
        return;
      } else if (isOnlyValidating) {
        return;
      }

      if (saleRequestId == 0) {
        ref
            .read(appUsageStateControllerProvider.notifier)
            .addUsage(UsageType.insertSaleRequest);

        await ref
            .read(ecSaleRequestsRepositoryProvider)
            .insert(
              saleRequest: saleRequest,
              enterpriseCode: enterpriseCode,
              params: params,
            );
        final args = ref.read(saleRequestArgsProvider);
        ref
            .read(localBsfSaleRequestDraftRepositoryProvider)
            .save(
              BSFSaleRequestEntity.empty().copyWith(
                requestType: saleRequest.requestType,
              ),
              enterpriseCode: args.enterpriseCode,
              requestTypeCode: args.requestTypeCode ?? 0,
            );
        ref.invalidate(insertUpdateStateControllerProvider);
        ref.invalidate(saleRequestsStateControllerProvider(enterpriseCode));
      } else {
        ref
            .read(appUsageStateControllerProvider.notifier)
            .addUsage(UsageType.updateSaleRequest);

        await ref
            .read(ecSaleRequestsRepositoryProvider)
            .update(
              saleRequest: saleRequest,
              enterpriseCode: enterpriseCode,
              params: params,
            );

        final updatedBsfEntity = await ref
            .read(ecSaleRequestsRepositoryProvider)
            .getComplete(
              enterpriseCode: enterpriseCode,
              customerCode: customerCode,
              saleRequestCode: saleRequestId,
              params: params,
            );

        ref
            .read(saleRequestsStateControllerProvider(enterpriseCode).notifier)
            .updateSingleRequestInList(updatedBsfEntity.toSaleRequestEntity());

        ref.invalidate(
          saleRequestDetailsStateControllerProvider(
            SaleRequestArgs(
              enterpriseCode: enterpriseCode,
              customerCode: customerCode,
              saleRequestId: saleRequestId,
            ),
          ),
        );
      }
    });
    if (state.hasError) {
      errorMessage = parseErrorMessage(state.error, translations: _l10n);
    }

    return (errorMessage, canSaveAndNeedProcessCart);
  }
}
