import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';

class TotalPriceAndInsertButton extends StatelessWidget {
  final VoidCallback insertProduct;
  final ProductEntity product;
  final PercentageOrValue? discountType;
  final TextEditingController priceController;
  final TextEditingController quantityController;
  final TextEditingController discountController;
  const TotalPriceAndInsertButton({
    super.key,
    required this.insertProduct,
    required this.product,
    required this.discountType,
    required this.priceController,
    required this.quantityController,
    required this.discountController,
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
        final newItem = SaleRequestCartProductEntity.create(
          product: product,
          quantity: quantityController.text.toDouble() ?? 0,
          price: priceController.text.toDouble() ?? 0,
          discountByItem: discountController.text.toDouble(),
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
