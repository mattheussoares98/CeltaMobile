import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../commom_widgets/commom_widgets.dart';
import '../../../../constants/constants.dart';
import '../../../../core/domain/entities/entities.dart';
import '../../../../core/presentation/controllers/products/products.dart';
import '../../../../routing/routing.dart';
import '../controllers/controllers.dart';
import 'components/components.dart';

class AdjustSalePriceProductsPage extends ConsumerWidget {
  final int enterpriseCode;
  const AdjustSalePriceProductsPage({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchProductKey = SearchProductKey(
      enterpriseCode,
      BsRoutine.adjustSalePrice,
      Modules.adjustPrice,
    );

    return Scaffold(
      appBar: AppBar(
        title: DefaultAppBarTitle(
          enterpriseCode: enterpriseCode,
          title: 'Produtos (ajuste de preços)'.hardcoded,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.p4),
        child: Column(
          children: [
            SearchProduct(
              searchProductKey: searchProductKey,
              enterpriseCode: enterpriseCode,
            ),
            gapH8,
            Expanded(
              child: Consumer(
                builder: (_, ref, _) {
                  return AsyncValueWidget(
                    value: ref.watch(
                      searchProductsStateControllerProvider(searchProductKey),
                    ),
                    tryAgain: null,
                    data: (products) {
                      return ResponsiveListFlow(
                        itemCount: products.length,
                        itemBuilder: (_, index) {
                          final product = products[index];
                          return _ProductItem(
                            key: ValueKey(
                              'product_${product.ProductPackingCode}',
                            ),
                            product: product,
                            enterpriseCode: enterpriseCode,
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductItem extends ConsumerWidget {
  final ProductEntity product;
  final int enterpriseCode;
  const _ProductItem({
    super.key,
    required this.product,
    required this.enterpriseCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;
    return ProductItemWidget(
      product: product,
      routine: BsRoutine.adjustSalePrice,
      notClickableBottom: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (isIOS) const Expanded(flex: 55, child: Text('')),
          Flexible(
            flex: 45,
            child: PrimaryTextButton(
              text: 'Alterar preços'.hardcoded,
              icon: Icon(
                theme.platform == TargetPlatform.iOS
                    ? CupertinoIcons.pencil
                    : Icons.edit,
              ),
              iconAlignment: IconAlignment.end,
              onPressed: () {
                ref
                    .read(
                      selectedProductStateControllerProvider(
                        enterpriseCode,
                        product.PLU!,
                      ).notifier,
                    )
                    .updateSelectedProduct(product);
                context.goNamed(
                  Routes.adjustSalePrice.name,
                  pathParameters: {
                    'enterpriseCode': enterpriseCode.toString(),
                    'plu': product.PLU!,
                  },
                  extra: product,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
