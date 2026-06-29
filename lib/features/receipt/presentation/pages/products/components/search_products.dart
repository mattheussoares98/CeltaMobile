import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/products/products.dart';
import 'package:celta_inventario/features/receipt/presentation/controllers/controllers.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchProducts extends ConsumerWidget {
  final SearchProductKey searchProductKey;
  final TextEditingController searchProductController;
  final FocusNode searchProductFocusNode;
  final int receiptCode;
  const SearchProducts({
    super.key,
    required this.searchProductKey,
    required this.receiptCode,
    required this.searchProductFocusNode,
    required this.searchProductController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void searchProduct(int? exactProductCode) {
      ref
          .read(
            searchProductsStateControllerProvider(searchProductKey).notifier,
          )
          .loadProducts(
            exactProductCode: exactProductCode,
            GetProductsReceiptParams(
              searchValue: searchProductController.text,
              grDocCode: receiptCode,
            ),
          );
    }

    ref.listen(searchProductsStateControllerProvider(searchProductKey), (p, n) {
      n.doOnSuccess(p, () {
        if (n.value?.isEmpty ?? true) return;

        final selectFirstItem = n.value?.length == 1;
        ref
            .read(
              selectedProductIndeStateControllerProvider(receiptCode).notifier,
            )
            .updateIndex(
              selectFirstItem ? 0 : null,
              annulWhenIsSame: !selectFirstItem,
            );
      });
    });

    return BaseSearchProducts(
      focusNode: searchProductFocusNode,
      searchProducts: searchProduct,
      searchValueController: searchProductController,
      searchProductKey: searchProductKey,
    );
  }
}
