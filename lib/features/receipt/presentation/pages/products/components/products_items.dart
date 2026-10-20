import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/products/products.dart';
import 'package:celta_inventario/features/receipt/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/receipt/presentation/pages/products/components/components.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductsItems extends ConsumerWidget {
  final SearchProductKey searchProductKey;
  final int receiptCode;
  final TextEditingController quantityController;
  final FocusNode quantityFocusNode;
  const ProductsItems({
    super.key,
    required this.searchProductKey,
    required this.receiptCode,
    required this.quantityController,
    required this.quantityFocusNode,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncValueWidget(
      isSliver: true,
      value: ref.watch(searchProductsStateControllerProvider(searchProductKey)),
      tryAgain: null,
      data: (products) {
        return ResponsiveListFlow(
          isSliver: true,
          itemCount: products.length,
          itemBuilder: (_, index) {
            final product = products[index];

            return _ProductItem(
              key: ValueKey(
                '${product.ProductPackingCode}${product.EnterpriseCode}',
              ),
              product: product,
              index: index,
              receiptCode: receiptCode,
              quantityFocusNode: quantityFocusNode,
              quantityController: quantityController,
              searchProductKey: searchProductKey,
            );
          },
        );
      },
    );
  }
}

class _ProductItem extends ConsumerWidget {
  final ProductEntity product;
  final int index;
  final int receiptCode;
  final FocusNode quantityFocusNode;
  final TextEditingController quantityController;
  final SearchProductKey searchProductKey;
  const _ProductItem({
    super.key,
    required this.product,
    required this.index,
    required this.receiptCode,
    required this.quantityFocusNode,
    required this.quantityController,
    required this.searchProductKey,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected = ref.watch(
      selectedProductIndeStateControllerProvider(
        receiptCode,
      ).select((s) => s == index),
    );

    return RepaintBoundary(
      child: ProductItemWidget(
        product: product,
        routine: BsRoutine.goodsReceiving,
        showEditIcon: true,
        isSelected: isSelected,
        onTap: () {
          quantityController.clear();

          ref
              .read(
                selectedProductIndeStateControllerProvider(
                  receiptCode,
                ).notifier,
              )
              .updateIndex(index);

          quantityFocusNode.unfocus();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            quantityFocusNode.requestFocus();
          });
        },
        notClickableBottom: isSelected
            ? UpdateValuesWidgets(
                product: product,
                quantityFocusNode: quantityFocusNode,
                quantityController: quantityController,
                receiptCode: receiptCode,
                searchProductKey: searchProductKey,
                productIndex: index,
              )
            : null,
        clickableBottom: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleAndSubTitle(
              title: context.l10n.expiration,
              subTitle: product.DataValidade_ProcRecebDocProEmb?.formatDate(),
              emptyMessage: context.l10n.noExpirationDate,
            ),
            TitleAndSubTitle(
              title: context.l10n.countedQuantity,
              titleStyle: context.theme.textTheme.bodyMedium?.copyWith(
                color: context.theme.colorScheme.secondary,
                fontStyle: FontStyle.italic,
              ),
              subTitleStyle: context.theme.textTheme.titleMedium?.copyWith(
                color: context.theme.colorScheme.secondary,
                fontStyle: FontStyle.italic,
              ),
              subTitle: product.Quantidade_ProcRecebDocProEmb,
              emptyMessage: context.l10n.noCountedQuantity,
            ),
          ],
        ),
      ),
    );
  }
}
