import 'package:celta_inventario/features/adjust_stock/presentation/pages/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../core/presentation/controllers/products/products.dart';
import '../../controllers/controllers.dart';

class HeaderFilters extends ConsumerStatefulWidget {
  final int enterpriseCode;

  const HeaderFilters({super.key, required this.enterpriseCode});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HeaderFiltersState();
}

class _HeaderFiltersState extends ConsumerState<HeaderFilters> {
  final searchValueController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    searchValueController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchProductKey = SearchProductKey(
      widget.enterpriseCode,
      BsRoutine.adjustStock,
      Modules.adjustStock,
    );
    final screenWidth = MediaQuery.sizeOf(context).width;

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
            //remove the selected index when search the product
            ref
                .read(
                  selectedUIStateControllerProvider(
                    widget.enterpriseCode,
                  ).notifier,
                )
                .updateValues(annulSelectedIndex: true);

            ref
                .read(
                  searchProductsStateControllerProvider(
                    searchProductKey,
                  ).notifier,
                )
                .loadProducts(
                  GetProductsJsonParams(
                    searchValue: searchValueController.text,
                    enterpriseCodes: [widget.enterpriseCode],
                    routine: BsRoutine.adjustStock,
                  ),
                );
          },
        ),
        gapH8,
        if (screenWidth < Breakpoint.desktop) ...[
          JustificationsDropdown(enterpriseCode: widget.enterpriseCode),
          gapH8,
          StocksDropdown(enterpriseCode: widget.enterpriseCode),
        ] else ...[
          Row(
            children: [
              Expanded(
                child: JustificationsDropdown(
                  enterpriseCode: widget.enterpriseCode,
                ),
              ),
              gapW8,
              Expanded(
                child: StocksDropdown(enterpriseCode: widget.enterpriseCode),
              ),
            ],
          ),
        ],
        gapH8,
      ],
    );
  }
}
