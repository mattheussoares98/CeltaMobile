import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../../core/presentation/controllers/products/products.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../controllers/controllers.dart';
import 'components.dart';

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
      selectedProductIndeStateControllerProvider.select((s) => s == index),
    );

    return RepaintBoundary(
      child: ProductItemWidget(
        product: product,
        routine: BsRoutine.goodsReceiving,
        showDropIcon: true,
        isSelected: isSelected,
        onTap: () {
          quantityController.clear();

          ref
              .read(selectedProductIndeStateControllerProvider.notifier)
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
              )
            : null,
        clickableBottom: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleAndSubTitle(
              title: 'Validade'.hardcoded,
              subTitle: product.DataValidade_ProcRecebDocProEmb == null
                  ? null
                  : DateFormat(
                      'dd/MM/yyyy',
                    ).format(product.DataValidade_ProcRecebDocProEmb!),
              emptyMessage: 'Sem validade'.hardcoded,
            ),
            TitleAndSubTitle(
              title: 'Quantidade contada'.hardcoded,
              subTitle: product.Quantidade_ProcRecebDocProEmb,
              emptyMessage: 'Sem quantidade contada'.hardcoded,
            ),
          ],
        ),
      ),
    );
  }
}
