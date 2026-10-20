import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';

class ProductTableItem extends StatelessWidget {
  final BSFProductItemEntity cartProduct;
  const ProductTableItem({super.key, required this.cartProduct});

  @override
  Widget build(BuildContext context) {
    final valueStyle = context.theme.textTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.w600,
    );
    final labelStyle = context.theme.textTheme.labelSmall?.copyWith(
      color: context.theme.hintColor,
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
                label: context.l10n.quantityShort,
                value: cartProduct.quantity.toString().toBrazilianNumber(
                  3,
                  true,
                ),
                isPrice: false,
                labelStyle: labelStyle,
                subtitleStyle: valueStyle,
              ),
              _Cell(
                label: context.l10n.price,
                value: cartProduct.value.toString().toBrazilianNumber(),
                labelStyle: labelStyle,
                subtitleStyle: valueStyle,
              ),
              if (cartProduct.totalDiscountValue > 0)
                _Cell(
                  label: context.l10n.disc,
                  value: cartProduct.totalDiscountValue
                      .toString()
                      .toBrazilianNumber(),
                  labelStyle: labelStyle,
                  subtitleStyle: valueStyle?.copyWith(color: Colors.red),
                ),
              if (cartProduct.totalIncrement > 0)
                _Cell(
                  label: context.l10n.surch,
                  value: cartProduct.totalIncrement
                      .toString()
                      .toBrazilianNumber(),
                  labelStyle: labelStyle,
                  subtitleStyle: valueStyle?.copyWith(color: Colors.orange),
                ),
              if (cartProduct.totalDeliveryTax > 0)
                _Cell(
                  label: context.l10n.freight,
                  value: cartProduct.totalDeliveryTax
                      .toString()
                      .toBrazilianNumber(),
                  labelStyle: labelStyle,
                  subtitleStyle: valueStyle?.copyWith(
                    color: context.theme.colorScheme.secondary,
                  ),
                ),
              _Cell(
                label: context.l10n.total,
                value: cartProduct.totalLiquid.toString().toBrazilianNumber(),
                labelStyle: labelStyle,
                subtitleStyle: valueStyle?.copyWith(
                  color: context.theme.primaryColor,
                ),
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
                        text: 'R\$ ',
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
