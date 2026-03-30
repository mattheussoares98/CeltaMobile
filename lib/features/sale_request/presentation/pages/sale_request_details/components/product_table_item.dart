import 'package:flutter/material.dart';

import '../../../../../../constants/constants.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../../../../utils/utils.dart';
import '../../../../domain/entities/entities.dart';

class ProductTableItem extends StatelessWidget {
  final BSFProductItemEntity cartProduct;
  const ProductTableItem({super.key, required this.cartProduct});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final valueStyle = theme.textTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.w600,
    );
    final labelStyle = theme.textTheme.labelSmall?.copyWith(
      color: theme.hintColor,
      fontSize: 10,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.p12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _Cell(
                label: 'Qtd'.hardcoded,
                value: cartProduct.quantity.toString().toBrazilianNumber(
                  3,
                  true,
                ),
                isPrice: false,
                labelStyle: labelStyle,
                subtitleStyle: valueStyle,
              ),
              _Cell(
                label: 'Preço'.hardcoded,
                value: cartProduct.value.toString().toBrazilianNumber(2),
                labelStyle: labelStyle,
                subtitleStyle: valueStyle,
              ),
              if (cartProduct.totalDiscountValue > 0)
                _Cell(
                  label: 'Desc'.hardcoded,
                  value: cartProduct.totalDiscountValue
                      .toString()
                      .toBrazilianNumber(2),
                  labelStyle: labelStyle,
                  subtitleStyle: valueStyle?.copyWith(color: Colors.red),
                ),
              if (cartProduct.totalIncrement > 0)
                _Cell(
                  label: 'Acrésc'.hardcoded,
                  value: cartProduct.totalIncrement
                      .toString()
                      .toBrazilianNumber(2),
                  labelStyle: labelStyle,
                  subtitleStyle: valueStyle?.copyWith(color: Colors.orange),
                ),
              if (cartProduct.totalDeliveryTax > 0)
                _Cell(
                  label: 'Frete'.hardcoded,
                  value: cartProduct.totalDeliveryTax
                      .toString()
                      .toBrazilianNumber(2),
                  labelStyle: labelStyle,
                  subtitleStyle: valueStyle?.copyWith(
                    color: theme.colorScheme.secondary,
                  ),
                ),
              _Cell(
                label: 'Total'.hardcoded,
                value: cartProduct.totalLiquid.toString().toBrazilianNumber(2),
                labelStyle: labelStyle,
                subtitleStyle: valueStyle?.copyWith(color: theme.primaryColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle? labelStyle;
  final TextStyle? subtitleStyle;
  final bool isPrice;

  const _Cell({
    required this.label,
    required this.value,
    this.labelStyle,
    this.subtitleStyle,
    this.isPrice = true,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              Text(label, style: labelStyle),
              RichText(
                text: TextSpan(
                  children: [
                    if (isPrice && constraints.maxWidth > 50)
                      TextSpan(
                        text: 'R\$ '.hardcoded,
                        style: subtitleStyle?.copyWith(fontSize: 9),
                      ),
                    TextSpan(text: value, style: subtitleStyle),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
