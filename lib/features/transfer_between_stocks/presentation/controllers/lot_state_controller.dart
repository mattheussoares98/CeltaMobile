import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/entities.dart';
import '../../providers.dart';

part 'lot_state_controller.g.dart';

@riverpod
class LotStateController extends _$LotStateController {
  @override
  Future<List<ProductLotInfoEntity>> build(int enterpriseCode) {
    return ref.watch(localItemsLotRepositoryProvider).load(enterpriseCode);
  }

  Future<void> addItem(ProductLotInfoEntity item) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(localItemsLotRepositoryProvider);
      await repository.addItem(item);

      final previousState = state.valueOrNull ?? [];
      final updatedList = previousState
          .where(
            (i) =>
                i.product.ProductPackingCode != item.product.ProductPackingCode,
          )
          .toList();
      updatedList.add(item);

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
