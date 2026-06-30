import 'dart:async';

import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/app_usage/app_usage.dart';
import 'package:celta_inventario/core/presentation/controllers/resource/resource.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/sale_request/providers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'save_sale_request_controller.g.dart';

@Riverpod(
  dependencies: [InsertUpdateStateController, saleRequestNeedsProcessing],
)
class SaveSaleRequestController extends _$SaveSaleRequestController {
  @override
  FutureOr<void> build(int enterpriseCode) {}

  Future<(String?, bool)> saveBsfSaleRequest(bool isOnlyValidating) async {
    String? errorMessage;
    bool canSaveAndNeedProcessCart = false;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final userSession = await ref.read(validatedUserSessionProvider.future);
      final saleRequest = await ref.read(
        insertUpdateStateControllerProvider.future,
      );
      final customerCode = saleRequest.customer?.code;
      final saleRequestId = saleRequest.code ?? 0;

      if (customerCode == null) {
        errorMessage =
            'Por favor, selecione um cliente antes de salvar.'.hardcoded;
        return;
      } else if (saleRequest.products == null ||
          saleRequest.products!.isEmpty) {
        errorMessage = 'Adicione pelo menos um produto ao pedido.'.hardcoded;
        return;
      } else if (saleRequest.requestType == null ||
          saleRequest.requestType?.code == null) {
        errorMessage =
            'O modelo de pedido não está selecionado. Esse erro jamais deveria acontecer, é um erro de programação. Entre em contato com o suporte técnico'
                .hardcoded;
        return;
      } else if (!saleRequest.isPaymentValid) {
        errorMessage =
            'O modelo de pedido obriga a que o financeiro seja informado. Por favor, preencha as formas de pagamento corretamente.'
                .hardcoded;
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
              'O modelo de pedido não permite alterar os preços. Por isso, processe o carrinho.'
                  .hardcoded;
          return;
        } else if (!canSaveAndNeedProcessCart) {
          errorMessage =
              'O usuário não possui permissão para alterar os preços no pedido. Por isso, processe o carrinho'
                  .hardcoded;
          return;
        }
      }

      if (needsProcessingCart && isOnlyValidating) {
        errorMessage =
            'O pedido ainda não foi processado para calcular os preços de acordo com promoções, negociações de vendas, oferta, atacado, preço praticado pelo modelo de pedido, etc!\n\n Deseja salvar mesmo assim?'
                .hardcoded;
        return;
      } else if (isOnlyValidating) {
        return;
      }

      final params = EcRequestParams(
        workingUrl: userSession!.enterprise!.workingUrl!,
        user: userSession.user.name!,
        accessKey: userSession.user.AccessKey!,
      );

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
      errorMessage = state.error.toString();
    }

    return (errorMessage, canSaveAndNeedProcessCart);
  }
}
