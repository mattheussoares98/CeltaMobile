import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../core/presentation/controllers/products/products.dart';
import '../../controllers/controllers.dart';

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

    return DefaultSearchProducts(
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
