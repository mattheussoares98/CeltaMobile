import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/transfer_between_stocks/domain/entities/entities.dart';
import 'package:celta_inventario/features/transfer_between_stocks/providers.dart';

part 'lot_state_controller.g.dart';

@riverpod
class LotStateController extends _$LotStateController {
  @override
  Future<List<ProductLotInfoEntity>> build(int enterpriseCode) {
    return ref.watch(localItemsLotRepositoryProvider).load(enterpriseCode);
  }

  Future<void> addItem({
    required ProductEntity product,
    required double quantity,
    required TransferJustificationEntity selectedJustification,
    required StockTypeEntity selectedOriginStock,
    required StockTypeEntity selectedDestinyStock,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final item = ProductLotInfoEntity(
        product: product,
        selectedJustification: selectedJustification,
        selectedOriginStock: selectedOriginStock,
        selectedDestinyStock: selectedDestinyStock,
        quantity: quantity,
      );

      final repository = ref.read(localItemsLotRepositoryProvider);
      await repository.addItem(item);

      final previousState = state.value ?? [];
      final updatedList = [...previousState];

      int productIndex = updatedList.indexWhere(
        (i) => i.product.ProductPackingCode == item.product.ProductPackingCode,
      );
      if (productIndex == -1) {
        updatedList.add(item);
      } else {
        updatedList[productIndex] = item;
      }

      return updatedList;
    });
  }

  Future<void> removeItem(int productPackingCode) async {
    state = await AsyncValue.guard(() async {
      final repository = ref.read(localItemsLotRepositoryProvider);

      await repository.removeItem(
        productPackingCode: productPackingCode,
        enterpriseCode: enterpriseCode,
      );

      final previousState = state.value ?? [];
      final newState = previousState
          .where((i) => i.product.ProductPackingCode != productPackingCode)
          .toList();

      return newState;
    });
  }

  Future<void> clearLot(int enterpriseCode) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(localItemsLotRepositoryProvider);
      await repository.clear(enterpriseCode);
      return [];
    });
  }
}
