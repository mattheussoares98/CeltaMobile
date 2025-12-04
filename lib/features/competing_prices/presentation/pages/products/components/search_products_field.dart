import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../../core/presentation/controllers/products/products.dart';
import '../../../controllers/controllers.dart';
import '../products.dart';

class SearchProductsField extends ConsumerWidget {
  final TextEditingController searchValueController;
  final ProductsPage widget;
  const SearchProductsField({
    super.key,
    required this.searchValueController,
    required this.widget,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchType = ref.watch(
      selectedItemUIControllerProvider.select((s) => s.searchType),
    );

    final restrictProducts = ref.watch(
      researchsStateControllerProvider.select(
        (s) =>
            s.value
                ?.firstWhere((e) => e.Code == widget.researchCode)
                .RestrictProducts ??
            false,
      ),
    );

    return DefaultSearchProducts(
      allowEmptySearchValue: true,
      isLoading: ref.watch(
        searchProductsStateControllerProvider(
          widget.enterpriseCode,
          BsRoutine.researchOfPrice,
          Modules.competingPrices,
        ).select((s) => s.isLoading),
      ),
      searchProducts: () {
        ref
            .read(
              searchProductsStateControllerProvider(
                widget.enterpriseCode,
                BsRoutine.researchOfPrice,
                Modules.competingPrices,
              ).notifier,
            )
            .loadProducts(
              GetProductsJsonParams(
                enterpriseCodes: [widget.enterpriseCode],
                searchValue: searchValueController.text.isEmpty
                    ? '%'
                    : searchValueController.text,
                competingPricesParams: CompetingPricesParams(
                  ResearchOfPriceCode: widget.researchCode,
                  ConcurrentCode: widget.concurrentCode,
                  OnlyAssociated: restrictProducts,
                  searchType: searchType,
                ),
              ),
            );
      },
      searchValueController: searchValueController,
    );
  }
}
