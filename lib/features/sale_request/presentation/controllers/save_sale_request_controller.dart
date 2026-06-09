import 'dart:async';

import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/app_usage/app_usage.dart';
import 'package:celta_inventario/core/presentation/controllers/resource/resource.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/exceptions/app_exception.dart';
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

  Future<void> save({
    required int requestTypeCode,
    required String observations,
    required String instructions,
    required int enterpriseCode,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final validateduser = await ref.watch(
        validatedUserSessionProvider.future,
      );
      final pending = await ref.read(
        pendingSaleRequestStateControllerProvider(enterpriseCode).future,
      );

      if (pending.customer == null) {
        throw AppException('Selecione o cliente!'.hardcoded);
      }

      ref
          .read(appUsageStateControllerProvider.notifier)
          .addUsage(UsageType.insertSaleRequest);

      final saleRequestNumber = await ref
          .read(soapSaveSaleRequestRepositoryProvider)
          .save(
            workingUrl: validateduser!.enterprise!.workingUrl!,
            crossIdentity: validateduser.user.CrossIdentity_Usuario!,
            enterpriseCode: enterpriseCode,
            requestTypeCode: requestTypeCode,
            saleRequest: pending.copyWith(
              observations: observations,
              instructions: instructions,
            ),
          );

      await ref
          .read(
            lastSavedSaleRequestStateControllerProvider(
              enterpriseCode,
            ).notifier,
          )
          .save(
            LastSavedSaleRequestEntity(
              saleRequestEntity: pending.copyWith(
                observations: observations,
                instructions: instructions,
              ),
              saleRequestNumber: saleRequestNumber!,
            ),
          );

      await ref.read(localSaleRequestRepositoryProvider).clear(enterpriseCode);
      ref.invalidate(localSaleRequestRepositoryProvider);
    });
  }

  Future<(String?, bool)> saveBsfSaleRequest({
    required int customerCode,
    required int saleRequestId, //0 == insert
    required bool isOnlyValidating,
  }) async {
    String? errorMessage;
    bool canSaveAndNeedProcessCart = false;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final userSession = await ref.read(validatedUserSessionProvider.future);
      final saleRequest = await ref.read(
        insertUpdateStateControllerProvider.future,
      );

      if (saleRequest.customer == null || saleRequest.customer?.code == null) {
        errorMessage =
            'Por favor, selecione um cliente antes de salvar.'.hardcoded;
        return;
      }

      if (saleRequest.products == null || saleRequest.products!.isEmpty) {
        errorMessage = 'Adicione pelo menos um produto ao pedido.'.hardcoded;
        return;
      }

      if (saleRequest.requestType == null ||
          saleRequest.requestType?.code == null) {
        errorMessage =
            'O modelo de pedido não está selecionado. Esse erro jamais deveria acontecer, é um erro de programação. Entre em contato com o suporte técnico'
                .hardcoded;
        return;
      }

      if (!saleRequest.isPaymentValid) {
        errorMessage =
            'O modelo de pedido obriga a que o financeiro seja informado. Por favor, preencha as formas de pagamento corretamente.'
                .hardcoded;
        return;
      }

      final needsProcessingCart = ref.read(saleRequestNeedsProcessingProvider);

      if (needsProcessingCart) {
        canSaveAndNeedProcessCart = await ref.read(
          canAccessResourceStateControllerProvider(
            BsRoutine.saleRequest,
            BsResource.saleRequestChangeTPrice,
          ).future,
        );
        final requestTypeAllowChangePriceOrCost =
            saleRequest.requestType?.allowAlterCostOrSalePrice == true;

        if (!canSaveAndNeedProcessCart || !requestTypeAllowChangePriceOrCost) {
          errorMessage =
              'O modelo de pedido não permite alterar os preços ou o usuário não possui permissão para alterar os preços no pedido. \n\nO pedido precisa ser processado antes de ser salvo.'
                  .hardcoded;
          return;
        }
      }

      if (needsProcessingCart && isOnlyValidating) {
        errorMessage =
            'O pedido ainda não foi processado para calcular os preços de acordo com promoções, negociações de vendas, oferta, atacado, preço praticado pelo modelo de pedido, etc!\n\n Deseja salvar mesmo assim?'
                .hardcoded;
        return;
      }

      if (isOnlyValidating) {
        return;
      }

      final params = EcRequestParams(
        workingUrl: userSession!.enterprise!.workingUrl!,
        user: userSession.user.name!,
        accessKey: userSession.user.AccessKey!,
      );

      await ref
          .read(ecSaleRequestsRepositoryProvider)
          .update(
            saleRequest: saleRequest,
            enterpriseCode: enterpriseCode,
            params: params,
          );

      if (saleRequestId != 0) {
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
