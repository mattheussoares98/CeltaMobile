import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../domain/entities/entities.dart';

class CartItemSummary extends StatelessWidget {
  final CartProductEntity cartProduct;
  const CartItemSummary({super.key, required this.cartProduct});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    TextStyle? style = theme.textTheme.titleMedium?.copyWith(
      color: theme.colorScheme.secondary,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleAndSubTitle(
          title: 'Qtd no carrinho'.hardcoded,
          subTitle: cartProduct.Quantity.toString().toBrazilianNumber(),
          titleStyle: style,
          subTitleStyle: style,
        ),
        TitleAndSubTitle(
          title: 'Preço'.hardcoded,
          subTitle: cartProduct.valueLiquid.toString().toBrazilianNumber(),
          subTitleIsPrice: true,
          titleStyle: style,
          subTitleStyle: style,
        ),
        TitleAndSubTitle(
          title: 'Total'.hardcoded,
          subTitle: cartProduct.valueLiquid.toString().toBrazilianNumber(),
          subTitleIsPrice: true,
          titleStyle: style,
          subTitleStyle: style,
        ),
      ],
    );
  }
}
