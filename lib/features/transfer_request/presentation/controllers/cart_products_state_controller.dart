import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/entities.dart';
import '../../providers.dart';

part 'cart_products_state_controller.g.dart';

@riverpod
class CartProductsStateController extends _$CartProductsStateController {
  @override
  Future<List<TransferRequestProductItemEntity>> build(DraftKey draftKey) {
    return ref.watch(localCartRepositoryProvider).load(draftKey);
  }

  Future<void> addItem(TransferRequestProductItemEntity item) async {
    final repository = ref.read(localCartRepositoryProvider);

    final currentItemIndex = state.value?.indexWhere(
      (i) => i.product.ProductPackingCode == item.product.ProductPackingCode,
    );

    if (currentItemIndex != null && currentItemIndex != -1) {
      await repository.addItem(
        draftKey,
        item.copyWith(
          quantity: state.value![currentItemIndex].quantity + item.quantity,
        ),
      );
    } else {
      await repository.addItem(draftKey, item);
    }

    ref.invalidateSelf();

    await future;
  }

  Future<void> removeItem(TransferRequestProductItemEntity item) async {
    final repository = ref.read(localCartRepositoryProvider);
    await repository.removeItem(draftKey, item);
    ref.invalidateSelf();
    await future;
  }

  Future<void> clearLot() async {
    final repository = ref.read(localCartRepositoryProvider);
    await repository.clear(draftKey);
    ref.invalidateSelf();
    await future;
  }
}
