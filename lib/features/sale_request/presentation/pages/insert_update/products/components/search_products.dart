import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/products/products.dart';
import 'package:celta_inventario/features/sale_request/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchProducts extends ConsumerStatefulWidget {
  const SearchProducts({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchProductsState();
}

class _SearchProductsState extends ConsumerState<SearchProducts> {
  final searchProductsController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    searchProductsController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ref.watch(saleRequestArgsProvider);

    final searchProductKey = SearchProductKey(
      args.enterpriseCode,
      BsRoutine.saleRequest,
      Modules.saleRequest,
      anotherKey: args.toString(),
    );
    return BaseSearchProducts(
      searchValueController: searchProductsController,
      searchProductKey: searchProductKey,
      searchProducts: (exactProductCode) {
        ref
            .read(
              searchProductsStateControllerProvider(searchProductKey).notifier,
            )
            .loadProducts(
              exactProductCode: exactProductCode,
              GetProductsJsonParams(
                searchValue: searchProductsController.text,
                enterpriseCodes: [searchProductKey.enterpriseCode],
              ),
            );
      },
    );
  }
}
