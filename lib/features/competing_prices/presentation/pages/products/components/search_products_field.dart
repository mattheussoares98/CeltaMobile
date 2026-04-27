import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../../core/presentation/controllers/products/products.dart';
import '../../../../../../utils/utils.dart';
import '../../../controllers/controllers.dart';

class SearchProductsField extends ConsumerStatefulWidget {
  final int enterpriseCode;
  final int researchCode;
  final int concurrentCode;
  const SearchProductsField({
    super.key,
    required this.enterpriseCode,
    required this.researchCode,
    required this.concurrentCode,
  });

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
          widget.enterpriseCode,
          BsRoutine.researchOfPrice,
          Modules.competingPrices,
        ),
      ),
      (p, n) {
        n.doOnSuccess(p, () {
          searchValueController.clear();
          ref
              .read(selectedItemUIControllerProvider.notifier)
              .updateSelectedIndex(null);
        });
      },
    );

    final searchProductKey = SearchProductKey(
      widget.enterpriseCode,
      BsRoutine.researchOfPrice,
      Modules.competingPrices,
    );

    return DefaultSearchProducts(
      allowEmptySearchValue: true,
      searchProductKey: searchProductKey,
      searchProducts: (exactProductCode) {
        final searchType = ref.read(
          selectedItemUIControllerProvider.select((s) => s.searchType),
        );
        final restrictProducts = ref.read(
          researchsStateControllerProvider(widget.enterpriseCode).select(
            (s) =>
                s.value
                    ?.firstWhereOrNull((e) => e.Code == widget.researchCode)
                    ?.RestrictProducts ??
                false,
          ),
        );
        ref
            .read(
              searchProductsStateControllerProvider(searchProductKey).notifier,
            )
            .loadProducts(
              exactProductCode: exactProductCode,
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
