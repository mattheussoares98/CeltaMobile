import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../../core/presentation/controllers/products/products.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../../../../utils/utils.dart';
import '../../../controllers/controllers.dart';
import 'components.dart';

class ProductsItems extends ConsumerStatefulWidget {
  final SearchProductKey searchProductKey;
  final int receiptCode;
  const ProductsItems({
    super.key,
    required this.searchProductKey,
    required this.receiptCode,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductsItemsState();
}

class _ProductsItemsState extends ConsumerState<ProductsItems> {
  final quantityController = TextEditingController();
  final quantityFocusNode = FocusNode();

  @override
  void dispose() {
    quantityController.dispose();
    quantityFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(updateProductControllerProvider(widget.searchProductKey), (
      p,
      n,
    ) {
      n.showAlertDialogOnError(context);
      n.doOnSuccess(p, () {
        quantityController.clear();
      });
    });

    return AsyncValueWidget(
      value: ref.watch(
        searchProductsStateControllerProvider(widget.searchProductKey),
      ),
      tryAgain: null,
      data: (products) {
        return ResponsiveListFlow(
          itemCount: products.length,
          itemBuilder: (_, index) {
            final product = products[index];

            return _ProductItem(
              key: ValueKey(
                '${product.ProductPackingCode}${product.EnterpriseCode}',
              ),
              product: product,
              index: index,
              receiptCode: widget.receiptCode,
              quantityFocusNode: quantityFocusNode,
              quantityController: quantityController,
              searchProductKey: widget.searchProductKey,
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

          Future.delayed(const Duration(milliseconds: 300), () {
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
