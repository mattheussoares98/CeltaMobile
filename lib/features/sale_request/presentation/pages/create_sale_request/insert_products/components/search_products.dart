import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../core/domain/entities/entities.dart';
import '../../../../../../../core/presentation/controllers/products/products.dart';

class SearchProducts extends ConsumerStatefulWidget {
  final int enterpriseCode;
  final int saleRequestId;
  const SearchProducts({
    super.key,
    required this.enterpriseCode,
    required this.saleRequestId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchProductsState();
}

class _SearchProductsState extends ConsumerState<SearchProducts> {
  final searchProductsController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    searchProductsController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchProductKey = SearchProductKey(
      widget.enterpriseCode,
      BsRoutine.saleRequest,
      Modules.saleRequest,
      anotherKey: widget.saleRequestId.toString(),
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
                enterpriseCodes: [widget.enterpriseCode],
              ),
            );
      },
    );
  }
}
