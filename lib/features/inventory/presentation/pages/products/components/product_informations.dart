import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/string_modifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../controllers/controllers.dart';

class ProductInformations extends ConsumerWidget {
  final VoidCallback onChangeSelectedIndex;
  final ProductEntity product;
  final bool isSelected;
  final int codigoInternoInvCont;
  const ProductInformations({
    super.key,
    required this.onChangeSelectedIndex,
    required this.product,
    required this.isSelected,
    required this.codigoInternoInvCont,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onChangeSelectedIndex,
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleAndSubTitle(
              title: null,
              subTitle: product.Name?.formattedPacking(),
            ),

            Consumer(
              builder: (_, ref, _) {
                final lastChangedProduct = ref
                    .watch(
                      entryQuantityStateControllerProvider(
                        codigoInternoInvCont,
                      ),
                    )
                    .value;

                if (lastChangedProduct?.codigoInternoProEmb !=
                    product.codigoInternoProEmb) {
                  return const SizedBox.shrink();
                }
                return TitleAndSubTitle(
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
                );
              },
            ),
            Row(
              children: [
                Expanded(
                  child: TitleAndSubTitle(
                    title: product.quantidadeInvContProEmb == null
                        ? null
                        : 'Qtd contata'.hardcoded,
                    subTitleStyle: product.quantidadeInvContProEmb == null
                        ? const TextStyle(color: Colors.red)
                        : null,
                    subTitle: product.quantidadeInvContProEmb == null
                        ? 'Sem quantidade contada'.hardcoded
                        : product.quantidadeInvContProEmb ?? 0,
                  ),
                ),
                SelectedIconIndicator(
                  selected: isSelected,
                  onTap: onChangeSelectedIndex,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
