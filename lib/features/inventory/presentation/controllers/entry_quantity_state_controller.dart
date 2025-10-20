import 'package:celta_intelligence/features/inventory/presentation/controllers/inventory_products_state_controller.dart';
import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../../../exceptions/exceptions.dart';
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

      final product = ref
          .read(
            inventoryProductsStateControllerProvider(
              enterpriseCode,
              codigoInternoInventario,
              codigoInternoInvCont,
            ),
          )
          .value!
          .firstWhere((e) => e.codigoInternoProEmb == codigoInternoProEmb);

      final newQuantity = isSubtract
          ? (product.quantidadeInvContProEmb ?? 0) - quantity
          : (product.quantidadeInvContProEmb ?? 0) + quantity;

      if (newQuantity < 0) {
        throw AppException('A quantidade não pode ficar negativa'.hardcoded);
      }

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

      ref
          .read(
            inventoryProductsStateControllerProvider(
              enterpriseCode,
              codigoInternoInventario,
              codigoInternoInvCont,
            ).notifier,
          )
          .updateProduct(
            product.copyWith(quantidadeInvContProEmb: newQuantity),
          );

      return LastChangedProductEntity(
        codigoInternoProEmb: codigoInternoProEmb,
        quantity: quantity,
        isSubtract: isSubtract,
      );
    });
  }
}
