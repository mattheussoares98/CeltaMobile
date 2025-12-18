import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/domain/entities/entities.dart';
import '../../domain/entities/entities.dart';
import '../../providers.dart';
import 'controllers.dart';

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
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final selectedUI = ref.read(
        selectedUIStateControllerProvider(enterpriseCode),
      );
      final item = ProductLotInfoEntity(
        product: product,
        selectedJustification: selectedUI.selectedJustification!,
        selectedOriginStock: selectedUI.selectedOriginStock!,
        selectedDestinyStock: selectedUI.selectedDestinyStock!,
        quantity: quantity,
      );

      final repository = ref.read(localItemsLotRepositoryProvider);
      await repository.addItem(item);

      final previousState = state.valueOrNull ?? [];
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

  Future<void> removeItem(ProductLotInfoEntity item) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(localItemsLotRepositoryProvider);
      await repository.removeItem(item);

      final previousState = state.valueOrNull ?? [];
      final newState = previousState
          .where(
            (i) =>
                i.product.ProductPackingCode != item.product.ProductPackingCode,
          )
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
