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

  double get retailPrice => widget.product.RetailPracticedPrice!;
  double get minimumWholeQuantity => widget.product.MinimumWholeQuantity!;
  double get wholePrice => widget.product.WholePracticedPrice!;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final titleStyle = theme.textTheme.bodyMedium?.copyWith(
      color: theme.primaryColor,
    );
    final subtitleSelected = theme.textTheme.titleMedium?.copyWith(
      color: theme.primaryColor,
    );
    final subtitleNotSelected = theme.textTheme.titleMedium?.copyWith(
      color: Colors.black,
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
              if (widget.isCartPage) ...[
                TitleAndSubTitle(
                  title: 'Preço varejo'.hardcoded,
                  subTitle: widget.product.getPrice
                      .toString()
                      .toBrazilianNumber(2),
                  subTitleIsPrice: true,
                  titleStyle: practicedPriceType == PracticedPriceType.retail
                      ? titleStyle
                      : null,
                  subTitleStyle: practicedPriceType == PracticedPriceType.retail
                      ? subtitleSelected
                      : subtitleNotSelected,
                ),
                if (widget.product.WholePracticedPrice! > 0) ...[
                  TitleAndSubTitle(
                    title: 'Preço atacado'.hardcoded,
                    subTitle: widget.product.WholePracticedPrice
                        .toString()
                        .toBrazilianNumber(2),
                    subTitleIsPrice: true,
                    titleStyle: practicedPriceType == PracticedPriceType.whole
                        ? titleStyle
                        : null,
                    subTitleStyle:
                        practicedPriceType == PracticedPriceType.whole
                        ? subtitleSelected
                        : subtitleNotSelected,
                  ),
                  TitleAndSubTitle(
                    title: 'Qtd mín atacado'.hardcoded,
                    subTitle: widget.product.MinimumWholeQuantity
                        .toString()
                        .toBrazilianNumber(2),
                    emptyMessage:
                        'Não foi definido qtd mín p/ atacado'.hardcoded,
                    titleStyle: practicedPriceType == PracticedPriceType.whole
                        ? titleStyle
                        : null,
                    subTitleStyle:
                        practicedPriceType == PracticedPriceType.whole
                        ? subtitleSelected
                        : subtitleNotSelected,
                  ),
                ],
              ],
              TitleAndSubTitle(
                title: 'Preço praticado ='.hardcoded,
                subTitle: practicedPriceType.name,
                subTitleStyle: theme.textTheme.titleMedium?.copyWith(
                  color: practicedPriceType == PracticedPriceType.notDefined
                      ? Colors.red
                      : theme.primaryColor,
                  fontStyle: FontStyle.italic,
                ),
                titleStyle: theme.textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
