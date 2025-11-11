import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../core/domain/entities/entities.dart';

enum _PriceType { retail, whole, manual }

class BsPricesAndMinimumWholeQuantity extends StatelessWidget {
  final ProductEntity product;
  final double? manualPrice;
  final double quantity;
  const BsPricesAndMinimumWholeQuantity({
    super.key,
    required this.product,
    required this.manualPrice,
    required this.quantity,
  });

  double get retailPrice => product.RetailPracticedPrice;
  double get minimumWholeQuantity => product.MinimumWholeQuantity;
  double get wholePrice => product.WholePracticedPrice;

  _PriceType get practicedPrice {
    if (manualPrice != null) {
      return _PriceType.manual;
    } else if (quantity >= minimumWholeQuantity) {
      return _PriceType.whole;
    }

    return _PriceType.retail;
  }

  double get getValueLiquid {
    switch (practicedPrice) {
      case _PriceType.retail:
        return retailPrice;
      case _PriceType.whole:
        return wholePrice;
      case _PriceType.manual:
        return manualPrice ?? 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: Sizes.p8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleAndSubTitle(
            title: 'Preço venda (BS)'.hardcoded,
            subTitle: retailPrice,
            subTitleIsPrice: true,
          ),
          if (minimumWholeQuantity > 0 && wholePrice > 0) ...[
            if (getValueLiquid != wholePrice)
              TitleAndSubTitle(
                title: 'Preço atacado (BS)'.hardcoded,
                subTitle: product.WholePracticedPrice,
                subTitleIsPrice: true,
              ),
            TitleAndSubTitle(
              title: 'Qtd mín atacado'.hardcoded,
              subTitle: product.MinimumWholeQuantity,
            ),
          ],
        ],
      ),
    );
  }
}
