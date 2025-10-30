import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../core/domain/entities/entities.dart';
import '../../../../../../../core/presentation/controllers/products/products.dart';

class SearchProducts extends ConsumerWidget {
  final int enterpriseCode;
  final TextEditingController searchProductsController;
  const SearchProducts({
    super.key,
    required this.enterpriseCode,
    required this.searchProductsController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchAsync = ref.watch(
      searchProductsStateControllerProvider(
        enterpriseCode,
        BsRoutine.saleRequest,
        Modules.saleRequest,
      ),
    );

    return DefaultSearchProducts(
      isLoading: searchAsync.isLoading,
      searchValueController: searchProductsController,
      searchProducts: () {
        ref
            .read(
              searchProductsStateControllerProvider(
                enterpriseCode,
                BsRoutine.saleRequest,
                Modules.saleRequest,
              ).notifier,
            )
            .loadProducts(
              searchValue: searchProductsController.text,
              enterpriseCodes: [enterpriseCode],
            );
      },
    );
  }
}
