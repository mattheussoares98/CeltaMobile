import 'package:celta_inventario/features/transfer_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../constants/constants.dart';
import '../../../../../domain/entities/entities.dart';
import '../../../components/components.dart';
import 'components.dart';

class ProductItem extends ConsumerStatefulWidget {
  final TransferRequestProductItemEntity item;
  final int index;
  final DraftKey draftKey;
  const ProductItem({
    super.key,
    required this.item,
    required this.index,
    required this.draftKey,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductItemState();
}

class _ProductItemState extends ConsumerState<ProductItem> {
  final quantityController = TextEditingController();
  final quantityFocusNode = FocusNode();
  final priceController = TextEditingController();
  final priceFocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    quantityController.dispose();
    quantityFocusNode.dispose();
    priceController.dispose();
    priceFocusNode.dispose();
  }

  void changeSelectedIndex() {
    ref
        .read(
          uiStateControllerProvider(widget.draftKey.requestTypeCode).notifier,
        )
        .updateSelectedCartProductIndex(widget.index);

    quantityController.text = widget.item.quantity
        .toString()
        .toBrazilianNumber()
        .replaceAll(RegExp(r'\.'), '');

    priceController.text = widget.item.value
        .toString()
        .toBrazilianNumber()
        .replaceAll(RegExp(r'\.'), '');
    Future.delayed(const Duration(milliseconds: 100), () {
      quantityFocusNode.requestFocus();
      quantityController.selection = TextSelection(
        baseOffset: 0,
        extentOffset: quantityController.text.length,
      );
    });
  }

  void update() async {
    if (formKey.currentState?.validate() != true) {
      return;
    }

    final uiState = await ref.read(
      uiStateControllerProvider(widget.draftKey.requestTypeCode).future,
    );

    ref
        .read(cartProductsStateControllerProvider(widget.draftKey).notifier)
        .addItem(
          widget.item.copyWith(
            quantity: quantityController.text.toDouble() ?? 0,
            value: uiState.requestTypeAllowChangePrice
                ? priceController.text.toDouble() ?? 0
                : null,
          ),
        );

    ref
        .read(
          uiStateControllerProvider(widget.draftKey.requestTypeCode).notifier,
        )
        .updateSelectedCartProductIndex(null);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;
    return RepaintBoundary(
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            InkWell(
              onTap: isIOS ? null : changeSelectedIndex,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  Sizes.p8,
                  Sizes.p8,
                  0,
                  Sizes.p8,
                ),
                child: Row(
                  children: [
                    Expanded(child: ProductInformations(item: widget.item)),
                    RemoveAndEditIcons(
                      draftKey: widget.draftKey,
                      item: widget.item,
                      changeSelectedIndex: changeSelectedIndex,
                    ),
                  ],
                ),
              ),
            ),
            Consumer(
              builder: (_, ref, _) {
                final bool isSelected =
                    ref.watch(
                      uiStateControllerProvider(
                        widget.draftKey.requestTypeCode,
                      ).select((s) => s.value?.selectedCartProductIndex),
                    ) ==
                    widget.index;

                if (!isSelected) {
                  return const SizedBox.shrink();
                }

                return Padding(
                  padding: const EdgeInsets.fromLTRB(
                    Sizes.p8,
                    0,
                    Sizes.p8,
                    Sizes.p8,
                  ),
                  child: Form(
                    key: formKey,
                    child: UpdateItemWidget(
                      isAlreadyInCart: true,
                      update: update,
                      draftKey: widget.draftKey,
                      price: widget.item.value,
                      quantityController: quantityController,
                      priceController: priceController,
                      quantityFocusNode: quantityFocusNode,
                      priceFocusNode: priceFocusNode,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
