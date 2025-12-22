import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/entities/entities.dart';
import '../../../../core/presentation/controllers/stock/stock.dart';
import '../../domain/entities/entities.dart';

part 'selected_ui_state_controller.g.dart';

@Riverpod(keepAlive: true)
class SelectedUIStateController extends _$SelectedUIStateController {
  @override
  SelectedItemUIState build(int enterpriseCode) {
    return SelectedItemUIState.empty();
  }

  Future<void> updateValues({
    TransferJustificationEntity? selectedJustification,
    StockTypeEntity? selectedStockType,
    int? selectedIndex,
  }) async {
    final stocks = await ref.watch(
      stockTypeStateControllerProvider(enterpriseCode).future,
    );

    StockTypeEntity? newStock;
    if (selectedJustification?.CodigoInterno_TipoEstoque != null) {
      newStock = stocks.firstWhere(
        (e) =>
            e.CodigoInterno_TipoEstoque ==
            selectedJustification?.CodigoInterno_TipoEstoque,
      );
    }

    state = SelectedItemUIState(
      selectedJustification: selectedJustification,
      selectedStockType: newStock ?? selectedStockType,
      selectedIndex: selectedIndex == state.selectedIndex
          ? null
          : selectedIndex,
    );
  }
}
