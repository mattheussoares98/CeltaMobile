import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';

class WholePriceAndMinQuantity extends StatelessWidget {
  final ProductItemWidget widget;
  const WholePriceAndMinQuantity(this.widget, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: TitleAndSubTitle(
                title: context.l10n.wholesalePriceLabel,
                subTitle: widget.product.WholePracticedPrice,
                subTitleIsPrice: true,
              ),
            ),
            TitleAndSubTitle(
              title: context.l10n.min,
              subTitle:
                  '${(widget.product.MinimumWholeQuantity ?? 0).toString().toBrazilianNumber(2, true)})',
              subTitleStyle: context.theme.textTheme.titleSmall?.copyWith(
                color: (widget.product.MinimumWholeQuantity ?? 0) == 0
                    ? Colors.red
                    : context.theme.colorScheme.secondary,
                fontStyle: FontStyle.italic,
              ),
              titleStyle: context.theme.textTheme.titleSmall?.copyWith(
                color: (widget.product.MinimumWholeQuantity ?? 0) == 0
                    ? Colors.red
                    : context.theme.colorScheme.secondary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
