import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_product_packing_code_state_controller.g.dart';

@riverpod
class SelectedProductPackingCodeStateController
    extends _$SelectedProductPackingCodeStateController {
  @override
  int? build() {
    return null;
  }

  void updateProductPackingCode(int? productPackingCode) {
    if (state == productPackingCode || productPackingCode == null) {
      state = null;
    } else {
      state = productPackingCode;
    }
  }
}
