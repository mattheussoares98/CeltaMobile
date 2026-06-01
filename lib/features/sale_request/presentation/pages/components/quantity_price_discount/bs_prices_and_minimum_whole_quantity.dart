import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/presentation/pages/components/quantity_price_discount/quantity_price_discount.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';

class BsPricesAndMinimumWholeQuantity extends StatelessWidget {
  final QuantityPriceDiscountFieldsAndInsertButton widget;
  const BsPricesAndMinimumWholeQuantity({super.key, required this.widget});

  double get retailPrice => widget.product.RetailPracticedPrice!;
  double get minimumWholeQuantity => widget.product.MinimumWholeQuantity!;
  double get wholePrice => widget.product.WholePracticedPrice!;

  @override
  Widget build(BuildContext context) {
    final titleStyle = context.theme.textTheme.bodyMedium?.copyWith(
      color: context.theme.primaryColor,
    );
    final subtitleSelected = context.theme.textTheme.titleMedium?.copyWith(
      color: context.theme.primaryColor,
    );
    final subtitleNotSelected = context.theme.textTheme.titleMedium?.copyWith(
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
            : context.theme.colorScheme.secondary,
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
                removeColon: true,
                subTitle: practicedPriceType.description,
                subTitleStyle: context.theme.textTheme.titleMedium?.copyWith(
                  color: practicedPriceType == PracticedPriceType.manual
                      ? Colors.red
                      : context.theme.primaryColor,
                  fontStyle: FontStyle.italic,
                ),
                titleStyle: context.theme.textTheme.bodyMedium?.copyWith(
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
