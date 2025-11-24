import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../core/data/datasource/products/products.dart';
import '../../../../../../../core/domain/entities/entities.dart';
import '../../../../../../../core/presentation/controllers/products/products.dart';
import '../../../../controllers/controllers.dart';

class SearchProductsField extends ConsumerWidget {
  final int enterpriseCode;
  final TextEditingController searchValueController;
  final int researchCode;
  final int concurrentCode;
  final bool restrictProducts;
  const SearchProductsField({
    super.key,
    required this.enterpriseCode,
    required this.searchValueController,
    required this.researchCode,
    required this.concurrentCode,
    required this.restrictProducts,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchType = ref.watch(
      selectedItemUIControllerProvider.select((s) => s.searchType),
    );

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
              competingPricesFilters: CompetingPricesFilters(
                ResearchOfPriceCode: researchCode,
                ConcurrentCode: concurrentCode,
                OnlyAssociated: restrictProducts,
                searchType: searchType,
              ),
            );
      },
      searchValueController: searchValueController,
    );
  }
}
