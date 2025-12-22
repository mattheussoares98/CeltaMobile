import 'package:celta_intelligence/features/adjust_stock/presentation/pages/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../core/presentation/controllers/products/products.dart';

class HeaderFilters extends ConsumerWidget {
  final int enterpriseCode;
  final VoidCallback searchProducts;
  final TextEditingController searchValueController;
  final SearchProductKey searchProductKey;
  const HeaderFilters({
    super.key,
    required this.enterpriseCode,
    required this.searchProducts,
    required this.searchValueController,
    required this.searchProductKey,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          searchProducts: searchProducts,
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
