import 'package:flutter/material.dart';

import '../../../core/domain/entities/entities.dart';
import '../../../localization/string_hardcoded.dart';
import '../../commom_widgets.dart';

class CurrentAndSaleStocks extends StatelessWidget {
  final ProductItemWidget widget;
  const CurrentAndSaleStocks(this.widget, {super.key});

  @override
  Widget build(BuildContext context) {
    final currentStockQuantity = _getStockQuantityByName(
      widget.product.Stocks,
      'Estoque Atual'.hardcoded,
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
          title: "Estoque atual ",
          emptyMessage: currentStockQuantity == -1
              ? 'Sem permissão p/ ver estoque'.hardcoded
              : 'Sem estoque atual'.hardcoded,
          subTitle: currentStockQuantity,
        ),
        TitleAndSubTitle(
          title: "Saldo de venda",
          emptyMessage: 'Sem saldo de venda'.hardcoded,
          subTitle: _getStockQuantityByName(
            widget.product.Stocks,
            'saldo'.hardcoded,
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

  final currentStockIndex = stocks.indexWhere(
    (e) =>
        e.EnterpriseCode == enterpriseCode &&
        e.StockName.toLowerCase().contains(name.toLowerCase()),
  );

  if (currentStockIndex == -1) {
    return 0;
  } else {
    return stocks[currentStockIndex].StockQuantity;
  }
}
