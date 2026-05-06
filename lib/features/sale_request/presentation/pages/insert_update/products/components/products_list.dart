import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/products/products.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    return AsyncValueWidget(
      value: ref.watch(searchProductsStateControllerProvider(searchProductKey)),
      data: (products) {
        if (products.isEmpty) {
          return Center(
            child: Text('Pesquise um produto para começar'.hardcoded),
          );
        }

        final saleRequestId = int.parse(searchProductKey.anotherKey!);

        return ResponsiveListFlow(
          padding: const EdgeInsets.all(Sizes.p4),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];

            return Consumer(
              builder: (context, ref, child) {
                final existingItem = ref.watch(
                  insertUpdateStateControllerProvider(
                    enterpriseCode: searchProductKey.enterpriseCode,
                    customerCode: customerCode,
                    saleRequestId: saleRequestId,
                  ).select((state) {
                    return state.value?.products
                        ?.cast<BSFProductItemEntity?>()
                        .firstWhereOrNull(
                          (e) =>
                              e?.product?.productPackingPriceLookUpString ==
                              product.PLU,
                        );
                  }),
                );

                return BSFProductItemSummary(
                  key: ValueKey(product.PLU),
                  product: product,
                  item: existingItem ?? product.toBSFProductItemEntity(),
                  enterpriseCode: searchProductKey.enterpriseCode,
                  customerCode: customerCode,
                  saleRequestId: saleRequestId,
                  heroPrefix: 'products',
                );
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
}
