import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/products/products.dart';

class SearchProducts extends ConsumerStatefulWidget {
  final SearchProductKey searchProductKey;
  const SearchProducts({super.key, required this.searchProductKey});

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
    return DefaultSearchProducts(
      searchValueController: searchProductsController,
      searchProductKey: widget.searchProductKey,
      searchProducts: (exactProductCode) {
        ref
            .read(
              searchProductsStateControllerProvider(
                widget.searchProductKey,
              ).notifier,
            )
            .loadProducts(
              exactProductCode: exactProductCode,
              GetProductsJsonParams(
                searchValue: searchProductsController.text,
                enterpriseCodes: [widget.searchProductKey.enterpriseCode],
              ),
            );
      },
    );
  }
}
