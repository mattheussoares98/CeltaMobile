import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/entities/entities.dart';
import '../../domain/entities/entities.dart';

part 'selected_ui_state_controller.g.dart';

@Riverpod(keepAlive: true)
class SelectedUIStateController extends _$SelectedUIStateController {
  @override
  SelectedItemUIState build() {
    return SelectedItemUIState.empty();
  }

  void udpateValues({
    TransferJustificationEntity? selectedJustification,
    StockTypeEntity? selectedStockType,
    int? selectedIndex,
  }) {
    state = SelectedItemUIState(
      selectedJustification: selectedJustification,
      selectedStockType: selectedStockType,
      selectedIndex: selectedIndex == state.selectedIndex
          ? null
          : selectedIndex,
    );
  }
}
