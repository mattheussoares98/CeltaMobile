import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/entities/entities.dart';
import '../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../../enterprises/presentation/controllers/controllers.dart';
import '../../../settings/presentation/controllers/controllers.dart';
import '../../domain/entities/entities.dart';
import '../../providers.dart';

part 'inventory_products_state_controller.g.dart';

@riverpod
class InventoryProductsStateController
    extends _$InventoryProductsStateController {
  @override
  FutureOr<List<InventoryProductEntity>> build(
    int enterpriseCode,
    int inventoryProcessCode,
    int inventoryCountingCode,
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
    //TODO create tests
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final validatedUser = await ref.read(validatedUserSessionProvider.future);
      final selectedEnterprise = ref.read(
        selectedEnterpriseStateControllerProvider,
      );
      final settings = await ref.read(
        appSettingsStateControllerProvider.future,
      );
      final searchType =
          settings?.searchPreference.searchType ?? SearchType.dynamic;

      return await ref
          .read(soapInventoryProductsRepositoryProvider)
          .load(
            baseUrl: validatedUser!.enterprise!.baseUrl!,
            crossIdentity: validatedUser.user.CrossIdentity_Usuario!,
            enterpriseCode: enterpriseCode,
            searchValue: searchValue,
            inventoryProcessCode: inventoryProcessCode,
            searchType: searchType,
            inventoryCountingCode: inventoryCountingCode,
            selectedEnterprise: selectedEnterprise!,
          );
    });
  }
}
