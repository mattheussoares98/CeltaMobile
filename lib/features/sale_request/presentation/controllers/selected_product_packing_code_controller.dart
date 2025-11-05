import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_product_packing_code_controller.g.dart';

@riverpod
class SelectedProductPackingCodeController
    extends _$SelectedProductPackingCodeController {
  @override
  FutureOr<int?> build(bool isCartPage) {
    return null;
  }

  void updateSelectedCode(int? productPackingCode) {
    if (state.value != null && state.value == productPackingCode) {
      state = const AsyncValue.data(null);
    } else {
      state = AsyncValue.data(productPackingCode);
    }
  }
}
