import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../core/domain/entities/entities.dart';
import '../../../domain/entities/entities.dart';

class BSFProductItemSummary extends StatelessWidget {
  final BSFProductItemEntity item;
  final ProductEntity product;
  const BSFProductItemSummary({
    super.key,
    required this.item,
    required this.product,
  });

  bool get changedPrice {
    final cartQuantity = item.quantity ?? 0;
    final cartValue = item.value;
    if (cartQuantity >= (product.MinimumWholeQuantity ?? 0) &&
        (product.WholePracticedPrice ?? 0) > 0) {
      return cartValue != null && cartValue != product.WholePracticedPrice;
    }
    return cartValue != null && cartValue != product.getPrice;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    TextStyle? titleStyle = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.secondary,
    );
    TextStyle? subtitleStyle = theme.textTheme.titleMedium?.copyWith(
      color: theme.colorScheme.secondary,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleAndSubTitle(
          title: 'Qtd no carrinho'.hardcoded,
          subTitle: (item.quantity ?? 0).toString().toBrazilianNumber(3, true),
          titleStyle: titleStyle,
          subTitleStyle: subtitleStyle,
        ),
        if (changedPrice)
          TitleAndSubTitle(
            title: 'Preço digitado'.hardcoded,
            subTitle: (item.value ?? 0).toString().toBrazilianNumber(),
            subTitleIsPrice: true,
            titleStyle: titleStyle,
            subTitleStyle: subtitleStyle,
          ),
        if (item.totalDeliveryTax > 0)
          TitleAndSubTitle(
            title: 'Frete'.hardcoded,
            subTitle: item.totalDeliveryTax.toString().toBrazilianNumber(),
            subTitleIsPrice: true,
            titleStyle: titleStyle,
            subTitleStyle: subtitleStyle,
          ),
        if (item.totalDiscountValue > 0)
          TitleAndSubTitle(
            title: 'Desconto'.hardcoded,
            subTitle: item.totalDiscountValue.toString().toBrazilianNumber(),
            subTitleIsPrice: true,
            titleStyle: titleStyle,
            subTitleStyle: subtitleStyle,
          ),
        if (item.totalIncrement > 0)
          TitleAndSubTitle(
            title: 'Acréscimo'.hardcoded,
            subTitle: item.totalIncrement.toString().toBrazilianNumber(),
            subTitleIsPrice: true,
            titleStyle: titleStyle,
            subTitleStyle: subtitleStyle,
          ),
        TitleAndSubTitle(
          title: 'Total'.hardcoded,
          subTitle: item.totalLiquid.toString().toBrazilianNumber(),
          subTitleIsPrice: true,
          titleStyle: titleStyle,
          subTitleStyle: subtitleStyle,
        ),
      ],
    );
  }
}
