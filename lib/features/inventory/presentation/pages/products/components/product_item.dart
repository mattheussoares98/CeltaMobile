import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../constants/constants.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../../utils/utils.dart';
import '../../../controllers/controllers.dart';
import '../products_page.dart';
import 'components.dart';

class ProductItem extends ConsumerWidget {
  final ProductsPage widget;
  final void Function(int? index) changeSelectedIndex;
  final int index;
  final ProductEntity product;
  final bool insertIndividually;
  final FocusNode quantityFocusNode;
  final TextEditingController quantityController;
  final GlobalKey<FormState> formKeyQuantity;
  const ProductItem({
    super.key,
    required this.widget,
    required this.changeSelectedIndex,
    required this.index,
    required this.product,
    required this.insertIndividually,
    required this.quantityFocusNode,
    required this.quantityController,
    required this.formKeyQuantity,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(
      selectedProductIndexStateControllerProvider(
        widget.codigoInternoInventario,
      ),
    );

    void entry(bool isSubtract, int codigoInternoProEmb) {
      if (formKeyQuantity.currentState?.validate() != true) {
        if (!quantityFocusNode.hasFocus) {
          quantityFocusNode.requestFocus();
        }
        return;
      }
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
                : quantityController.text.toDouble()!,
            isSubtract: isSubtract,
          );
    }

    return Card(
      margin: const EdgeInsets.only(top: Sizes.p8),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ProductInformations(
            onChangeSelectedIndex: () => changeSelectedIndex(index),
            product: product,
            isSelected: selectedIndex == index,
            codigoInternoInvCont: widget.codigoInternoInvCont,
          ),
          if (selectedIndex == index) ...[
            QuantityButtonsAndField(
              insertIndividually: insertIndividually,
              quantityFocusNode: quantityFocusNode,
              quantityController: quantityController,
              codigoInternoInvCont: widget.codigoInternoInvCont,
              codigoInternoProEmb: product.codigoInternoProEmb!,
              enterpriseCode: widget.enterpriseCode,
              codigoInternoInventario: widget.codigoInternoInventario,
              entryQuantity: (isSubtract) =>
                  entry(isSubtract, product.codigoInternoProEmb!),
              formKey: formKeyQuantity,
            ),
          ],
        ],
      ),
    );
  }
}
