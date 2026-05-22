import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/products/products.dart';
import 'package:celta_inventario/core/presentation/controllers/stock/stock.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/features/adjust_stock/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/adjust_stock/presentation/pages/components/components.dart';

class ProductsItems extends ConsumerWidget {
  final FocusNode quantityFocusNode;
  final GlobalKey<FormState> formKey;
  final int enterpriseCode;
  final TextEditingController quantityController;
  const ProductsItems({
    super.key,
    required this.quantityFocusNode,
    required this.formKey,
    required this.enterpriseCode,
    required this.quantityController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> confirmAdjust(ProductEntity product) async {
      if (formKey.currentState?.validate() != true) {
        return;
      }
      final selectedUIState = ref.read(
        selectedUIStateControllerProvider(enterpriseCode),
      );

      if (selectedUIState.selectedJustification == null ||
          selectedUIState.selectedStockType == null) {
        //*if the user doesn't has permission to load justifications or stocks, the formKey will be valid.
        //*Because of this, should create this validation
        showAlertDialog(
          context: context,
          title: 'Atenção!'.hardcoded,
          content:
              'Você precisa selecionar a justificativa e o estoque!'.hardcoded,
        );
        return;
      }

      await ref.read(confirmAdjustStockControllerProvider.notifier).confirm([
        AdjustStockItemEntity(
          EnterpriseCode: enterpriseCode,
          ProductCode: product.ProductCode!,
          ProductPackingCode: product.ProductPackingCode!,
          JustificationCode:
              selectedUIState.selectedJustification!.CodigoInterno_JustMov,
          StockTypeCode:
              selectedUIState.selectedStockType!.CodigoInterno_TipoEstoque!,
          StockTypeRecipientCode: null,
          IsPendingAdjust: false,
          Quantity: quantityController.text.toDouble() ?? 0,
        ),
      ], operationType: selectedUIState.selectedJustification!.operationType);
    }

    return AsyncValueWidget(
      isSliver: true,
      value: ref.watch(
        searchProductsStateControllerProvider(
          SearchProductKey(
            enterpriseCode,
            BsRoutine.adjustStock,
            Modules.adjustStock,
          ),
        ),
      ),
      tryAgain: null,
      data: (products) {
        return ResponsiveListFlow(
          isSliver: true,
          itemCount: products.length,
          itemBuilder: (_, index) {
            final product = products[index];

            return _ProductItem(
              key: ValueKey('product_item_${product.ProductPackingCode}'),
              product: product,
              enterpriseCode: enterpriseCode,
              quantityFocusNode: quantityFocusNode,
              quantityController: quantityController,
              index: index,
              formKey: formKey,
              confirmAdjust: () => confirmAdjust(product),
            );
          },
        );
      },
    );
  }
}

class _ProductItem extends ConsumerWidget {
  final ProductEntity product;
  final int enterpriseCode;
  final FocusNode quantityFocusNode;
  final TextEditingController quantityController;
  final int index;
  final GlobalKey<FormState> formKey;
  final VoidCallback confirmAdjust;

  const _ProductItem({
    super.key,
    required this.product,
    required this.enterpriseCode,
    required this.quantityFocusNode,
    required this.quantityController,
    required this.index,
    required this.formKey,
    required this.confirmAdjust,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final isSelected = ref.watch(
      selectedUIStateControllerProvider(
        enterpriseCode,
      ).select((s) => s.selectedIndex == index),
    );

    final lastConfirmedAdjust = ref
        .watch(confirmAdjustStockControllerProvider)
        .value;

    return ProductItemWidget(
      product: product,
      routine: BsRoutine.adjustStock,
      onTap: () async {
        quantityController.clear();
        ref
            .read(selectedUIStateControllerProvider(enterpriseCode).notifier)
            .updateValues(selectedIndex: index);
        if (quantityFocusNode.hasFocus) {
          quantityFocusNode.unfocus();
        }
        WidgetsBinding.instance.addPostFrameCallback((_) {
          quantityFocusNode.requestFocus();
        });
      },
      showDropIcon: true,
      isSelected: isSelected,
      clickableBottom:
          lastConfirmedAdjust?.productPackingCode == product.ProductPackingCode
          ? TitleAndSubTitle(
              title:
                  'Última qtd alterada ${lastConfirmedAdjust!.operationType == OperationType.entrance ? "+" : "-"}'
                      .hardcoded,
              subTitle: lastConfirmedAdjust.quantity
                  .toString()
                  .toBrazilianNumber(3, true),
              titleStyle: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.secondary,
                fontStyle: FontStyle.italic,
              ),
              subTitleStyle: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.secondary,
                fontStyle: FontStyle.italic,
              ),
            )
          : null,
      notClickableBottom: isSelected
          ? ConfirmAdjustStock(
              onConfirm: confirmAdjust,
              quantityController: quantityController,
              quantityFocusNode: quantityFocusNode,
            )
          : null,
    );
  }
}
