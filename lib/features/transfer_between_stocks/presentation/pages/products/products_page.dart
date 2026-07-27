import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/products/products.dart';
import 'package:celta_inventario/features/transfer_between_stocks/presentation/pages/products/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductsPage extends ConsumerStatefulWidget {
  final int enterpriseCode;
  const ProductsPage({super.key, required this.enterpriseCode});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductsPageState();
}

class _ProductsPageState extends ConsumerState<ProductsPage> {
  final searchValueController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    searchValueController.dispose();
    super.dispose();
  }

  Future<void> _searchProducts(
    SearchProductKey searchProductKey,
    int? exactProductCode,
  ) async {
    await ref
        .read(searchProductsStateControllerProvider(searchProductKey).notifier)
        .loadProducts(
          exactProductCode: exactProductCode,
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
    //TODO check this page on an iOS device. There is a large blank space on top of this
    return BaseScaffold(
      isScrollable: false,
      padding: const EdgeInsets.symmetric(horizontal: Sizes.p8),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            SizedBox(
              width: Breakpoint.tablet,
              child: BaseSearchProducts(
                searchValueController: searchValueController,
                searchProductKey: searchProductKey,
                searchProducts: (exactProductCode) =>
                    _searchProducts(searchProductKey, exactProductCode),
              ),
            ),
            gapH8,
            DropDowns(enterpriseCode: widget.enterpriseCode),
            gapH8,
            ProductsItems(
              searchProductKey: searchProductKey,
              enterpriseCode: widget.enterpriseCode,
              formKey: formKey,
            ),
          ],
        ),
      ),
    );
  }
}
