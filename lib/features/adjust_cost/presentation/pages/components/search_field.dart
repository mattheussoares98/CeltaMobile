import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/products/products.dart';
import 'package:celta_inventario/features/adjust_cost/presentation/controllers/controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchField extends ConsumerStatefulWidget {
  final int enterpriseCode;
  const SearchField({super.key, required this.enterpriseCode});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchFieldState();
}

class _SearchFieldState extends ConsumerState<SearchField> {
  final searchValueController = TextEditingController();

  @override
  void dispose() {
    searchValueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchProductKey = SearchProductKey(
      widget.enterpriseCode,
      BsRoutine.generic,
      Modules.adjustCost,
    );

    return BaseSearchProducts(
      searchProducts: (exactProductCode) {
        ref
            .read(
              selectedProductIndexStateControllerProvider(
                widget.enterpriseCode,
              ).notifier,
            )
            .updateIndex(null);
        ref
            .read(
              searchProductsStateControllerProvider(searchProductKey).notifier,
            )
            .loadProducts(
              GetProductsJsonParams(
                searchValue: searchValueController.text,
                enterpriseCodes: [widget.enterpriseCode],
              ),
              exactProductCode: exactProductCode,
            );
      },
      isLoading: ref.watch(
        searchProductsStateControllerProvider(
          searchProductKey,
        ).select((s) => s.isLoading),
      ),
      searchValueController: searchValueController,
      searchProductKey: searchProductKey,
    );
  }
}
