import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../core/domain/entities/entities.dart';
import 'quantity_price_discount.dart';

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

    TextStyle getMinWholeStyle(PracticedPriceType practicedPriceType) {
      final style = practicedPriceType == PracticedPriceType.whole
          ? subtitleSelected
          : subtitleNotSelected;

      return style!.copyWith(
        color: (widget.product.MinimumWholeQuantity ?? 0) == 0
            ? Colors.red
            : practicedPriceType == PracticedPriceType.whole
            ? Colors.green
            : theme.colorScheme.secondary,
      );
    }

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

        final minWholeStyle = getMinWholeStyle(practicedPriceType);

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
                  Row(
                    children: [
                      Flexible(
                        child: TitleAndSubTitle(
                          title: 'Preço atacado',
                          subTitle: widget.product.WholePracticedPrice,
                          subTitleIsPrice: true,
                          titleStyle:
                              practicedPriceType == PracticedPriceType.whole
                              ? titleStyle
                              : null,
                          subTitleStyle:
                              practicedPriceType == PracticedPriceType.whole
                              ? subtitleSelected
                              : subtitleNotSelected,
                        ),
                      ),
                      TitleAndSubTitle(
                        title: ' (mín'.hardcoded,
                        subTitle:
                            '${(widget.product.MinimumWholeQuantity ?? 0).toString().toBrazilianNumber(2, true)})',
                        titleStyle: minWholeStyle,
                        subTitleStyle: minWholeStyle,
                      ),
                    ],
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
