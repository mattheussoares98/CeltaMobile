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
  final TransferJustificationEntity? selectedJustification;
  final StockTypeEntity? selectedStockType;
  final void Function(TransferJustificationEntity?) onChangeJustification;
  final void Function(StockTypeEntity?) onChangeStockType;
  const HeaderFilters({
    super.key,
    required this.enterpriseCode,
    required this.searchProducts,
    required this.searchValueController,
    required this.selectedJustification,
    required this.selectedStockType,
    required this.onChangeJustification,
    required this.onChangeStockType,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        DefaultSearchProducts(
          searchValueController: searchValueController,
          isLoading: ref.watch(
            searchProductsStateControllerProvider(
              enterpriseCode,
              BsRoutine.adjustStock,
              Modules.adjustStock,
            ).select((state) => state.isLoading),
          ),
          searchProducts: searchProducts,
        ),
        gapH8,
        JustificationsDropdown(
          selectedJustification: selectedJustification,
          enterpriseCode: enterpriseCode,
          onChanged: onChangeJustification,
        ),
        gapH8,
        StocksDropdown(
          enterpriseCode: enterpriseCode,
          selectedJustification: selectedJustification,
          selectedStockType: selectedStockType,
          onChanged: onChangeStockType,
        ),
        gapH8,
      ],
    );
  }
}
