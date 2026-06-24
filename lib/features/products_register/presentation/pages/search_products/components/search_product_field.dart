import 'dart:async';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/products/products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchProductField extends ConsumerStatefulWidget {
  final int enterpriseCode;
  const SearchProductField({super.key, required this.enterpriseCode});

  @override
  ConsumerState<SearchProductField> createState() => _SearchProductFieldState();
}

class _SearchProductFieldState extends ConsumerState<SearchProductField> {
  final searchController = TextEditingController();
  final searchFocusNode = FocusNode();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchProductKey = SearchProductKey(
      widget.enterpriseCode,
      BsRoutine.generic,
      Modules.productsRegister,
    );
    return DefaultSearchProducts(
      searchProducts: (exactProductCode) {
        //remove the selected index when search the product
        // ref
        // .read(
        //   selectedUIStateControllerProvider(
        //     widget.enterpriseCode,
        //   ).notifier,
        // )
        // .updateValues(annulSelectedIndex: true);

        ref
            .read(
              searchProductsStateControllerProvider(searchProductKey).notifier,
            )
            .loadProducts(
              exactProductCode: exactProductCode,
              GetProductsJsonParams(
                searchValue: searchController.text,
                enterpriseCodes: [widget.enterpriseCode],
                routine: BsRoutine.generic,
              ),
            );
      },
      searchValueController: searchController,
      searchProductKey: searchProductKey,
      isLoading: false,
    );
  }
}
