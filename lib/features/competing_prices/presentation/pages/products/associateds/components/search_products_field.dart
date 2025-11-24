import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../core/data/datasource/products/products.dart';
import '../../../../../../../core/domain/entities/entities.dart';
import '../../../../../../../core/presentation/controllers/products/products.dart';

class SearchProductsField extends ConsumerWidget {
  final int enterpriseCode;
  final CompetingPricesFilters competingPricesFilters;
  final TextEditingController searchValueController;
  const SearchProductsField({
    super.key,
    required this.enterpriseCode,
    required this.competingPricesFilters,
    required this.searchValueController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultSearchProducts(
      isLoading: ref.watch(
        searchProductsStateControllerProvider(
          enterpriseCode,
          BsRoutine.researchOfPrice,
          Modules.competingPrices,
        ).select((s) => s.isLoading),
      ),
      searchProducts: () {
        ref
            .read(
              searchProductsStateControllerProvider(
                enterpriseCode,
                BsRoutine.researchOfPrice,
                Modules.competingPrices,
              ).notifier,
            )
            .loadProducts(
              searchValue: searchValueController.text,
              enterpriseCodes: [enterpriseCode],
              competingPricesFilters: competingPricesFilters,
            );
      },
      searchValueController: searchValueController,
    );
  }
}
