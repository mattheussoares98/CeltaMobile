import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../core/providers/products/products.dart';
import '../../../../../features/enterprises/presentation/controllers/controllers.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../features/settings/presentation/controllers/controllers.dart';
import '../user_session/user_session.dart';

part 'search_products_state_controller.g.dart';

@riverpod
class SearchProductsStateController extends _$SearchProductsStateController {
  @override
  Future<List<ProductEntity>> build(SearchProductKey searchProductKey) async {
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

  Future<void> loadProducts(
    GetProductsDefaultParams getProductsDefaultParams, {
    SearchType? specifiedSearchType,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final userSession = await ref.watch(validatedUserSessionProvider.future);
      final selectedEnterprise = ref.read(
        selectedEnterpriseStateControllerProvider,
      );

      final workingUrl = userSession!.enterprise!.workingUrl!;
      final crossIdentity = userSession.user.CrossIdentity_Usuario!;

      final settings = await ref.read(
        appSettingsStateControllerProvider.future,
      );
      final searchType =
          settings?.searchPreference.searchType ?? SearchType.dynamic;

      final products = await ref
          .read(soapLoadProductsRepositoryProvider)
          .load(
            workingUrl: workingUrl,
            crossIdentity: crossIdentity,
            enterpriseEntity: selectedEnterprise!,
            searchType: specifiedSearchType ?? searchType,
            getProductsDefaultParams: getProductsDefaultParams.copyWith(
              routine: searchProductKey.routine,
            ),
          );

      return List<ProductEntity>.from(products);
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
    final productIndex = currentState.value.indexWhere((p) {
      if (searchProductKey.module == Modules.inventory) {
        return p.codigoInternoProEmb == updatedProduct.codigoInternoProEmb;
      }
      return p.ProductPackingCode == updatedProduct.ProductPackingCode;
    });

    // 4. If the product exists in the list, replace it.
    if (productIndex != -1) {
      // Create a new list to ensure Riverpod detects the state change.
      final newList = List<ProductEntity>.from(currentState.value);
      newList[productIndex] = updatedProduct;

      // 5. Set the new state. The UI will update instantly.
      state = AsyncData(newList);
    }
  }

  void addProduct(ProductEntity newProduct) {
    final currentState = state.valueOrNull;
    if (currentState?.any(
          (e) => e.ProductPackingCode == newProduct.ProductPackingCode,
        ) ??
        false) {
      return;
    }
    currentState?.removeWhere(
      (e) => e.ProductPackingCode == newProduct.ProductPackingCode,
      //should remove to put the product as first in the list
    );
    state = AsyncData([newProduct, ...?currentState]);
  }
}
