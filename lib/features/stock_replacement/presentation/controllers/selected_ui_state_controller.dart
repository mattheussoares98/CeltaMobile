import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/features/stock_replacement/domain/entities/entities.dart';

part 'selected_ui_state_controller.g.dart';

@Riverpod(keepAlive: true)
class SelectedUIStateController extends _$SelectedUIStateController {
  @override
  SelectedItemUIState build(int enterpriseCode) {
    ref.watch(validatedUserSessionProvider);
    return SelectedItemUIState.empty();
  }

  Future<void> updateValues({
    StockTypeEntity? selectedStockType,
    int? selectedIndex,
    bool? annulSelectedIndex,
  }) async {
    state = SelectedItemUIState(
      selectedStockType: selectedStockType ?? state.selectedStockType,
      selectedIndex:
          selectedIndex == state.selectedIndex || annulSelectedIndex == true
          ? null
          : selectedIndex ?? state.selectedIndex,
    );
  }
}
