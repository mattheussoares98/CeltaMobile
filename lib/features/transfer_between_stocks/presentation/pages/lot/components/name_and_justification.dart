import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/transfer_between_stocks/domain/entities/entities.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';

class NameAndJustification extends StatelessWidget {
  final ProductLotInfoEntity item;
  const NameAndJustification({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleAndSubTitle(
          title: null,
          subTitle: "${item.product.Name} (${item.product.PLU})",
        ),
        TitleAndSubTitle(
          title: item.selectedJustification.Descricao_JustMov,
          titleStyle: context.theme.textTheme.titleMedium?.copyWith(
            color: context.theme.colorScheme.secondary,
          ),
          subTitle: ' (Justificativa)'.hardcoded,
          subTitleStyle: context.theme.textTheme.bodyMedium?.copyWith(),
        ),
      ],
    );
  }
}
