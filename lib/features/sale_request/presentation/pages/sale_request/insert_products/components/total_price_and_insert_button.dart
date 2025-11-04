import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../constants/constants.dart';
import '../../../../../../../core/domain/entities/entities.dart';
import '../../../../../domain/entities/entities.dart';
import 'components.dart';

class TotalPriceAndInsertButton extends StatelessWidget {
  final VoidCallback insertProduct;
  final ProductEntity product;
  final ProductsItems productsItems;
  final PercentageOrValue? discountType;
  const TotalPriceAndInsertButton({
    super.key,
    required this.insertProduct,
    required this.product,
    required this.productsItems,
    required this.discountType,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: Listenable.merge([
        productsItems.priceController,
        productsItems.quantityController,
        productsItems.discountController,
      ]),
      builder: (_, _) {
        final newItem = CartProductEntity.create(
          product: product,
          quantity: productsItems.quantityController.text.toDouble() ?? 0,
          price: productsItems.priceController.text.toDouble() ?? 0,
          discountByItem: productsItems.discountController.text.toDouble(),
          discountType: discountType,
        );
        return Column(
          children: [
            Text('Total'.hardcoded, style: theme.textTheme.titleSmall),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'R\$ '.hardcoded,
                    style: theme.textTheme.titleSmall?.copyWith(fontSize: 10),
                  ),
                  TextSpan(
                    text: newItem.getTotalLiquid
                        .toString()
                        .toBrazilianNumber()
                        .hardcoded,
                    style: theme.textTheme.titleSmall,
                  ),
                ],
              ),
            ),
            gapH4,
            PrimaryButton(
              text: 'Adicionar'.hardcoded,
              onPressed: insertProduct,
            ),
          ],
        );
      },
    );
  }
}
