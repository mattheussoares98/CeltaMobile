import 'dart:async';

import 'package:celta_intelligence/features/settings/presentation/controllers/app_settings_state_controller.dart';
import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../core/providers/products/products.dart';
import '../../../../../exceptions/exceptions.dart';
import '../../../../../features/enterprises/presentation/controllers/controllers.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../features/enterprise_manager/domain/entities/entities.dart';
import '../../../data/datasource/products/products.dart';
import '../user_session/user_session.dart';

part 'search_products_state_controller.g.dart';

@riverpod
class SearchProductsStateController extends _$SearchProductsStateController {
  @override
  Future<List<ProductEntity>> build(
    int enterpriseCode,
    BsRoutine routine,
    Modules module,
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

  Future<void> loadProducts({
    required String searchValue,
    required int enterpriseCode,
    int? lastBuyEntranceQuantity = 5,
    BuyRequestFilters? buyRequestFilters,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final userSession = await ref.watch(validatedUserSessionProvider.future);
      final selectedEnterprise = ref.read(
        selectedEnterpriseStateControllerProvider,
      );

      late EnterpriseEntity enterpriseEntity;

      if (selectedEnterprise == null) {
        final enterprises = await ref.read(
          enterprisesStateControllerProvider(enterpriseCode).future,
        );
        final enterpriseIndex = enterprises.indexWhere(
          (e) => e.Code == enterpriseCode,
        );

        if (enterpriseIndex == -1) {
          throw AppException('Empresa não encontrada'.hardcoded);
        } else {
          enterpriseEntity = enterprises[enterpriseIndex];
        }
      }

      final baseUrl = userSession!.enterprise!.baseUrl!;
      final crossIdentity = userSession.user.CrossIdentity_Usuario!;

      final settings = await ref.read(
        appSettingsStateControllerProvider.future,
      );
      final searchType =
          settings?.searchPreference.searchType ?? SearchType.dynamic;

      final products = await ref
          .read(soapProductsRepositoryProvider)
          .getProductsJson(
            baseUrl: baseUrl,
            searchValue: searchValue,
            crossIdentity: crossIdentity,
            routine: routine,
            searchType: searchType,
            enterpriseCodes: [enterpriseCode],
            enterpriseEntity: selectedEnterprise ?? enterpriseEntity,
            lastBuyEntranceQuantity: lastBuyEntranceQuantity,
            buyRequestFilters: buyRequestFilters,
          );

      return products;
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
      (p) => p.ProductPackingCode == updatedProduct.ProductPackingCode,
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
