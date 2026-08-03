import 'dart:async';

import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/app_usage/app_usage.dart';
import 'package:celta_inventario/core/presentation/controllers/products/products.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/features/adjust_cost/domain/entity/entity.dart';
import 'package:celta_inventario/features/adjust_cost/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/adjust_cost/providers.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'confirm_adjust_cost_controller.g.dart';

@riverpod
class ConfirmAdjustCostController extends _$ConfirmAdjustCostController {
  @override
  FutureOr<void> build(int enterpriseCode) {
    ref.cache(5);
  }

  Future<void> confirm(AdjustCostParametersEntity parameters) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final validatedUser = await ref.read(validatedUserSessionProvider.future);

      await ref
          .read(ecAdjustCostRepositoryProvider)
          .adjust(
            workingUrl: validatedUser!.enterprise!.workingUrl!,
            user: validatedUser.user.name!,
            accessKey: validatedUser.user.AccessKey!,
            parameters: parameters,
          );

      ref
          .read(appUsageStateControllerProvider.notifier)
          .addUsage(UsageType.adjustCost);

      final productIndex = ref.read(
        selectedProductIndexStateControllerProvider(enterpriseCode),
      );
      ref
          .read(
            selectedProductIndexStateControllerProvider(
              enterpriseCode,
            ).notifier,
          )
          .updateIndex(null);

      if (productIndex == null) return;

      final searchProductKey = SearchProductKey(
        enterpriseCode,
        BsRoutine.generic,
        Modules.adjustCost,
      );

      final products = await ref.read(
        searchProductsStateControllerProvider(searchProductKey).future,
      );
      final oldProduct = products.elementAtOrNull(productIndex);
      if (oldProduct == null) return;

      ref
          .read(
            searchProductsStateControllerProvider(searchProductKey).notifier,
          )
          .updateProduct(
            oldProduct.copyWith(ReplacementCost: parameters.ReplacementCost),
          );
    });
  }
}
