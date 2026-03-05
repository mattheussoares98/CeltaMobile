import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../core/presentation/controllers/products/products.dart';
import '../../../../enterprises/presentation/controllers/controllers.dart';

class SearchProduct extends ConsumerStatefulWidget {
  const SearchProduct({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchProductState();
}

class _SearchProductState extends ConsumerState<SearchProduct> {
  final searchValueController = TextEditingController();

  @override
  void dispose() {
    super.dispose();

    searchValueController.dispose();
  }

  Future<void> searchProducts(int enterpriseCode) async {
    await ref
        .read(
          searchProductsStateControllerProvider(
            SearchProductKey(
              enterpriseCode,
              BsRoutine.adjustSalePrice,
              Modules.adjustPrice,
            ),
          ).notifier,
        )
        .loadProducts(
          GetProductsJsonParams(
            searchValue: searchValueController.text,
            enterpriseCodes: [enterpriseCode],
            routine: BsRoutine.adjustSalePrice,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final enterpriseCode = ref.watch(
      selectedEnterpriseStateControllerProvider.select((s) => s?.Code),
    );

    if (enterpriseCode == null) {
      return const SizedBox.shrink();
    }

    final searchProductKey = SearchProductKey(
      enterpriseCode,
      BsRoutine.adjustSalePrice,
      Modules.adjustPrice,
    );

    return DefaultSearchProducts(
      searchValueController: searchValueController,
      searchProductKey: searchProductKey,
      isLoading: ref.watch(
        searchProductsStateControllerProvider(
          searchProductKey,
        ).select((state) => state.isLoading),
      ),
      searchProducts: () => searchProducts(enterpriseCode),
    );
  }
}
