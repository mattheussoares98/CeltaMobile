import 'package:flutter/material.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/features/transfer_between_stocks/domain/entities/entities.dart';

class OriginAndDestinyWithQuantities extends StatelessWidget {
  final ProductLotInfoEntity item;
  const OriginAndDestinyWithQuantities({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultTextStyle = theme.textTheme.titleMedium;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleAndSubTitle(
          title: item.selectedOriginStock.Nome_TipoEstoque,
          titleStyle: defaultTextStyle?.copyWith(color: Colors.red),
          subTitle:
              ' (-${item.quantity.toString().toBrazilianNumber(3, true)})',
          subTitleStyle: defaultTextStyle?.copyWith(color: Colors.red),
        ),
        TitleAndSubTitle(
          title: item.selectedDestinyStock.Nome_TipoEstoque,
          titleStyle: defaultTextStyle?.copyWith(color: Colors.green),
          subTitle:
              ' (+${item.quantity.toString().toBrazilianNumber(3, true)})',
          subTitleStyle: defaultTextStyle?.copyWith(color: Colors.green),
        ),
      ],
    );
  }
}
