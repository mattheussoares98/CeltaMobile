import 'package:collection/collection.dart';
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
import '../../../components/components.dart';

class ProductsList extends ConsumerWidget {
  final SearchProductKey searchProductKey;
  final int customerCode;

  const ProductsList({
    super.key,
    required this.searchProductKey,
    required this.customerCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void onTap(ProductEntity product) {
      final provider = insertUpdateStateControllerProvider(
        enterpriseCode: searchProductKey.enterpriseCode,
        customerCode: customerCode,
        saleRequestId: int.parse(searchProductKey.anotherKey!),
      );

      final saleRequest = ref.read(provider).value;
      final existingItems = saleRequest?.products ?? [];

      final existingItem = existingItems
          .cast<BSFProductItemEntity?>()
          .firstWhereOrNull(
            (e) => e?.product?.productPackingPriceLookUpString == product.PLU,
          );

      final itemToEdit = existingItem ?? product.toBSFProductItemEntity();

      context.pushNamed(
        Routes.saleRequestInsertProduct.name,
        extra: {'product': itemToEdit, 'originalProduct': product},
        pathParameters: {
          'saleRequestId': searchProductKey.anotherKey!,
          'enterpriseCode': searchProductKey.enterpriseCode.toString(),
          'customerCode': customerCode.toString(),
        },
      );
    }

    return AsyncValueWidget(
      value: ref.watch(searchProductsStateControllerProvider(searchProductKey)),
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
            return _ProductItem(
              key: ValueKey(product.ProductPackingCode),
              product: product,
              onTap: () => onTap(product),
              enterpriseCode: searchProductKey.enterpriseCode,
              customerCode: customerCode,
              saleRequestId: int.parse(searchProductKey.anotherKey!),
            );
          },
        );
      },
      tryAgain: () => ref.invalidate(
        searchProductsStateControllerProvider(searchProductKey),
      ),
    );
  }
}

class _ProductItem extends ConsumerWidget {
  const _ProductItem({
    required this.product,
    required this.onTap,
    required this.enterpriseCode,
    required this.customerCode,
    required this.saleRequestId,
    super.key,
  });

  final ProductEntity product;
  final VoidCallback onTap;
  final int enterpriseCode;
  final int customerCode;
  final int saleRequestId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final existingItem = ref.watch(
      insertUpdateStateControllerProvider(
        enterpriseCode: enterpriseCode,
        customerCode: customerCode,
        saleRequestId: saleRequestId,
      ).select((state) {
        return state.value?.products
            ?.cast<BSFProductItemEntity?>()
            .firstWhereOrNull(
              (e) => e?.product?.productPackingPriceLookUpString == product.PLU,
            );
      }),
    );

    return Hero(
      tag: 'sale_request_product_${product.ProductPackingCode}',
      child: Material(
        type: MaterialType.transparency,
        child: SingleChildScrollView(
          child: ProductItemWidget(
            product: product,
            routine: BsRoutine.saleRequest,
            onTap: onTap,
            cartItemSummary: BSFProductItemSummary(
              item: existingItem,
              product: product,
              enterpriseCode: enterpriseCode,
              customerCode: customerCode,
              saleRequestId: saleRequestId,
            ),
          ),
        ),
      ),
    );
  }
}
