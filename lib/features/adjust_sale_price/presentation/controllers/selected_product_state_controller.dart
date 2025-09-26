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
  Future<ProductEntity?> build(
    int enterpriseCode,
    String plu,
    ProductEntity? product,
  ) async {
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

    if (product != null) {
      return product;
    }

    final userSession = await ref.watch(validatedUserSessionProvider.future);
    final enterprises = await ref.watch(
      enterprisesStateControllerProvider.future,
    );
    final enterpriseEntity = enterprises.firstWhere(
      (e) => e.Code == enterpriseCode,
    );
    final products = await ref
        .read(soapProductsRepositoryProvider)
        .getProductsJson(
          baseUrl: userSession!.enterprise.baseUrl!,
          crossIdentity: userSession.user.CrossIdentity_Usuario!,
          searchValue: plu,
          routine: BsRoutine.adjustSalePrice,
          searchType: SearchType.dynamic,
          enterpriseCodes: [enterpriseCode],
          enterpriseEntity: enterpriseEntity,
          lastBuyEntranceQuantity: null,
        );

    return products.first;
  }
}
