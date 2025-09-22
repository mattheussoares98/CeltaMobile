import 'package:celta_intelligence/core/providers/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/entities/entities.dart';
import '../../../auth/presentation/controllers/controllers.dart';
import '../../../enterprises/presentation/controllers/controllers.dart';
import '../../domain/entities/entities.dart';
import '../../providers.dart';

part 'finish_offer_controller.g.dart';

@riverpod
class FinishOfferController extends _$FinishOfferController {
  @override
  FutureOr<void> build() {}

  Future<void> finish({
    required ProductEntity product,
    required SaleType saleType,
    required DateTime now,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final userSession = await ref.watch(userSessionProvider.future);
      final userEntity = await ref.watch(authStateControllerProvider.future);
      final selectedEnterprise = ref.watch(
        selectedEnterpriseStateControllerProvider,
      );

      await ref
          .read(soapAdjustSalePriceRepositoryProvider)
          .confirm(
            baseUrl: userSession!.baseUrl!,
            crossIdentity: userEntity!.CrossIdentity_Usuario!,
            enterpriseCode: selectedEnterprise!.Code!,
            productCode: product.ProductCode,
            productPackingCode: product.ProductPackingCode,
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
