import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../domain/entities/entities.dart';

class ProductInformations extends StatelessWidget {
  final VoidCallback onChangeSelectedIndex;
  final InventoryProductEntity product;
  final bool isSelected;
  const ProductInformations({
    super.key,
    required this.onChangeSelectedIndex,
    required this.product,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onChangeSelectedIndex,
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleAndSubTitle(title: null, subTitle: product.productName),
            Row(
              children: [
                Expanded(
                  child: TitleAndSubTitle(
                    title: product.quantidadeInvContProEmb == null
                        ? null
                        : 'Qtd contata'.hardcoded,
                    subTitleStyle: product.quantidadeInvContProEmb == null
                        ? TextStyle(color: Colors.red)
                        : null,
                    subTitle: product.quantidadeInvContProEmb == null
                        ? 'Sem quantidade contada'.hardcoded
                        : product.quantidadeInvContProEmb ?? 0,
                  ),
                ),
                SelectedIconIndicator(selected: isSelected),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
