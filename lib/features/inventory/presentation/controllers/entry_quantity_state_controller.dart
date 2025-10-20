import 'package:celta_intelligence/features/inventory/presentation/controllers/inventory_products_state_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../domain/entities/entities.dart';
import '../../providers.dart';

part 'entry_quantity_state_controller.g.dart';

@Riverpod(keepAlive: true)
class EntryQuantityStateController extends _$EntryQuantityStateController {
  @override
  FutureOr<LastChangedProductEntity?> build(int codigoInternoInvCont) async {
    return null;
  }

  Future<void> entry({
    required int codigoInternoProEmb,
    required double quantity,
    required bool isSubtract,
    required int enterpriseCode,
    required int codigoInternoInventario,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final validatedUser = await ref.watch(
        validatedUserSessionProvider.future,
      );

      await ref
          .read(soapInventoryEntryQuantityRepositoryProvider)
          .entry(
            baseUrl: validatedUser!.enterprise!.baseUrl!,
            crossIdentity: validatedUser.user.CrossIdentity_Usuario!,
            codigoInternoInvCont: codigoInternoInvCont,
            productPackingCode: codigoInternoProEmb,
            quantity: quantity,
            isSubtract: isSubtract,
          );

      final product = await ref
          .read(
            inventoryProductsStateControllerProvider(
              enterpriseCode,
              codigoInternoInventario,
              codigoInternoInvCont,
            ).future,
          )
          .then((value) {
            return value.firstWhere(
              (e) => e.codigoInternoProEmb == codigoInternoProEmb,
            );
          });

      ref
          .read(
            inventoryProductsStateControllerProvider(
              enterpriseCode,
              codigoInternoInventario,
              codigoInternoInvCont,
            ).notifier,
          )
          .updateProduct(
            product.copyWith(
              quantidadeInvContProEmb: isSubtract
                  ? (product.quantidadeInvContProEmb ?? 0) - quantity
                  : (product.quantidadeInvContProEmb ?? 0) + quantity,
            ),
          );
      //TODO test if is changing correctly the quantity locally
      return LastChangedProductEntity(
        codigoInternoProEmb: codigoInternoProEmb,
        quantity: quantity,
        isSubtract: isSubtract,
      );
    });
  }
}
