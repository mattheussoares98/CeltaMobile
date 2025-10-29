import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../../core/presentation/controllers/products/products.dart';
import '../../../../../enterprise_manager/domain/entities/entities.dart';

class InsertProductsPage extends ConsumerWidget {
  final int enterpriseCode;
  final TextEditingController searchProductsController;
  const InsertProductsPage({
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
    return Padding(
      padding: const EdgeInsets.all(Sizes.p8),
      child: Column(
        children: [
          DefaultSearchProducts(
            isLoading: searchAsync.isLoading,
            searchProducts: () {
              //TODO search products
            },
            searchValueController: searchProductsController,
          ),
          AsyncValueWidget(
            value: searchAsync,
            tryAgain: () {
              ref.invalidate(
                searchProductsStateControllerProvider(
                  enterpriseCode,
                  BsRoutine.saleRequest,
                  Modules.saleRequest,
                ),
              );
            },
            data: (products) {
              return ListView.builder(
                itemCount: products.length,
                itemBuilder: (_, index) {
                  final product = products[index];
                  return ProductItemWidget(
                    product: product,
                    routine: BsRoutine.saleRequest,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
