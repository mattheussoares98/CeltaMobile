import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../core/domain/entities/entities.dart';
import '../../../../../../../core/presentation/controllers/products/products.dart';

class SearchProducts extends ConsumerWidget {
  final int enterpriseCode;
  final TextEditingController searchProductsController;
  const SearchProducts({
    super.key,
    required this.enterpriseCode,
    required this.searchProductsController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchProductKey = SearchProductKey(
      enterpriseCode,
      BsRoutine.saleRequest,
      Modules.saleRequest,
    );
    ref.listen(searchProductsStateControllerProvider(searchProductKey), (p, n) {
      n.doOnSuccess(p, () {
        searchProductsController.clear();
      });
    });

    return DefaultSearchProducts(
      isLoading: ref.watch(
        searchProductsStateControllerProvider(
          searchProductKey,
        ).select((state) => state.isLoading),
      ),
      searchValueController: searchProductsController,
      searchProducts: () {
        ref
            .read(
              searchProductsStateControllerProvider(searchProductKey).notifier,
            )
            .loadProducts(
              GetProductsJsonParams(
                searchValue: searchProductsController.text,
                enterpriseCodes: [enterpriseCode],
              ),
            );
      },
    );
  }
}
