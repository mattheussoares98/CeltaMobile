import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../core/presentation/controllers/products/products.dart';
import 'components/components.dart';

class ProductsPage extends ConsumerStatefulWidget {
  final int enterpriseCode;
  const ProductsPage({super.key, required this.enterpriseCode});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductsPageState();
}

class _ProductsPageState extends ConsumerState<ProductsPage> {
  final searchValueController = TextEditingController();
  final quantityController = TextEditingController();
  final quantityFocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();

    searchValueController.dispose();
    quantityController.dispose();
    quantityFocusNode.dispose();
  }

  Future<void> _searchProducts(SearchProductKey searchProductKey) async {
    await ref
        .read(searchProductsStateControllerProvider(searchProductKey).notifier)
        .loadProducts(
          GetProductsJsonParams(
            searchValue: searchValueController.text,
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
              searchValueController: searchValueController,
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
                searchProductKey: searchProductKey,
                enterpriseCode: widget.enterpriseCode,
                quantityController: quantityController,
                formKey: formKey,
                quantityFocusNode: quantityFocusNode,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
