import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
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
                title: 'Preço praticado ='.hardcoded,
                subTitle: practicedPriceType.name,
                subTitleStyle: theme.textTheme.titleMedium?.copyWith(
                  color: theme.primaryColor,
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
