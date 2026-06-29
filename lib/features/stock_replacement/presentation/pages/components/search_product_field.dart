import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/products/products.dart';
import 'package:celta_inventario/features/stock_replacement/presentation/controllers/controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchProductField extends ConsumerStatefulWidget {
  final int enterpriseCode;
  const SearchProductField({super.key, required this.enterpriseCode});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SearchProductFieldState();
}

class _SearchProductFieldState extends ConsumerState<SearchProductField> {
  final searchValueController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    searchValueController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchProductKey = SearchProductKey(
      widget.enterpriseCode,
      BsRoutine.adjustStock,
      Modules.stockReplacement,
    );

    return BaseSearchProducts(
      searchValueController: searchValueController,
      searchProductKey: searchProductKey,
      searchProducts: (exactProductCode) {
        //remove the selected index when search the product
        ref
            .read(
              selectedUIStateControllerProvider(widget.enterpriseCode).notifier,
            )
            .updateValues(annulSelectedIndex: true);

        ref
            .read(
              searchProductsStateControllerProvider(searchProductKey).notifier,
            )
            .loadProducts(
              exactProductCode: exactProductCode,
              GetProductsJsonParams(
                searchValue: searchValueController.text,
                enterpriseCodes: [widget.enterpriseCode],
                routine: BsRoutine.adjustStock,
              ),
            );
      },
    );
  }
}
