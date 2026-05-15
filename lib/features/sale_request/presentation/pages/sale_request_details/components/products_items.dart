import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../utils/utils.dart';
import '../../../../providers.dart';
import '../../../controllers/controllers.dart';
import 'components.dart';

class ProductsItems extends ConsumerWidget {
  const ProductsItems({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args = ref.watch(saleRequestArgsProvider);
    return AsyncValueWidget(
      isSliver: true,
      value: ref.watch(saleRequestDetailsStateControllerProvider),
      tryAgain: () => ref.invalidate(saleRequestDetailsStateControllerProvider),
      data: (requestDetails) {
        final products = requestDetails.products;

        return ResponsiveListFlow(
          isSliver: true,
          itemCount: products?.length ?? 0,
          itemBuilder: (context, index) {
            final cartProduct = products![index];
            final product = cartProduct.product;

            return RepaintBoundary(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Sizes.p4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          product?.name ?? '',
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'PLU: ${product?.productPackingPriceLookUpString} | (${product?.productPackingTypeString} ${product?.productPackingQuantity.toString().toBrazilianNumber(3, true)})',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(color: Theme.of(context).hintColor),
                        ),
                      ],
                    ),
                  ),

                  ProductTableItem(cartProduct: cartProduct),
                  const Divider(height: Sizes.p8),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
