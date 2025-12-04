import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/entities/entities.dart';
import '../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../../../core/providers/products/products.dart';
import '../../../enterprises/presentation/controllers/controllers.dart';
import '../../../settings/presentation/controllers/controllers.dart';

part 'inventory_products_state_controller.g.dart';

@riverpod
class InventoryProductsStateController
    extends _$InventoryProductsStateController {
  @override
  FutureOr<List<ProductEntity>> build(
    int enterpriseCode,
    int codigoInternoInventario,
    int codigoInternoInvCont,
  ) async {
    Timer? timer;
    final link = ref.keepAlive();
    ref.onCancel(() {
      timer = Timer(const Duration(seconds: 20), () {
        link.close();
      });
    });
    ref.onResume(() {
      timer?.cancel();
    });
    ref.onDispose(() {
      timer?.cancel();
    });

    return [];
  }

  Future<void> loadProducts(String searchValue) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final validatedUser = await ref.watch(
        validatedUserSessionProvider.future,
      );
      final selectedEnterprise = ref.read(
        selectedEnterpriseStateControllerProvider,
      );
      final settings = await ref.watch(
        appSettingsStateControllerProvider.future,
      );
      final searchType =
          settings?.searchPreference.searchType ?? SearchType.dynamic;

      return await ref
          .read(soapLoadProductsRepositoryProvider)
          .load(
            baseUrl: validatedUser!.enterprise!.baseUrl!,
            crossIdentity: validatedUser.user.CrossIdentity_Usuario!,
            enterpriseEntity: selectedEnterprise!,
            searchType: searchType,
            getProductsDefaultParams: GetProductsInventoryParams(
              searchValue: searchValue,
              inventoryProcessCode: codigoInternoInventario,
              inventoryCountingCode: codigoInternoInvCont,
            ),
          )
          .then((products) => products);
    });
  }

  void updateProduct(ProductEntity updatedProduct) {
    // 1. Get the current state.
    final currentState = state;
    // 2. Make sure we have data to update.
    if (currentState is! AsyncData<List<ProductEntity>>) {
      // If the list isn't loaded, do nothing.
      return;
    }

    // 3. Find the index of the old product.
    final productIndex = currentState.value.indexWhere(
      (p) => p.PLU == updatedProduct.PLU,
    );

    // 4. If the product exists in the list, replace it.
    if (productIndex != -1) {
      // Create a new list to ensure Riverpod detects the state change.
      final newList = List<ProductEntity>.from(currentState.value);
      newList[productIndex] = updatedProduct;

      // 5. Set the new state. The UI will update instantly.
      state = AsyncData(newList);
    }
  }
}
