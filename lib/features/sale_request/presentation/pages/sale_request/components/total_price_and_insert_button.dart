import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../constants/constants.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../domain/entities/entities.dart';

class TotalPriceAndInsertButton extends StatelessWidget {
  final VoidCallback insertProduct;
  final PercentageOrValue? discountType;
  final TextEditingController priceController;
  final TextEditingController quantityController;
  final TextEditingController discountController;
  final ProductEntity product;
  const TotalPriceAndInsertButton({
    super.key,
    required this.insertProduct,
    required this.discountType,
    required this.priceController,
    required this.quantityController,
    required this.discountController,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: Listenable.merge([
        priceController,
        quantityController,
        discountController,
      ]),
      builder: (_, _) {
        final newItem = CartProductEntity.create(
          quantity: quantityController.text.toDouble() ?? 0,
          price: priceController.text.toDouble() ?? 0,
          discountByItem: discountController.text.toDouble(),
          discountType: discountType,
          product: product,
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
