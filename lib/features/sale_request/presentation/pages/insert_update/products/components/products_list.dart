import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/products/products.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/sale_request/presentation/pages/components/components.dart';
import 'package:celta_inventario/features/sale_request/providers.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductsList extends ConsumerWidget {
  const ProductsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args = ref.watch(saleRequestArgsProvider);

    final searchProductKey = SearchProductKey(
      args.enterpriseCode,
      BsRoutine.saleRequest,
      Modules.saleRequest,
      anotherKey: args.toString(),
    );
    return AsyncValueWidget(
      value: ref.watch(searchProductsStateControllerProvider(searchProductKey)),
      tryAgain: null,
      data: (products) {
        if (products.isEmpty) {
          return Center(
            child: Text(context.l10n.searchForAProductToGetStarted),
          );
        }

        return ResponsiveListFlow(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];

            return Consumer(
              builder: (context, ref, child) {
                final existingItem = ref.watch(
                  insertUpdateStateControllerProvider.select((state) {
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
                  heroPrefix: 'products',
                  showInfoButton: true,
                  showStock: true,
                );
              },
            );
          },
        );
      },
    );
  }
}
