import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../core/presentation/controllers/products/products.dart';
import 'components/components.dart';

class ProductsPage extends ConsumerStatefulWidget {
  final int enterpriseCode;
  final TextEditingController searchValueController;
  final TextEditingController quantityController;
  final FocusNode quantityFocusNode;
  const ProductsPage({
    super.key,
    required this.enterpriseCode,
    required this.searchValueController,
    required this.quantityController,
    required this.quantityFocusNode,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductsPageState();
}

class _ProductsPageState extends ConsumerState<ProductsPage> {
  final formKey = GlobalKey<FormState>();

  Future<void> _searchProducts(SearchProductKey searchProductKey) async {
    await ref
        .read(searchProductsStateControllerProvider(searchProductKey).notifier)
        .loadProducts(
          GetProductsJsonParams(
            searchValue: widget.searchValueController.text,
            enterpriseCodes: [widget.enterpriseCode],
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final searchProductKey = SearchProductKey(
      widget.enterpriseCode,
      BsRoutine.adjustStock,
      Modules.transferBetweenStocks,
    );

    return Padding(
      padding: const EdgeInsets.all(Sizes.p8),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            DefaultSearchProducts(
              searchValueController: widget.searchValueController,
              searchProductKey: searchProductKey,
              isLoading: ref.watch(
                searchProductsStateControllerProvider(
                  searchProductKey,
                ).select((state) => state.isLoading),
              ),
              searchProducts: () => _searchProducts(searchProductKey),
            ),
            gapH8,
            JustificationsDropdown(enterpriseCode: widget.enterpriseCode),
            gapH8,
            OriginStocksDropdown(enterpriseCode: widget.enterpriseCode),
            gapH8,
            DestinyStocksDropdown(enterpriseCode: widget.enterpriseCode),
            gapH8,
            Flexible(
              child: ProductsItems(
                formKey: formKey,
                searchProductKey: searchProductKey,
                widget: widget,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
