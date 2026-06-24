import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/products/products.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductsItems extends ConsumerWidget {
  final int enterpriseCode;
  const ProductsItems({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchProductKey = SearchProductKey(
      enterpriseCode,
      BsRoutine.generic,
      Modules.productsRegister,
    );

    return Consumer(
      builder: (_, ref, _) {
        final items = ref.watch(
          searchProductsStateControllerProvider(searchProductKey),
        );
        return ResponsiveListFlow(
          isSliver: true,
          itemCount: items.value?.length ?? 0,
          itemBuilder: (context, index) {
            final product = items.value?[index];
            return ProductItemWidget(
              product: product!,
              routine: BsRoutine.generic,
              hideCost: true,
              hideCurrentAndSaleStocks: true,
              hidePrice: true,
              hideWholeInformations: true,
              showEditIcon: true,
              showInfoButton: false,
              editIcon: const PlatformIcon(
                cupertinoIcon: CupertinoIcons.arrow_up_right,
                materialIcon: Icons.arrow_outward_outlined,
              ),
              onTap: () {
                //TODO navigate to the next page
              },
            );
          },
        );
      },
    );
  }
}
