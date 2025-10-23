import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../domain/entities/entities.dart';

class CostQuantityAndTotalWritten extends StatelessWidget {
  final BuyRequestProductItemEntity insertedItem;
  const CostQuantityAndTotalWritten({super.key, required this.insertedItem});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.secondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleAndSubTitle(
          title: 'Custo'.hardcoded,
          subTitleIsPrice: true,
          subTitle: insertedItem.cost.toString().toBrazilianNumber(4, true),
          titleStyle: theme.textTheme.titleSmall?.copyWith(color: color),
          subTitleStyle: theme.textTheme.titleSmall?.copyWith(color: color),
        ),
        TitleAndSubTitle(
          title: 'Quantidade'.hardcoded,
          subTitle: insertedItem.quantity.toString().toBrazilianNumber(4, true),
          titleStyle: theme.textTheme.titleSmall?.copyWith(color: color),
          subTitleStyle: theme.textTheme.titleSmall?.copyWith(color: color),
        ),
        TitleAndSubTitle(
          title: 'Total'.hardcoded,
          subTitleIsPrice: true,
          subTitle: (insertedItem.cost * insertedItem.quantity)
              .toString()
              .toBrazilianNumber(4, true),
          titleStyle: theme.textTheme.titleSmall?.copyWith(color: color),
          subTitleStyle: theme.textTheme.titleSmall?.copyWith(color: color),
        ),
      ],
    );
  }
}
