import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../core/presentation/controllers/products/products.dart';

class SearchProduct extends ConsumerStatefulWidget {
  final SearchProductKey searchProductKey;
  final int enterpriseCode;
  const SearchProduct({
    super.key,
    required this.searchProductKey,
    required this.enterpriseCode,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchProductState();
}

class _SearchProductState extends ConsumerState<SearchProduct> {
  final searchValueController = TextEditingController();

  @override
  void dispose() {
    super.dispose();

    searchValueController.dispose();
  }

  Future<void> searchProducts() async {
    await ref
        .read(
          searchProductsStateControllerProvider(
            SearchProductKey(
              widget.enterpriseCode,
              BsRoutine.adjustSalePrice,
              Modules.adjustPrice,
            ),
          ).notifier,
        )
        .loadProducts(
          GetProductsJsonParams(
            searchValue: searchValueController.text,
            enterpriseCodes: [widget.enterpriseCode],
            routine: BsRoutine.adjustSalePrice,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultSearchProducts(
      searchValueController: searchValueController,
      searchProductKey: widget.searchProductKey,
      isLoading: ref.watch(
        searchProductsStateControllerProvider(
          widget.searchProductKey,
        ).select((state) => state.isLoading),
      ),
      searchProducts: searchProducts,
    );
  }
}
