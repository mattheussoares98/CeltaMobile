import 'package:celta_inventario/features/process_authorization/presentation/models/models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'gr_validate_doc_xml_ui_controller.g.dart';

@riverpod
class GRValidateDocXmlUiController extends _$GRValidateDocXmlUiController {
  @override
  GRValidateDocXmlUiModel build(int processCode) {
    return GRValidateDocXmlUiModel.empty();
  }

  void toggleProductWithJudgment(int productCode) {
    final selectedProducts = Set<int>.from(
      state.selectedProductsWithJudgmentIds,
    );
    if (!selectedProducts.add(productCode)) {
      selectedProducts.remove(productCode);
    }

    state = state.copyWith(selectedProductsWithJudgmentIds: selectedProducts);
  }

  void toggleProductWithoutJudgment(int productCode) {
    final selectedProducts = Set<int>.from(
      state.selectedProductsWithoutJudgmentIds,
    );
    if (!selectedProducts.add(productCode)) {
      selectedProducts.remove(productCode);
    }

    state = state.copyWith(
      selectedProductsWithoutJudgmentIds: selectedProducts,
    );
  }

  void clearSelectedProducts({required bool areJudgedItems}) {
    state = areJudgedItems
        ? state.copyWith(selectedProductsWithJudgmentIds: const {})
        : state.copyWith(selectedProductsWithoutJudgmentIds: const {});
  }

  void updatePageIndex(int index) {
    state = state.copyWith(selectedPageIndex: index);
  }
}
