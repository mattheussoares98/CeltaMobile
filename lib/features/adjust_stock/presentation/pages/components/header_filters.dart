import 'package:celta_intelligence/features/adjust_stock/presentation/pages/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../core/presentation/controllers/products/products.dart';
import '../../../../../core/presentation/controllers/stock/stock.dart';
import '../../../../../core/presentation/controllers/transfer_justification/transfer_justification.dart';

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
    final stocksAsync = ref.watch(
      stockTypeStateControllerProvider(enterpriseCode),
    );

    final justificationsAsync = ref.watch(
      transferJustificationStateControllerProvider(
        enterpriseCode,
        TransferJustificationType.adjustStock,
      ),
    );
    return Column(
      children: [
        DefaultSearchProducts(
          searchValueController: searchValueController,
          isLoading: ref
              .watch(
                searchProductsStateControllerProvider(
                  enterpriseCode,
                  BsRoutine.adjustStock,
                  Modules.adjustStock,
                ),
              )
              .isLoading,
          searchProducts: searchProducts,
        ),
        gapH8,
        JustificationsDropdown(
          selectedJustification: selectedJustification,
          asyncValue: justificationsAsync,
          enterpriseCode: enterpriseCode,
          onChanged: onChangeJustification,
        ),
        gapH8,
        StocksDropdown(
          asyncValue: stocksAsync,
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
