import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../../../core/providers/products/products.dart';
import '../../../../features/enterprises/presentation/controllers/controllers.dart';
import '../../../../core/domain/entities/entities.dart';

part 'selected_product_state_controller.g.dart';

@riverpod
class SelectedProductStateController extends _$SelectedProductStateController {
  @override
  Future<ProductEntity?> build(int enterpriseCode, String plu) async {
    // Timer? timer;
    // final link = ref.keepAlive();
    // ref.onCancel(() {
    //   timer = Timer(const Duration(seconds: 20), () {
    //     link.close();
    //   });
    // });
    // ref.onResume(() {
    //   timer?.cancel();
    // });
    // ref.onDispose(() {
    //   timer?.cancel();
    // });

    if (state.value != null) {
      return state.value;
    }

    final userSession = await ref.watch(validatedUserSessionProvider.future);
    final enterprises = await ref.watch(
      enterprisesStateControllerProvider(enterpriseCode: enterpriseCode).future,
    );
    final enterpriseEntity = enterprises.first;
    final products = await ref
        .read(soapLoadProductsRepositoryProvider)
        .load(
          baseUrl: userSession!.enterprise!.baseUrl!,
          crossIdentity: userSession.user.CrossIdentity_Usuario!,
          enterpriseEntity: enterpriseEntity,
          getProductsDefaultParams: GetProductsJsonParams(
            searchValue: plu,
            routine: BsRoutine.adjustSalePrice,
            searchType: SearchType.dynamic,
            EnterpriseCodes: [enterpriseCode],
            LastBuyEntranceQuantity: null,
            buyRequestParams: null,
            competingPricesParams: null,
          ),
        );

    return products.first;
  }
}
