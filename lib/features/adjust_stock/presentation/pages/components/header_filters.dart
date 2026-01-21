import 'package:celta_inventario/features/adjust_stock/presentation/pages/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../core/presentation/controllers/products/products.dart';

class HeaderFilters extends ConsumerWidget {
  final int enterpriseCode;
  final TextEditingController searchValueController;
  const HeaderFilters({
    super.key,
    required this.enterpriseCode,
    required this.searchValueController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchProductKey = SearchProductKey(
      enterpriseCode,
      BsRoutine.adjustStock,
      Modules.adjustStock,
    );

    return Column(
      children: [
        DefaultSearchProducts(
          searchValueController: searchValueController,
          searchProductKey: searchProductKey,
          isLoading: ref.watch(
            searchProductsStateControllerProvider(
              searchProductKey,
            ).select((state) => state.isLoading),
          ),
          searchProducts: () {
            ref
                .read(
                  searchProductsStateControllerProvider(
                    searchProductKey,
                  ).notifier,
                )
                .loadProducts(
                  GetProductsJsonParams(
                    searchValue: searchValueController.text,
                    enterpriseCodes: [enterpriseCode],
                    routine: BsRoutine.adjustStock,
                  ),
                );
          },
        ),
        gapH8,
        JustificationsDropdown(enterpriseCode: enterpriseCode),
        gapH8,
        StocksDropdown(enterpriseCode: enterpriseCode),
        gapH8,
      ],
    );
  }
}
