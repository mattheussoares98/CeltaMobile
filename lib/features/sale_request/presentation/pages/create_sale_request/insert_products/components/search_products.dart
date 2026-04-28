import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../core/domain/entities/entities.dart';
import '../../../../../../../core/presentation/controllers/products/products.dart';

class SearchProducts extends ConsumerWidget {
  final int enterpriseCode;
  final TextEditingController searchProductsController;
  final int saleRequestId;
  const SearchProducts({
    super.key,
    required this.enterpriseCode,
    required this.searchProductsController,
    required this.saleRequestId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchProductKey = SearchProductKey(
      enterpriseCode,
      BsRoutine.saleRequest,
      Modules.saleRequest,
      anotherKey: saleRequestId.toString(),
    );

    return DefaultSearchProducts(
      searchValueController: searchProductsController,
      searchProductKey: searchProductKey,
      searchProducts: (exactProductCode) {
        ref
            .read(
              searchProductsStateControllerProvider(searchProductKey).notifier,
            )
            .loadProducts(
              exactProductCode: exactProductCode,
              GetProductsJsonParams(
                searchValue: searchProductsController.text,
                enterpriseCodes: [enterpriseCode],
              ),
            );
      },
    );
  }
}
