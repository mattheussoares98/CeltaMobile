import 'package:celta_intelligence/features/inventory/presentation/controllers/inventory_products_state_controller.dart';
import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/entities/entities.dart';
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

      final products = await ref.read(
        inventoryProductsStateControllerProvider(
          enterpriseCode,
          codigoInternoInventario,
          codigoInternoInvCont,
        ).future,
      );

      final product = products.firstWhere(
        (e) => e.codigoInternoProEmb == codigoInternoProEmb,
      );

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

  Future<void> annul(
    int codigoInternoProEmb,
    int enterpriseCode,
    int codigoInternoInventario,
  ) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final validatedUser = await ref.watch(
        validatedUserSessionProvider.future,
      );

      await ref
          .read(soapInventoryAnnulRepositoryProvider)
          .annul(
            baseUrl: validatedUser!.enterprise!.baseUrl!,
            crossIdentity: validatedUser.user.CrossIdentity_Usuario!,
            codigoInternoInvCont: codigoInternoInvCont,
            codigoInternoProEmb: codigoInternoProEmb,
          );

      final product = await ref
          .read(
            inventoryProductsStateControllerProvider(
              enterpriseCode,
              codigoInternoInventario,
              codigoInternoInvCont,
            ).future,
          )
          .then((products) {
            return products.firstWhere(
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
            ProductEntity.empty().copyWith(
              Name: product.Name,
              codigoInternoProEmb: product.codigoInternoProEmb,
              PLU: product.PLU,
              codigoProEmb: product.codigoProEmb,
              quantidadeInvContProEmb: null,
            ),
          );

      return null;
    });
  }
}
