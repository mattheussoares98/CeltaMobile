import 'package:flutter/material.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../../domain/entities/entities.dart';

class NameAndJustification extends StatelessWidget {
  final ProductLotInfoEntity item;
  const NameAndJustification({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TitleAndSubTitle(
          title: null,
          subTitle: "${item.product.Name} (${item.product.PLU})",
        ),
        TitleAndSubTitle(
          title: 'Just '.hardcoded,
          subTitle: item.selectedJustification.Descricao_JustMov,
        ),
      ],
    );
  }
}
