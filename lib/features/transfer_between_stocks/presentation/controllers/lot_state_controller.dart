import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/domain/entities/entities.dart';
import '../../providers.dart';

part 'lot_state_controller.g.dart';

@riverpod
class LotStateController extends _$LotStateController {
  @override
  Future<List<AdjustStockItemEntity>> build() {
    return ref.watch(localItemsLotRepositoryProvider).load();
  }

  Future<void> addItem(AdjustStockItemEntity item) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(localItemsLotRepositoryProvider);
      await repository.addItem(item);

      final previousState = state.valueOrNull ?? [];
      final updatedList = previousState
          .where((i) => i.ProductCode != item.ProductCode)
          .toList();
      updatedList.add(item);

      return updatedList;
    });
  }

  Future<void> removeItem(AdjustStockItemEntity item) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(localItemsLotRepositoryProvider);
      await repository.removeItem(item);

      final previousState = state.valueOrNull ?? [];
      final newState = previousState
          .where((i) => i.ProductCode != item.ProductCode)
          .toList();

      return newState;
    });
  }

  Future<void> clearLot() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(localItemsLotRepositoryProvider);
      await repository.clear();
      return [];
    });
  }
}
