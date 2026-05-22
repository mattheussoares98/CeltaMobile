import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/products/products.dart';
import 'package:celta_inventario/features/adjust_sale_price/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/enterprises/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/routing/routes.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProductsItems extends ConsumerWidget {
  const ProductsItems({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enterpriseCode = ref.watch(
      selectedEnterpriseStateControllerProvider.select((s) => s?.Code),
    );

    if (enterpriseCode == null) {
      return const SizedBox.shrink();
    }

    final searchProductKey = SearchProductKey(
      enterpriseCode,
      BsRoutine.adjustSalePrice,
      Modules.adjustPrice,
    );

    return Consumer(
      builder: (_, ref, _) {
        return AsyncValueWidget(
          value: ref.watch(
            searchProductsStateControllerProvider(searchProductKey),
          ),
          tryAgain: null,
          data: (products) {
            return ResponsiveListFlow(
              physics: const ClampingScrollPhysics(),
              itemCount: products.length,
              itemBuilder: (_, index) {
                return _ProductItem(
                  key: ValueKey('product_$index'),
                  index: index,
                );
              },
            );
          },
        );
      },
    );
  }
}

class _ProductItem extends ConsumerWidget {
  final int index;
  const _ProductItem({super.key, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enterpriseCode = ref.watch(
      selectedEnterpriseStateControllerProvider.select((s) => s?.Code),
    );

    if (enterpriseCode == null) {
      return const SizedBox.shrink();
    }

    final searchProductKey = SearchProductKey(
      enterpriseCode,
      BsRoutine.adjustSalePrice,
      Modules.adjustPrice,
    );

    final product = ref.watch(
      searchProductsStateControllerProvider(
        searchProductKey,
      ).select((s) => s.value![index]),
    );

    return ProductItemWidget(
      product: product,
      routine: BsRoutine.adjustSalePrice,
      notClickableBottom: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (PlatformUtil.isCupertino)
            const Expanded(flex: 55, child: Text('')),
          Flexible(
            flex: 45,
            child: PrimaryTextButton(
              text: 'Alterar preços'.hardcoded,
              icon: const PlatformIcon(
                cupertinoIcon: CupertinoIcons.pencil,
                materialIcon: Icons.edit,
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
