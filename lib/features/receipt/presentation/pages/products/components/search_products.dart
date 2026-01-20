import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../../core/presentation/controllers/products/products.dart';
import '../../../controllers/controllers.dart';

class SearchProducts extends ConsumerStatefulWidget {
  final SearchProductKey searchProductKey;
  final int receiptCode;
  const SearchProducts({
    super.key,
    required this.searchProductKey,
    required this.receiptCode,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchProductsState();
}

class _SearchProductsState extends ConsumerState<SearchProducts> {
  final searchValueController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    searchValueController.dispose();
  }

  void searchProduct({SearchType? searchType}) async {
    ref
        .read(
          searchProductsStateControllerProvider(
            widget.searchProductKey,
          ).notifier,
        )
        .loadProducts(
          GetProductsReceiptParams(
            searchValue: searchValueController.text,
            grDocCode: widget.receiptCode,
          ),
          specifiedSearchType: searchType,
        );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultSearchProducts(
      module: Modules.receipt,
      isLoading: ref.watch(
        searchProductsStateControllerProvider(
          widget.searchProductKey,
        ).select((s) => s.isLoading),
      ),
      searchProducts: searchProduct,
      searchValueController: searchValueController,
      searchProductKey: widget.searchProductKey,
      doOnSearchSucceeds: () {
        ref
            .read(selectedProductIndeStateControllerProvider.notifier)
            .updateIndex(null);
      },
    );
  }
}
