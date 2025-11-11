import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../core/domain/entities/entities.dart';
import 'components.dart';

class BsPricesAndMinimumWholeQuantity extends StatelessWidget {
  final QuantityPriceDiscountFieldsAndInsertButton widget;
  const BsPricesAndMinimumWholeQuantity({super.key, required this.widget});

  double get retailPrice => widget.product.RetailPracticedPrice;
  double get minimumWholeQuantity => widget.product.MinimumWholeQuantity;
  double get wholePrice => widget.product.WholePracticedPrice;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final titleStyle = theme.textTheme.bodyMedium?.copyWith(
      color: theme.primaryColor,
    );
    final subTitle = theme.textTheme.titleMedium?.copyWith(
      color: theme.primaryColor,
    );

    return AnimatedBuilder(
      animation: Listenable.merge([
        widget.priceController,
        widget.quantityController,
      ]),
      builder: (_, _) {
        final practicedPriceType = widget.product.getPracticedPriceType(
          manualPrice: widget.priceController.text.toDouble(),
          quantity: widget.quantityController.text.toDouble() ?? 0,
        );

        return Padding(
          padding: const EdgeInsets.only(left: Sizes.p8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleAndSubTitle(
                title: 'Preço venda (BS)'.hardcoded,
                emptyMessage: 'Sem preço de venda (BS)',
                subTitle: retailPrice.toString().toBrazilianNumber(2),
                subTitleIsPrice: true,
                titleStyle: practicedPriceType == PracticedPriceType.retail
                    ? titleStyle
                    : null,
                subTitleStyle: practicedPriceType == PracticedPriceType.retail
                    ? subTitle
                    : null,
              ),
              if (minimumWholeQuantity > 0 && wholePrice > 0) ...[
                // if (getValueLiquid != wholePrice)
                TitleAndSubTitle(
                  title: 'Preço atacado (BS)'.hardcoded,
                  emptyMessage: 'Sem preço de atacado (BS)',
                  subTitle: widget.product.WholePracticedPrice
                      .toString()
                      .toBrazilianNumber(2),
                  subTitleIsPrice: true,
                  titleStyle: practicedPriceType == PracticedPriceType.whole
                      ? titleStyle
                      : null,
                  subTitleStyle: practicedPriceType == PracticedPriceType.whole
                      ? subTitle
                      : null,
                ),
                TitleAndSubTitle(
                  title: 'Qtd mín atacado'.hardcoded,
                  subTitle: widget.product.MinimumWholeQuantity
                      .toString()
                      .toBrazilianNumber(3, true),
                  titleStyle: practicedPriceType == PracticedPriceType.whole
                      ? titleStyle
                      : null,
                  subTitleStyle: practicedPriceType == PracticedPriceType.whole
                      ? subTitle
                      : null,
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
