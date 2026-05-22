import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/enterprises/enterprises.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/core/providers/products/products.dart';

part 'selected_product_state_controller.g.dart';

@riverpod
class SelectedProductStateController extends _$SelectedProductStateController {
  @override
  FutureOr<ProductEntity?> build(int enterpriseCode, String plu) {
    Timer? timer;
    final link = ref.keepAlive();
    ref.onCancel(() {
      timer = Timer(const Duration(seconds: 1), () {
        //only the enough to don't lose the state while is changing the page
        link.close();
      });
    });
    ref.onResume(() {
      timer?.cancel();
    });
    ref.onDispose(() {
      timer?.cancel();
    });
    return null;
  }

  Future<void> updateSelectedProduct(ProductEntity? product) async {
    //! when creates the screen, call this function below that treat if need to get the product remotely or not

    if (product != null) {
      state = AsyncData(product);
    } else {
      state = const AsyncLoading();
      state = await AsyncValue.guard(() async {
        if (state.value != null) {
          return state.value;
        }

        final userSession = await ref.watch(
          validatedUserSessionProvider.future,
        );
        final enterprises = await ref.watch(
          enterprisesStateControllerProvider(
            enterpriseCode: enterpriseCode,
          ).future,
        );
        final enterpriseEntity = enterprises.first;
        final products = await ref
            .read(soapLoadProductsRepositoryProvider)
            .load(
              workingUrl: userSession!.enterprise!.workingUrl!,
              crossIdentity: userSession.user.CrossIdentity_Usuario!,
              enterpriseEntity: enterpriseEntity,
              searchType: SearchType.dynamic,
              getProductsDefaultParams: GetProductsJsonParams(
                searchValue: plu,
                routine: BsRoutine.adjustSalePrice,
                enterpriseCodes: [enterpriseCode],
                lastBuyEntranceQuantity: null,
                buyRequestParams: null,
                competingPricesParams: null,
              ),
            );

        return products.first;
      });
    }
  }
}
