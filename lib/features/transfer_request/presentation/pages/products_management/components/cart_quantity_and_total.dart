import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../domain/entities/entities.dart';

class CartQuantityAndTotal extends StatelessWidget {
  final TransferRequestProductItemEntity item;
  const CartQuantityAndTotal({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleAndSubTitle(
          title: 'Qtd no carrinho'.hardcoded,
          subTitle: '${item.quantity}'.toBrazilianNumber(),
          titleStyle: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.secondary,
          ),
          subTitleStyle: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.secondary,
          ),
        ),
        TitleAndSubTitle(
          title: 'Total'.hardcoded,
          subTitle: '${item.quantity * item.value}'
              .toBrazilianNumber()
              .addBrazilianCoin(),
          titleStyle: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.secondary,
          ),
          subTitleStyle: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.secondary,
          ),
        ),
      ],
    );
  }
}
