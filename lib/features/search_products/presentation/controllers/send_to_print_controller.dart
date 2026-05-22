import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/app_usage/app_usage.dart';
import 'package:celta_inventario/core/presentation/controllers/products/products.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/features/enterprises/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/search_products/providers.dart';

part 'send_to_print_controller.g.dart';

@riverpod
class SendToPrintController extends _$SendToPrintController {
  @override
  Future<void> build(int productPackingCode) async {}

  Future<void> send({
    required bool newValue,
    required int enterpriseCode,
    required BsRoutine routine,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final validatedUser = await ref.watch(
        validatedUserSessionProvider.future,
      );
      final selectedEnterprise = ref.read(
        selectedEnterpriseStateControllerProvider,
      );

      ref
          .read(appUsageStateControllerProvider.notifier)
          .addUsage(UsageType.sendToPrint);

      await ref
          .read(soapSendToPrintRepositoryProvider)
          .send(
            workingUrl: validatedUser!.enterprise!.workingUrl!,
            crossIdentity: validatedUser.user.CrossIdentity_Usuario!,
            enterpriseCode: selectedEnterprise!.Code!,
            productPackingCode: productPackingCode,
            newValue: newValue,
          );

      final searchProductKey = SearchProductKey(
        enterpriseCode,
        routine,
        Modules.searchProducts,
      );

      final products = await ref.read(
        searchProductsStateControllerProvider(searchProductKey).future,
      );

      ref
          .read(
            searchProductsStateControllerProvider(searchProductKey).notifier,
          )
          .updateProduct(
            products
                .firstWhere((e) => e.ProductPackingCode == productPackingCode)
                .copyWith(PendantPrintLabel: newValue),
          );
    });
  }
}
