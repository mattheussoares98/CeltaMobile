import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../../core/presentation/controllers/products/products.dart';
import '../../../controllers/controllers.dart';

class SearchProducts extends ConsumerWidget {
  final SearchProductKey searchProductKey;
  final TextEditingController searchValueController;
  final int receiptCode;
  const SearchProducts({
    super.key,
    required this.searchProductKey,
    required this.receiptCode,
    required this.searchValueController,
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
              searchValue: searchValueController.text,
              grDocCode: receiptCode,
            ),
          );
    }

    return DefaultSearchProducts(
      module: Modules.receipt,
      isLoading: ref.watch(
        searchProductsStateControllerProvider(
          searchProductKey,
        ).select((s) => s.isLoading),
      ),
      searchProducts: searchProduct,
      searchValueController: searchValueController,
      searchProductKey: searchProductKey,
      doOnSearchSucceeds: () {
        ref
            .read(selectedProductIndeStateControllerProvider.notifier)
            .updateIndex(null);
      },
    );
  }
}
