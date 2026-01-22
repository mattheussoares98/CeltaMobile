import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/entities/entities.dart';
import '../../../../core/presentation/controllers/stock/stock.dart';
import '../../domain/entities/entities.dart';

part 'selected_ui_state_controller.g.dart';

@riverpod
class SelectedUIStateController extends _$SelectedUIStateController {
  @override
  SelectedItemUIState build(int enterpriseCode) => SelectedItemUIState.empty();

  Future<void> updateValues({
    TransferJustificationEntity? selectedJustification,
    StockTypeEntity? selectedStockType,
    int? selectedIndex,
    bool? annulSelectedIndex,
  }) async {
    StockTypeEntity? newStock;
    if (selectedJustification?.CodigoInterno_TipoEstoque != null) {
      final stocks = await ref.watch(
        stockTypeStateControllerProvider(enterpriseCode).future,
      );
      newStock = stocks.firstWhereOrNull(
        (e) =>
            e.CodigoInterno_TipoEstoque ==
            selectedJustification?.CodigoInterno_TipoEstoque,
      );
    }

    state = SelectedItemUIState(
      selectedJustification:
          selectedJustification ?? state.selectedJustification,
      selectedStockType:
          newStock ?? selectedStockType ?? state.selectedStockType,
      selectedIndex:
          selectedIndex == state.selectedIndex || annulSelectedIndex == true
          ? null
          : selectedIndex ?? state.selectedIndex,
    );
  }
}
