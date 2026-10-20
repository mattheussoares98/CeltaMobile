import 'package:celta_inventario/utils/utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';

class CurrentAndSaleStocks extends StatelessWidget {
  final ProductItemWidget widget;
  const CurrentAndSaleStocks(this.widget, {super.key});

  @override
  Widget build(BuildContext context) {
    final currentStockQuantity = _getStockQuantityByName(
      widget.product.Stocks,
      context.l10n.currentStock,
      widget.product.EnterpriseCode,
    );

    if (widget.hideCurrentAndSaleStocks == true) {
      return const SizedBox.shrink();
    } else if ([
      BsRoutine
          .adjustSalePrice, //! is not returning this property on this routine
      BsRoutine.buyQuotation,
      BsRoutine.goodsReceiving,
      BsRoutine.researchOfPrice,
    ].contains(widget.routine)) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleAndSubTitle(
          title: context.l10n.currentStockPrefix,
          emptyMessage: currentStockQuantity == -1
              ? context.l10n.noPermissionToViewStock
              : context.l10n.noCurrentStock,
          subTitle: currentStockQuantity,
        ),
        TitleAndSubTitle(
          title: context.l10n.availableForSale,
          emptyMessage: context.l10n.noAvailableQuantityForSale,
          subTitle: _getStockQuantityByName(
            widget.product.Stocks,
            context.l10n.balance,
            widget.product.EnterpriseCode,
          ),
        ),
      ],
    );
  }
}

double _getStockQuantityByName(
  List<StockEntity>? stocks,
  String name,
  int? enterpriseCode,
) {
  if (stocks == null || stocks.isEmpty) {
    return 0;
  }

  return stocks
          .firstWhereOrNull(
            (e) =>
                e.EnterpriseCode == enterpriseCode &&
                e.StockName.toLowerCase().contains(name.toLowerCase()),
          )
          ?.StockQuantity ??
      0;
}
