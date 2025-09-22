import 'package:celta_intelligence/core/providers/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../auth/presentation/controllers/controllers.dart';
import '../../domain/entities/entities.dart';
import '../../providers.dart';

part 'finish_offer_controller.g.dart';

@riverpod
class FinishOfferController extends _$FinishOfferController {
  @override
  FutureOr<void> build() async {
    return;
  }

  Future<void> finish({
    required int enterpriseCode,
    required int productCode,
    required int productPackingCode,
    required SaleType saleType,
    required OfferParams? offerParams,
    required DateTime now,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final userSession = await ref.watch(userSessionProvider.future);
      final userEntity = await ref.watch(authStateControllerProvider.future);

      await ref
          .read(soapAdjustSalePriceRepositoryProvider)
          .confirm(
            baseUrl: userSession!.baseUrl!,
            crossIdentity: userEntity!.CrossIdentity_Usuario!,
            enterpriseCode: enterpriseCode,
            productCode: productCode,
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
