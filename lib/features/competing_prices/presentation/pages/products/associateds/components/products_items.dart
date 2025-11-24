import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../core/domain/entities/entities.dart';
import '../../../../../../../core/presentation/controllers/products/products.dart';
import '../../../../controllers/controllers.dart';

class ProductsItems extends ConsumerWidget {
  final int enterpriseCode;
  const ProductsItems({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncValueWidget(
      value: ref.watch(
        searchProductsStateControllerProvider(
          enterpriseCode,
          BsRoutine.researchOfPrice,
          Modules.competingPrices,
        ),
      ),
      tryAgain: null,
      data: (products) {
        return Expanded(
          child: ResponsiveListFlow(
            itemCount: products.length,
            itemBuilder: (_, index) {
              final product = products[index];

              return ProductItemWidget(
                product: product,
                routine: BsRoutine.researchOfPrice,
                showDropIcon: true,
                clickableBottom: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if ((product.RetailPracticedPrice ?? 0) > 0)
                      TitleAndSubTitle(
                        title: 'Venda'.hardcoded,
                        subTitle: product.RetailPracticedPrice,
                        subTitleIsPrice: true,
                      ),
                    if ((product.RetailOfferPrice ?? 0) > 0)
                      TitleAndSubTitle(
                        title: 'Venda (oferta)'.hardcoded,
                        subTitle: product.RetailOfferPrice,
                        subTitleIsPrice: true,
                      ),
                    if ((product.WholePracticedPrice ?? 0) > 0)
                      TitleAndSubTitle(
                        title: 'Atacado'.hardcoded,
                        subTitle: product.WholePracticedPrice,
                        subTitleIsPrice: true,
                      ),
                    if ((product.WholeOfferPrice ?? 0) > 0)
                      TitleAndSubTitle(
                        title: 'Atacado (oferta)'.hardcoded,
                        subTitle: product.WholeOfferPrice,
                        subTitleIsPrice: true,
                      ),
                    if ((product.ECommercePracticedPrice ?? 0) > 0)
                      TitleAndSubTitle(
                        title: 'Ecommerce'.hardcoded,
                        subTitle: product.ECommercePracticedPrice,
                        subTitleIsPrice: true,
                      ),
                    if ((product.ECommerceOfferPrice ?? 0) > 0)
                      TitleAndSubTitle(
                        title: 'Ecommerce (oferta)'.hardcoded,
                        subTitle: product.ECommerceOfferPrice,
                        subTitleIsPrice: true,
                      ),
                  ],
                ),
                isSelected: ref.watch(
                  selectedItemUIControllerProvider.select(
                    (s) => s.selectedIndex == index,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
