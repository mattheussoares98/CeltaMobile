import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../../core/presentation/controllers/products/products.dart';
import '../../../../../../utils/utils.dart';
import '../../../controllers/controllers.dart';
import 'components.dart';

class ProductsItems extends ConsumerStatefulWidget {
  final int codigoInternoInventario;
  final int codigoInternoInvCont;
  final int enterpriseCode;
  final SearchProductKey searchProductKey;
  final FocusNode quantityFocusNode;
  final TextEditingController quantityController;
  const ProductsItems({
    super.key,
    required this.codigoInternoInventario,
    required this.codigoInternoInvCont,
    required this.enterpriseCode,
    required this.searchProductKey,
    required this.quantityFocusNode,
    required this.quantityController,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductsItemsState();
}

class _ProductsItemsState extends ConsumerState<ProductsItems> {
  final formKeyQuantity = GlobalKey<FormState>();

  void entry(bool isSubtract, int codigoInternoProEmb) {
    if (formKeyQuantity.currentState?.validate() != true) {
      if (!widget.quantityFocusNode.hasFocus) {
        widget.quantityFocusNode.requestFocus();
      }
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();

    final insertIndividually = ref.read(
      uiStateControllerProvider(
        widget.codigoInternoInventario,
      ).select((s) => s.insertIndividually),
    );

    ref
        .read(
          entryQuantityStateControllerProvider(
            widget.codigoInternoInvCont,
          ).notifier,
        )
        .entry(
          codigoInternoInventario: widget.codigoInternoInventario,
          enterpriseCode: widget.enterpriseCode,
          codigoInternoProEmb: codigoInternoProEmb,
          quantity: insertIndividually
              ? 1
              : widget.quantityController.text.toDouble()!,
          isSubtract: isSubtract,
        );
  }

  void onChangeSelectedIndex(int index) {
    ref
        .read(
          uiStateControllerProvider(widget.codigoInternoInventario).notifier,
        )
        .updateProductIndex(index);

    widget.quantityController.clear();
    widget.quantityFocusNode.unfocus();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.quantityFocusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(
      uiStateControllerProvider(
        widget.codigoInternoInventario,
      ).select((s) => s.selectedProductIndex),
    );

    return AsyncValueWidget(
      isSliver: false,
      value: ref.watch(
        searchProductsStateControllerProvider(widget.searchProductKey),
      ),
      tryAgain: null,
      data: (products) {
        return ResponsiveListFlow(
          itemCount: products.length,
          itemBuilder: (_, index) {
            final product = products[index];

            final isSelected = selectedIndex == index;
            return _ProductItem(
              key: ValueKey(product.codigoInternoProEmb),
              product: product,
              formKeyQuantity: formKeyQuantity,
              isSelected: isSelected,
              onChangeSelectedIndex: () => onChangeSelectedIndex(index),
              codigoInternoInvCont: widget.codigoInternoInvCont,
              enterpriseCode: widget.enterpriseCode,
              codigoInternoInventario: widget.codigoInternoInventario,
              quantityFocusNode: widget.quantityFocusNode,
              quantityController: widget.quantityController,
              entryQuantity: (isSubtract) =>
                  entry(isSubtract, product.codigoInternoProEmb!),
            );
          },
        );
      },
    );
  }
}

class _ProductItem extends StatelessWidget {
  final ProductEntity product;
  final bool isSelected;
  final VoidCallback onChangeSelectedIndex;
  final int codigoInternoInvCont;
  final int enterpriseCode;
  final int codigoInternoInventario;
  final FocusNode quantityFocusNode;
  final TextEditingController quantityController;
  final void Function(bool isSubtract) entryQuantity;
  final GlobalKey<FormState> formKeyQuantity;
  const _ProductItem({
    super.key,
    required this.product,
    required this.isSelected,
    required this.onChangeSelectedIndex,
    required this.codigoInternoInvCont,
    required this.enterpriseCode,
    required this.codigoInternoInventario,
    required this.quantityFocusNode,
    required this.quantityController,
    required this.entryQuantity,
    required this.formKeyQuantity,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Card(
        margin: const EdgeInsets.only(top: Sizes.p8),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            ProductInformations(
              onChangeSelectedIndex: onChangeSelectedIndex,
              product: product,
              isSelected: isSelected,
              codigoInternoInvCont: codigoInternoInvCont,
            ),
            if (isSelected) ...[
              Form(
                key: formKeyQuantity,
                child: QuantityButtonsAndField(
                  quantityFocusNode: quantityFocusNode,
                  quantityController: quantityController,
                  codigoInternoInvCont: codigoInternoInvCont,
                  codigoInternoProEmb: product.codigoInternoProEmb!,
                  enterpriseCode: enterpriseCode,
                  codigoInternoInventario: codigoInternoInventario,
                  entryQuantity: entryQuantity,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
