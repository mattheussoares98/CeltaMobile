import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/entities.dart';

part 'selected_item_ui_controller.g.dart';

@riverpod
class SelectedItemUIController extends _$SelectedItemUIController {
  @override
  SelectedItemUIState build({required bool isCartPage}) {
    return SelectedItemUIState.empty();
  }

  void selectProduct(
    int? productPackingCode,
    SaleRequestCartProductEntity? cartProduct,
  ) {
    if (state.productPackingCode == productPackingCode) {
      state = SelectedItemUIState.empty();
    } else {
      state = SelectedItemUIState(
        productPackingCode: productPackingCode,
        discountType: null,
      );
    }
  }

  void updateDiscountType(PercentageOrValue? discountType) {
    state = state.copyWith(discountType: discountType);
  }
}
