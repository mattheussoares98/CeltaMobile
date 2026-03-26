import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../../../../utils/utils.dart';
import '../../../controllers/controllers.dart';
import 'components.dart';

class ProductsItems extends ConsumerWidget {
  final int saleRequestId;
  final int enterpriseCode;
  final int customerCode;
  const ProductsItems({
    super.key,
    required this.saleRequestId,
    required this.enterpriseCode,
    required this.customerCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = saleRequestDetailsStateControllerProvider(
      saleRequestCode: saleRequestId,
      enterpriseCode: enterpriseCode,
      customerCode: customerCode,
    );

    return AsyncValueWidget(
      value: ref.watch(provider),
      tryAgain: () => ref.invalidate(provider),
      data: (requestDetails) {
        final products = requestDetails.products;
        return ResponsiveListFlow(
          isSliver: true,
          itemCount: products?.length ?? 0,
          itemBuilder: (context, index) {
            final cartProduct = products![index];
            final product = cartProduct.product;

            return Card(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(Sizes.p8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TitleAndSubTitle(
                          title: product!.name!,
                          subTitle:
                              '(${product.productPackingTypeString} ${product.productPackingQuantity.toString().toBrazilianNumber(3, true)})',
                          removeColon: true,
                        ),
                        TitleAndSubTitle(
                          title: 'PLU'.hardcoded,
                          subTitle: product.productPackingPriceLookUpString,
                        ),
                      ],
                    ),
                  ),
                  ProductPriceDescription(cartProduct: cartProduct),
                  gapH8,
                ],
              ),
            );
          },
        );
      },
    );
  }
}
