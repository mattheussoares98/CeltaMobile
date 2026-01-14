import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../../core/presentation/controllers/products/products.dart';
import '../../../../../../utils/utils.dart';
import '../../../controllers/controllers.dart';
import '../products.dart';

class SearchProductsField extends ConsumerStatefulWidget {
  final ProductsPage widget;
  const SearchProductsField({super.key, required this.widget});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SearchProductsFieldState();
}

class _SearchProductsFieldState extends ConsumerState<SearchProductsField> {
  final searchValueController = TextEditingController();

  @override
  void dispose() {
    super.dispose();

    searchValueController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      searchProductsStateControllerProvider(
        SearchProductKey(
          widget.widget.enterpriseCode,
          BsRoutine.researchOfPrice,
          Modules.competingPrices,
        ),
      ),
      (p, n) {
        n.doOnSuccess(p, () {
          searchValueController.clear();
        });
      },
    );

    final searchType = ref.watch(
      selectedItemUIControllerProvider.select((s) => s.searchType),
    );

    final restrictProducts = ref.watch(
      researchsStateControllerProvider.select(
        (s) =>
            s.value
                ?.firstWhere((e) => e.Code == widget.widget.researchCode)
                .RestrictProducts ??
            false,
      ),
    );

    final searchProductKey = SearchProductKey(
      widget.widget.enterpriseCode,
      BsRoutine.researchOfPrice,
      Modules.competingPrices,
    );

    return DefaultSearchProducts(
      allowEmptySearchValue: true,
      isLoading: ref.watch(
        searchProductsStateControllerProvider(
          searchProductKey,
        ).select((s) => s.isLoading),
      ),
      searchProductKey: searchProductKey,
      searchProducts: () {
        ref
            .read(
              searchProductsStateControllerProvider(searchProductKey).notifier,
            )
            .loadProducts(
              GetProductsJsonParams(
                enterpriseCodes: [widget.widget.enterpriseCode],
                searchValue: searchValueController.text.isEmpty
                    ? '%'
                    : searchValueController.text,
                competingPricesParams: CompetingPricesParams(
                  ResearchOfPriceCode: widget.widget.researchCode,
                  ConcurrentCode: widget.widget.concurrentCode,
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
