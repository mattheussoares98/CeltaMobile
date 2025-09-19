import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/providers.dart';
import '../../../../features/auth/presentation/controllers/controllers.dart';
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

    final user = await ref.watch(authStateControllerProvider.future);
    final userSession = await ref.watch(userSessionProvider.future);
    final enterprises = await ref.watch(
      enterprisesStateControllerProvider.future,
    );
    final enterpriseEntity = enterprises.firstWhere(
      (e) => e.Code == enterpriseCode,
    );
    final products = await ref
        .read(soapProductsRepositoryProvider)
        .getProductsJson(
          baseUrl: userSession!.baseUrl!,
          crossIdentity: user!.CrossIdentity_Usuario!,
          searchValue: plu,
          routine: Routine.adjustSalePrice,
          searchType: SearchType.dynamic,
          enterpriseCodes: [enterpriseCode],
          enterpriseEntity: enterpriseEntity,
          lastBuyEntranceQuantity: null,
        );

    return products.first;
  }
}
