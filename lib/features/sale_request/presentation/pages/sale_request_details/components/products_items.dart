import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/sale_request/presentation/pages/sale_request_details/components/components.dart';
import 'package:celta_inventario/features/sale_request/providers.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductsItems extends ConsumerWidget {
  const ProductsItems({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncValueWidget(
      isSliver: true,
      value: ref.watch(
        saleRequestDetailsStateControllerProvider(
          ref.read(saleRequestArgsProvider),
        ),
      ),
      tryAgain: () => ref.invalidate(
        saleRequestDetailsStateControllerProvider(
          ref.read(saleRequestArgsProvider),
        ),
      ),
      data: (requestDetails) {
        final products = requestDetails.products;

        return ResponsiveListFlow(
          isSliver: true,
          itemCount: products?.length ?? 0,
          itemBuilder: (context, index) {
            final cartProduct = products![index];
            final product = cartProduct.product;

            return Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Sizes.p4,
                  vertical: Sizes.p8,
                ),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    BaseRichText(
                      texts: [
                        if (product
                                ?.productPackingPriceLookUpString
                                ?.isNotEmpty ??
                            false)
                          BaseText.title(
                            '${product!.productPackingPriceLookUpString!} ',
                            color: context.theme.primaryColor,
                          ),
                        BaseText.title(product?.name ?? ''),
                        BaseText.title(
                          ' (${product?.productPackingTypeString} ${product?.productPackingQuantity.toString().toBrazilianNumber(3, true)})',
                          color: context.theme.colorScheme.secondary,
                        ),
                      ],
                    ),

                    ProductTableItem(cartProduct: cartProduct),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
