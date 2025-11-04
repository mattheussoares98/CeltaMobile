import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../domain/entities/entities.dart';

class Values extends StatelessWidget {
  final CartProductEntity product;
  final bool isSelected;
  const Values({super.key, required this.product, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _ColumnValues(
              title: 'Qtd'.hardcoded,
              value: product.Quantity,
              valueIsPrice: false,
            ),
            _ColumnValues(
              title: 'Preço'.hardcoded,
              value: product.Value,
              valueIsPrice: true,
            ),
            if ((product.DiscountValue ?? 0) > 0)
              _ColumnValues(
                title: 'Desconto'.hardcoded,
                value: product.DiscountValue!,
                valueIsPrice: true,
              ),
            _ColumnValues(
              title: 'Total'.hardcoded,
              value: product.getTotalLiquid,
              valueIsPrice: true,
            ),
            SelectedIconIndicator(selected: isSelected),
          ],
        ),
      ],
    );
  }
}

class _ColumnValues extends StatelessWidget {
  final String title;
  final double value;
  final bool valueIsPrice;
  const _ColumnValues({
    required this.title,
    required this.value,
    required this.valueIsPrice,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Flexible(
      child: Column(
        children: [
          Text(
            title.hardcoded,
            style: theme.textTheme.titleSmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          TitleAndSubTitle(
            title: null,
            subTitle: value.toString().toBrazilianNumber(
              valueIsPrice ? 2 : 3,
              !valueIsPrice,
            ),
            subTitleStyle: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey,
            ),
            subTitleIsPrice: valueIsPrice,
          ),
        ],
      ),
    );
  }
}
