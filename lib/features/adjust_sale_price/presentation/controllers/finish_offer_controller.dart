import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/features/enterprises/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/adjust_sale_price/domain/entities/entities.dart';
import 'package:celta_inventario/features/adjust_sale_price/providers.dart';

part 'finish_offer_controller.g.dart';

@riverpod
class FinishOfferController extends _$FinishOfferController {
  @override
  FutureOr<void> build(int productPackingCode, int? enterpriseCode) {}

  Future<void> finish({
    required ProductEntity product,
    required SaleType saleType,
    required DateTime now,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final userSession = await ref.watch(validatedUserSessionProvider.future);

      final selectedEnterprise = ref.read(
        selectedEnterpriseStateControllerProvider,
      );

      await ref
          .read(soapAdjustSalePriceRepositoryProvider)
          .confirm(
            workingUrl: userSession!.enterprise!.workingUrl!,
            crossIdentity: userSession.user.CrossIdentity_Usuario!,
            enterpriseCode: enterpriseCode ?? selectedEnterprise!.Code!,
            productCode: product.ProductCode!,
            productPackingCode: productPackingCode,
            saleType: saleType,
            replications: [],
            offerParams: OfferParams(
              price: 0,
              effectuationDateOffer: now,
              endDateOffer: null,
            ),
            retailParams: null,
            now: now,
          );
    });
  }
}
