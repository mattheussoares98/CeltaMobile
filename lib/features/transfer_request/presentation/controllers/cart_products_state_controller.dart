import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:celta_inventario/features/transfer_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/transfer_request/providers.dart';

part 'cart_products_state_controller.g.dart';

@riverpod
class CartProductsStateController extends _$CartProductsStateController {
  @override
  Future<List<TransferRequestProductItemEntity>> build(DraftKey draftKey) {
    return ref.watch(localCartRepositoryProvider).load(draftKey);
  }

  Future<void> addItem(
    TransferRequestProductItemEntity item,
    CartAdditionStrategy additionStrategy,
  ) async {
    final repository = ref.read(localCartRepositoryProvider);

    await repository.addItem(draftKey, item, additionStrategy);

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
