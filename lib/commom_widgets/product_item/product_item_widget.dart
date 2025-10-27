import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/constants.dart';
import '../../core/domain/entities/entities.dart';
import '../../features/adjust_sale_price/presentation/controllers/controllers.dart';
import '../commom_widgets.dart';

class ProductItemWidget extends ConsumerWidget {
  final ProductEntity product;
  final BsRoutine routine;
  final Widget? notClickableBottom;
  final Widget? clickableBottom;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final bool? showDropIcon;
  final bool? isSelected;
  final Widget? itemBeforeProductName;
  const ProductItemWidget({
    super.key,
    required this.product,
    required this.routine,
    this.onTap,
    this.onDelete,
    this.notClickableBottom,
    this.clickableBottom,
    this.showDropIcon,
    this.isSelected,
    this.itemBeforeProductName,
  });

  double _getStockQuantityByName(List<StockEntity>? stocks, String name) {
    if (stocks == null || stocks.isEmpty) {
      return 0;
    }

    final currentStockIndex = stocks.indexWhere(
      (e) =>
          e.EnterpriseCode == product.EnterpriseCode &&
          e.StockName.toLowerCase().contains(name.toLowerCase()),
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
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(finishOfferControllerProvider, (p, n) {
      n.showAlertDialogOnError(context);
      n.showAlertDialogOnSuccess(
        context,
        previous: p,
        title: 'Oferta encerrada'.hardcoded,
        message:
            'Oferta encerrada com sucesso. Consulte o produto novamente para atualizar as informações'
                .hardcoded,
      );
    });

    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    final currentStockQuantity = _getStockQuantityByName(
      product.Stocks,
      'Estoque Atual'.hardcoded,
    );

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.only(bottom: Sizes.p8),
      child: Column(
        children: [
          Stack(
            children: [
              InkWell(
                onTap: onTap,
                child: Padding(
                  padding: const EdgeInsets.all(Sizes.p8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ?itemBeforeProductName,
                      TitleAndSubTitle(
                        title: product.Name,
                        subTitle:
                            " (${_formatPacking(product.PackingQuantity)})",
                        titleStyle: theme.textTheme.titleMedium,
                        subTitleStyle: theme.textTheme.bodyMedium,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TitleAndSubTitle(
                              title: "PLU ",
                              subTitle: product.PLU,
                            ),
                          ),
                          InfoButton(
                            product: product,
                            enterpriseCode: product.EnterpriseCode,
                            routine: routine,
                          ),
                        ],
                      ),
                      if (routine != BsRoutine.adjustStock) ...[
                        if (routine != BsRoutine.buyRequest) ...[
                          TitleAndSubTitle(
                            title: "Preço ",
                            emptyMessage: 'Sem preço'.hardcoded,
                            subTitle: routine == BsRoutine.transferRequest
                                ? product.Value
                                : (product.Value > 0
                                      ? product.Value
                                      : product.RetailPracticedPrice),
                            subTitleIsPrice: true,
                          ),
                        ],
                        if (routine != BsRoutine.transferRequest) ...[
                          TitleAndSubTitle(
                            title: "Custo líquido ",
                            subTitle: product.LiquidCost,
                            emptyMessage: 'Sem custo líquido'.hardcoded,
                            subTitleIsPrice: true,
                          ),
                        ],
                      ],
                      if (routine != BsRoutine.adjustSalePrice) ...[
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
                            product.Stocks,
                            'saldo'.hardcoded,
                          ),
                        ),
                      ],
                      ?clickableBottom,
                    ],
                  ),
                ),
              ),
              Positioned(
                right: Sizes.p8,
                bottom: Sizes.p8,
                child: Row(
                  children: [
                    if (onDelete != null)
                      IconButton(
                        onPressed: onDelete == null
                            ? null
                            : () {
                                showAlertDialog(
                                  context: context,
                                  title: 'Remover item?'.hardcoded,
                                  onOkPressed: onDelete,
                                  cancelActionText: 'Cancelar'.hardcoded,
                                  defaultActionText: 'Remover'.hardcoded,
                                );
                              },
                        icon: Icon(
                          isIOS ? CupertinoIcons.delete : Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    if (showDropIcon == true)
                      SelectedIconIndicator(selected: isSelected ?? false),
                  ],
                ),
              ),
            ],
          ),
          if (notClickableBottom != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Sizes.p8,
                0,
                Sizes.p8,
                Sizes.p8,
              ),
              child: notClickableBottom,
            ),
        ],
      ),
    );
  }
}
