import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/products/products.dart';
import 'package:celta_inventario/features/buy_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/buy_request/presentation/pages/create/products/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductsPage extends ConsumerStatefulWidget {
  final int enterpriseCode;
  const ProductsPage({super.key, required this.enterpriseCode});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductsPageState();
}

class _ProductsPageState extends ConsumerState<ProductsPage> {
  final searchProductController = TextEditingController();
  static const searchProductKey = SearchProductKey(
    0,
    BsRoutine.buyRequest,
    Modules.buyRequest,
  );

  @override
  dispose() {
    super.dispose();
    searchProductController.dispose();
  }

  Future<void> searchProducts(int? exactProductCode) async {
    ref
        .read(uiStateControllerProvider(widget.enterpriseCode).notifier)
        .updateSelectedProductIndex(null);
    final selectedEnterprises = ref.read(
      pendingBuyRequestStateControllerProvider(
        widget.enterpriseCode,
      ).select((s) => s.value?.selectedEnterprises),
    );
    await ref
        .read(searchProductsStateControllerProvider(searchProductKey).notifier)
        .loadProducts(
          exactProductCode: exactProductCode,
          GetProductsJsonParams(
            enterpriseCodes:
                selectedEnterprises?.map((e) => e.Code!).toList() ?? [],
            searchValue: searchProductController.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      isScrollable: false,
      usePadding: false,
      safeAreaTop: false,
      body: Column(
        children: [
          Consumer(
            builder: (_, ref, _) {
              return BaseSearchProducts(
                searchProductKey: searchProductKey,
                searchProducts: searchProducts,
                searchValueController: searchProductController,
              );
            },
          ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                gapSliverH8,
                ProductsItems(enterpriseCode: widget.enterpriseCode),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
