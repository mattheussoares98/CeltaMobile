import 'package:flutter/material.dart';

import '../../../../../../localization/string_hardcoded.dart';
import '../../../../../../utils/utils.dart';
import '../../../../domain/entities/entities.dart';

class ProductPriceDescription extends StatelessWidget {
  final BSFProductItemEntity cartProduct;
  const ProductPriceDescription({super.key, required this.cartProduct});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleStyle = theme.textTheme.titleMedium;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _ColumnItem(
          titleStyle: titleStyle,
          title: 'Qtd'.hardcoded,
          value: cartProduct.quantity.toString().toBrazilianNumber(3, true),
        ),
        _ColumnItem(
          titleStyle: titleStyle,
          title: 'Preço'.hardcoded,
          value: cartProduct.value.toString().toBrazilianNumber(2),
        ),
        if (cartProduct.unitDiscountValue > 0)
          _ColumnItem(
            titleStyle: titleStyle,
            title: 'Desc'.hardcoded,
            value: cartProduct.unitDiscountValue.toString().toBrazilianNumber(),
          ),
        if (cartProduct.unitIncrement > 0)
          _ColumnItem(
            titleStyle: titleStyle,
            title: 'Acrésc'.hardcoded,
            value: cartProduct.unitIncrement.toString().toBrazilianNumber(),
          ),
        if (cartProduct.unitDeliveryTax > 0)
          _ColumnItem(
            titleStyle: titleStyle,
            title: 'Delivery'.hardcoded,
            value: cartProduct.unitDeliveryTax.toString().toBrazilianNumber(),
          ),
        _ColumnItem(
          titleStyle: titleStyle,
          title: 'Total'.hardcoded,
          value: cartProduct.totalLiquid.toString().toBrazilianNumber(),
        ),
      ],
    );
  }
}

class _ColumnItem extends StatelessWidget {
  final TextStyle? titleStyle;
  final String value;
  final String title;
  const _ColumnItem({
    required this.titleStyle,
    required this.value,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        children: [
          Text(title, style: titleStyle),
          Text(value),
        ],
      ),
    );
  }
}
