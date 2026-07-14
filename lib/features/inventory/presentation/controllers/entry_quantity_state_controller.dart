import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/app_usage/app_usage.dart';
import 'package:celta_inventario/core/presentation/controllers/products/products.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/exceptions/exceptions.dart';
import 'package:celta_inventario/features/inventory/domain/entities/entities.dart';
import 'package:celta_inventario/features/inventory/providers.dart';

part 'entry_quantity_state_controller.g.dart';

@Riverpod(keepAlive: true)
class EntryQuantityStateController extends _$EntryQuantityStateController {
  @override
  FutureOr<LastChangedProductEntity?> build(int codigoInternoInvCont) async {
    return null;
  }

  Future<bool> entry({
    required int codigoInternoProEmb,
    required double quantity,
    required bool isSubtract,
    required int enterpriseCode,
    required int codigoInternoInventario,
  }) async {
    bool updated = false;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final validatedUser = await ref.watch(
        validatedUserSessionProvider.future,
      );

      final searchProductKey = SearchProductKey(
        enterpriseCode,
        BsRoutine.generic,
        Modules.inventory,
        anotherKey: '$codigoInternoInvCont-$codigoInternoInventario',
      );

      List<ProductEntity> products = [];
      try {
        products = await ref.read(
          searchProductsStateControllerProvider(
            searchProductKey,
          ).future,
        );
      } catch (e) {
        return state.value;
      }

      final product = products.firstWhere(
        (e) => e.codigoInternoProEmb == codigoInternoProEmb,
      );

      final newQuantity = isSubtract
          ? (product.quantidadeInvContProEmb ?? 0) - quantity
          : (product.quantidadeInvContProEmb ?? 0) + quantity;

      if (newQuantity < 0) {
        throw AppException('A quantidade não pode ficar negativa'.hardcoded);
      }

      ref
          .read(appUsageStateControllerProvider.notifier)
          .addUsage(UsageType.countInventoryProduct);

      await ref
          .read(soapInventoryEntryQuantityRepositoryProvider)
          .entry(
            workingUrl: validatedUser!.enterprise!.workingUrl!,
            crossIdentity: validatedUser.user.CrossIdentity_Usuario!,
            codigoInternoInvCont: codigoInternoInvCont,
            productPackingCode: codigoInternoProEmb,
            quantity: quantity,
            isSubtract: isSubtract,
          );

      ref
          .read(
            searchProductsStateControllerProvider(searchProductKey).notifier,
          )
          .updateProduct(
            product.copyWith(quantidadeInvContProEmb: newQuantity),
          );

      updated = true;
      return LastChangedProductEntity(
        codigoInternoProEmb: codigoInternoProEmb,
        quantity: quantity,
        isSubtract: isSubtract,
      );
    });
    return updated;
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

      final searchProductKey = SearchProductKey(
        enterpriseCode,
        BsRoutine.generic,
        Modules.inventory,
        anotherKey: '$codigoInternoInvCont-$codigoInternoInventario',
      );

      await ref
          .read(soapInventoryAnnulRepositoryProvider)
          .annul(
            workingUrl: validatedUser!.enterprise!.workingUrl!,
            crossIdentity: validatedUser.user.CrossIdentity_Usuario!,
            codigoInternoInvCont: codigoInternoInvCont,
            codigoInternoProEmb: codigoInternoProEmb,
          );

      final product = await ref
          .read(searchProductsStateControllerProvider(searchProductKey).future)
          .then((products) {
            return products.firstWhere(
              (e) => e.codigoInternoProEmb == codigoInternoProEmb,
            );
          });

      ref
          .read(
            searchProductsStateControllerProvider(searchProductKey).notifier,
          )
          .updateProduct(
            ProductEntity.empty().copyWith(
              Name: product.Name,
              codigoInternoProEmb: product.codigoInternoProEmb,
              PLU: product.PLU,
              codigoProEmb: product.codigoProEmb,
            ),
          );

      return null;
    });
  }
}
