import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../constants/constants.dart';
import '../../../../../../../core/domain/entities/entities.dart';
import '../../../../../../../core/presentation/controllers/products/products.dart';
import '../../../../../../../localization/string_hardcoded.dart';
import '../../../../../../../routing/routing.dart';
import '../../../../../domain/entities/entities.dart';
import '../../../../controllers/controllers.dart';

class ProductsList extends ConsumerWidget {
  final int enterpriseCode;
  final int customerCode;
  final int saleRequestId;

  const ProductsList({
    super.key,
    required this.enterpriseCode,
    required this.customerCode,
    required this.saleRequestId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchProductKey = SearchProductKey(
      enterpriseCode,
      BsRoutine.saleRequest,
      Modules.saleRequest,
    );

    final productsAsync = ref.watch(
      searchProductsStateControllerProvider(searchProductKey),
    );

    return AsyncValueWidget(
      value: productsAsync,
      data: (products) {
        if (products.isEmpty) {
          return Center(
            child: Text('Pesquise um produto para começar'.hardcoded),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(Sizes.p4),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return ProductItemWidget(
              product: product,
              routine: BsRoutine.saleRequest,
              onTap: () {
                _navigateToProductDetail(context, ref, product);
              },
            );
          },
        );
      },
      tryAgain: () => ref.invalidate(
        searchProductsStateControllerProvider(searchProductKey),
      ),
    );
  }

  void _navigateToProductDetail(
    BuildContext context,
    WidgetRef ref,
    ProductEntity product,
  ) {
    final provider = insertUpdateStateControllerProvider(
      enterpriseCode: enterpriseCode,
      customerCode: customerCode,
      saleRequestId: saleRequestId,
    );

    final saleRequest = ref.read(provider).value;
    final existingItems = saleRequest?.products ?? [];

    final productCode =
        product.ProductPackingCode?.toString() ??
        product.ProductCode?.toString();

    final existingItem = existingItems.cast<BSFProductItemEntity?>().firstWhere(
      (e) => e?.product?.personalizedCode == productCode,
      orElse: () => null,
    );

    final itemToEdit = existingItem ?? product.toBSFProductItemEntity();

    context.pushNamed(
      Routes.saleRequestInsertProduct.name,
      extra: itemToEdit,
      pathParameters: {
        'saleRequestId': saleRequestId.toString(),
        'enterpriseCode': enterpriseCode.toString(),
        'customerCode': customerCode.toString(),
      },
    );
  }
}
