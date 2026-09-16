import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/transfer_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/transfer_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/transfer_request/presentation/pages/components/components.dart';
import 'package:celta_inventario/features/transfer_request/presentation/pages/products_management/cart/components/components.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProductItem extends HookConsumerWidget {
  final TransferRequestProductItemEntity item;
  final DraftKey draftKey;
  final bool requestTypeAllowChangePrice;
  final bool isSelected;
  final VoidCallback onSelectionChanged;
  final VoidCallback onUpdated;
  const ProductItem({
    super.key,
    required this.item,
    required this.draftKey,
    required this.requestTypeAllowChangePrice,
    required this.isSelected,
    required this.onSelectionChanged,
    required this.onUpdated,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quantityController = useTextEditingController();
    final quantityFocusNode = useFocusNode();
    final priceController = useTextEditingController();
    final priceFocusNode = useFocusNode();
    final formKey = useMemoized(GlobalKey<FormState>.new);
    void changeSelectedIndex() {
      onSelectionChanged();

      quantityController.text = item.quantity
          .toString()
          .toBrazilianNumber()
          .replaceAll(RegExp(r'\.'), '');

      priceController.text = item.value
          .toString()
          .toBrazilianNumber()
          .replaceAll(RegExp(r'\.'), '');
      Future.delayed(const Duration(milliseconds: 100), () {
        if (!context.mounted) return;
        quantityFocusNode.requestFocus();
        quantityController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: quantityController.text.length,
        );
      });
    }

    void update() {
      if (formKey.currentState?.validate() != true) return;

      ref
          .read(cartProductsStateControllerProvider(draftKey).notifier)
          .addItem(
            item.copyWith(
              quantity: quantityController.text.toDouble() ?? 0,
              value: requestTypeAllowChangePrice
                  ? priceController.text.toDouble() ?? 0
                  : null,
            ),
            CartAdditionStrategy.overwrite,
          );

      onUpdated();
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          InkWell(
            onTap: PlatformUtil.isCupertino ? null : changeSelectedIndex,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                Sizes.p8,
                Sizes.p8,
                0,
                Sizes.p8,
              ),
              child: Row(
                children: [
                  Expanded(child: ProductInformations(item: item)),
                  RemoveAndEditIcons(
                    draftKey: draftKey,
                    item: item,
                    changeSelectedIndex: changeSelectedIndex,
                  ),
                ],
              ),
            ),
          ),
          if (isSelected)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Sizes.p8,
                0,
                Sizes.p8,
                Sizes.p8,
              ),
              child: Form(
                key: formKey,
                child: UpdateItemWidget(
                  update: update,
                  draftKey: draftKey,
                  price: item.value,
                  requestTypeAllowChangePrice: requestTypeAllowChangePrice,
                  quantityController: quantityController,
                  priceController: priceController,
                  quantityFocusNode: quantityFocusNode,
                  priceFocusNode: priceFocusNode,
                  isCartPage: true,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
