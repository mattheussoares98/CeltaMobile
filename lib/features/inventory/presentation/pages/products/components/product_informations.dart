import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/string_modifier.dart';
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../domain/entities/entities.dart';

class ProductInformations extends StatelessWidget {
  final VoidCallback onChangeSelectedIndex;
  final InventoryProductEntity product;
  final bool isSelected;
  final AsyncValue<LastChangedProductEntity?> entryQuantityAsync;
  const ProductInformations({
    super.key,
    required this.onChangeSelectedIndex,
    required this.product,
    required this.isSelected,
    required this.entryQuantityAsync,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lastChangedProduct = entryQuantityAsync.value;

    return InkWell(
      onTap: onChangeSelectedIndex,
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleAndSubTitle(title: null, subTitle: product.productName),
            if (lastChangedProduct?.codigoInternoProEmb ==
                product.codigoInternoProEmb)
              TitleAndSubTitle(
                title:
                    'Última quantidade alterada ${lastChangedProduct?.isSubtract == true ? " -" : ""}'
                        .hardcoded,
                subTitle: lastChangedProduct?.quantity
                    .toString()
                    .toBrazilianNumber(3),
                titleStyle: theme.textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w300,
                  color: theme.primaryColor,
                ),
                subTitleStyle: theme.textTheme.titleMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: theme.primaryColor,
                ),
              ),
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
