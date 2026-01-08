import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../domain/entities/entities.dart';
import '../../providers.dart';
import 'controllers.dart';

part 'confirm_adjust_controller.g.dart';

@riverpod
class ConfirmAdjustController extends _$ConfirmAdjustController {
  @override
  FutureOr<void> build() {}

  Future<void> confirm({
    required int enterpriseCode,
    required String plu,
    required double price,
    required DateTime now,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final userSession = await ref.watch(validatedUserSessionProvider.future);
      final selectedProduct = await ref.read(
        selectedProductStateControllerProvider(enterpriseCode, plu).future,
      );
      final uiState = await ref.read(uIStateControllerProvider(plu).future);

      await ref
          .read(soapAdjustSalePriceRepositoryProvider)
          .confirm(
            urlInUse: userSession!.enterprise!.urlInUse!,
            crossIdentity: userSession.user.CrossIdentity_Usuario!,
            enterpriseCode: enterpriseCode,
            productCode: selectedProduct!.ProductCode!,
            productPackingCode: selectedProduct.ProductPackingCode!,
            saleType: uiState.selectedSaleType!,
            replications: uiState.selectedReplications.toList(),
            offerParams: uiState.selectedPriceType == PriceType.offer
                ? OfferParams(
                    price: price,
                    effectuationDateOffer: uiState.selectedStartDate,
                    endDateOffer: uiState.selectedEndDate,
                  )
                : null,
            retailParams: uiState.selectedPriceType == PriceType.sale
                ? RetailParams(
                    price: price,
                    effectuationDatePrice: uiState.selectedStartDate,
                  )
                : null,
            now: now,
          );
    });
  }
}
