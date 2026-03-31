import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../core/presentation/controllers/products/products.dart';
import '../../../../../localization/string_hardcoded.dart';
import '../../controllers/controllers.dart';

class ProductsItems extends ConsumerWidget {
  final int enterpriseCode;
  const ProductsItems({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchProductKey = SearchProductKey(
      enterpriseCode,
      BsRoutine.generic,
      Modules.adjustCost,
    );
    return AsyncValueWidget(
      value: ref.watch(searchProductsStateControllerProvider(searchProductKey)),
      tryAgain: () => ref.invalidate(
        searchProductsStateControllerProvider(searchProductKey),
      ),
      data: (products) {
        return Expanded(
          child: ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              return _ProductItem(
                key: ValueKey(products[index].ProductPackingCode),
                index: index,
                enterpriseCode: enterpriseCode,
              );
            },
          ),
        );
      },
    );
  }
}

class _ProductItem extends ConsumerWidget {
  const _ProductItem({
    super.key,
    required this.index,
    required this.enterpriseCode,
  });

  final int index;
  final int enterpriseCode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = ref.watch(
      searchProductsStateControllerProvider(
        SearchProductKey(enterpriseCode, BsRoutine.generic, Modules.adjustCost),
      ).select((s) => s.value![index]),
    );

    return ProductItemWidget(
      product: product,
      routine: BsRoutine.generic,
      hidePrice: true,
      hideCurrentAndSaleStocks: true,
      hideWholeInformations: true,
      showDropIcon: true,
      hideCost: true,
      isSelected: ref.watch(
        selectedProductIndexStateControllerProvider(
          enterpriseCode,
        ).select((s) => s == index),
      ),
      onTap: () {
        ref
            .read(
              selectedProductIndexStateControllerProvider(
                enterpriseCode,
              ).notifier,
            )
            .updateIndex(index, annulWhenIsSame: true);
      },
      clickableBottom: TitleAndSubTitle(
        title: 'Custo de reposição'.hardcoded,
        subTitle: product.ReplacementCost,
        subTitleIsPrice: true,
        emptyMessage: 'Sem custo de reposição'.hardcoded,
      ),
    );
  }
}
