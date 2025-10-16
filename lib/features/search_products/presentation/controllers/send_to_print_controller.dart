import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/entities/entities.dart';
import '../../../../core/presentation/controllers/products/products.dart';
import '../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../../../features/enterprises/presentation/controllers/controllers.dart';
import '../../../enterprise_manager/domain/entities/entities.dart';
import '../../providers.dart';

part 'send_to_print_controller.g.dart';

@riverpod
class SendToPrintController extends _$SendToPrintController {
  @override
  Future<void> build() async {}

  Future<void> send({
    required int productPackingCode,
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

      await ref
          .read(soapSendToPrintRepositoryProvider)
          .send(
            baseUrl: validatedUser!.enterprise!.baseUrl!,
            crossIdentity: validatedUser.user.CrossIdentity_Usuario!,
            enterpriseCode: selectedEnterprise!.Code!,
            productPackingCode: productPackingCode,
            newValue: newValue,
          );

      final products = await ref.read(
        searchProductsStateControllerProvider(
          enterpriseCode,
          routine,
          Modules.searchProducts,
        ).future,
      );

      ref
          .read(
            searchProductsStateControllerProvider(
              enterpriseCode,
              routine,
              Modules.searchProducts,
            ).notifier,
          )
          .updateProduct(
            products
                .firstWhere((e) => e.ProductPackingCode == productPackingCode)
                .copyWith(PendantPrintLabel: newValue),
          );
    });
  }
}
