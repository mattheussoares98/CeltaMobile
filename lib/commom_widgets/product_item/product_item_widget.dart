import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../../core/data/datasource/datasource.dart';
import '../../core/domain/entities/entities.dart';
import '../commom_widgets.dart';
import 'product_item.dart';

class ProductItemWidget extends StatelessWidget {
  final int enterpriseCode;
  final ProductEntity product;
  final Routine routine;
  const ProductItemWidget({
    super.key,
    required this.enterpriseCode,
    required this.product,
    required this.routine,
  });

  double _getStockQuantityByName(List<StockEntity>? stocks, String name) {
    if (stocks == null || stocks.isEmpty) {
      return 0;
    }

    final currentStockIndex = stocks.indexWhere(
      (e) =>
          e.EnterpriseCode == enterpriseCode &&
          e.StockName.toLowerCase() == name.toLowerCase(),
    );

    if (currentStockIndex == -1) {
      return 0;
    } else {
      return stocks[currentStockIndex].StockQuantity;
    }
  }

  String _formatPacking(String value) {
    final firstDigitMatch = RegExp(r'\d').firstMatch(value);

    if (firstDigitMatch == null) {
      return value;
    }

    final index = firstDigitMatch.start;
    final textPart = value.substring(0, index);
    var numberPart = value.substring(index);

    if (numberPart.contains('.')) {
      while (numberPart.endsWith('0')) {
        numberPart = numberPart.substring(0, numberPart.length - 1);
      }

      if (numberPart.endsWith('.')) {
        numberPart = numberPart.substring(0, numberPart.length - 1);
      }
    }

    return '$textPart$numberPart'.replaceAll(RegExp(r'\.'), ',');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    final currentStockQuantity = _getStockQuantityByName(
      product.Stocks,
      'Estoque Atual'.hardcoded,
    );

    return Card(
      margin: EdgeInsets.only(bottom: Sizes.p8),
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleAndSubTitle(
              title: product.Name,
              subTitle: " (${_formatPacking(product.PackingQuantity)})",
              titleStyle: theme.textTheme.titleMedium,
              subTitleStyle: theme.textTheme.bodyMedium,
            ),
            Row(
              children: [
                Expanded(
                  child: TitleAndSubTitle(title: "PLU ", subTitle: product.PLU),
                ),
                InkWell(
                  onTap: () {
                    showModalPage(ProductInfo(product: product), context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      // vertical: Sizes.p4,
                      horizontal: Sizes.p8,
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Info'.hardcoded,
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: theme.primaryColor,
                          ),
                        ),
                        gapW8,
                        if (mediaQuery.size.width >= 200)
                          Icon(
                            defaultTargetPlatform == TargetPlatform.iOS
                                ? Icons.info
                                : Icons.info,
                            color: theme.primaryColor,
                            size: 16,
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            TitleAndSubTitle(
              title: "Preço ",
              emptyMessage: 'Sem preço'.hardcoded,
              subTitle: product.RetailSalePrice,
              subTitleIsPrice: true,
            ),
            TitleAndSubTitle(
              title: "Custo líquido ",
              subTitle: product.LiquidCost,
              emptyMessage: 'Sem custo líquido'.hardcoded,
              subTitleIsPrice: true,
            ),
            if (routine != Routine.adjustSalePrice) ...[
              TitleAndSubTitle(
                title: "Estoque atual ",
                emptyMessage: currentStockQuantity == -1
                    ? 'Sem permissão p/ ver estoque'.hardcoded
                    : 'Sem estoque atual'.hardcoded,
                //TODO test if return -1, must show that the user doesnt has permission to read this information
                subTitle: currentStockQuantity,
              ),
              TitleAndSubTitle(
                title: "Saldo ",
                emptyMessage: 'Sem saldo'.hardcoded,
                subTitle: _getStockQuantityByName(
                  product.Stocks,
                  'saldo'.hardcoded,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
