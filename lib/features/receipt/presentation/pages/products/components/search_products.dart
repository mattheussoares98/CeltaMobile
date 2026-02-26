import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../../core/presentation/controllers/products/products.dart';
import '../../../controllers/controllers.dart';

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
    void searchProduct() {
      ref
          .read(
            searchProductsStateControllerProvider(searchProductKey).notifier,
          )
          .loadProducts(
            GetProductsReceiptParams(
              searchValue: searchProductController.text,
              grDocCode: receiptCode,
            ),
          );
    }

    return DefaultSearchProducts(
      module: Modules.receipt,
      focusNode: searchProductFocusNode,
      isLoading: ref.watch(
        searchProductsStateControllerProvider(
          searchProductKey,
        ).select((s) => s.isLoading),
      ),
      searchProducts: searchProduct,
      searchValueController: searchProductController,
      searchProductKey: searchProductKey,
      doOnSearchSucceeds: () {
        ref
            .read(selectedProductIndeStateControllerProvider.notifier)
            .updateIndex(null);
      },
    );
  }
}
