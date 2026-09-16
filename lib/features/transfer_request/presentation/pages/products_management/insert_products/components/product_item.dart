import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/transfer_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/transfer_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/transfer_request/presentation/pages/components/components.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductItem extends ConsumerWidget {
  final ProductEntity product;
  final DraftKey draftKey;
  final bool isSelected;
  final bool requestTypeAllowChangePrice;
  final void Function(TransferRequestProductItemEntity? requestItem) onTap;
  final void Function() update;
  final TextEditingController quantityController;
  final TextEditingController priceController;
  final FocusNode quantityFocusNode;
  final FocusNode priceFocusNode;
  final GlobalKey<FormState> formKey;

  const ProductItem({
    super.key,
    required this.product,
    required this.draftKey,
    required this.isSelected,
    required this.requestTypeAllowChangePrice,
    required this.onTap,
    required this.quantityController,
    required this.priceController,
    required this.quantityFocusNode,
    required this.priceFocusNode,
    required this.formKey,
    required this.update,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transferRequestProductItem = ref.watch(
      cartProductsStateControllerProvider(draftKey).select(
        (s) => s.value?.firstWhereOrNull(
          (x) => x.product.ProductPackingCode == product.ProductPackingCode,
        ),
      ),
    );

    return ProductItemWidget(
      product: product,
      routine: BsRoutine.transferRequest,
      isSelected: isSelected,
      showEditIcon: true,
      onTap: () => onTap(transferRequestProductItem),
      onDelete: transferRequestProductItem != null
          ? () {
              ref
                  .read(cartProductsStateControllerProvider(draftKey).notifier)
                  .removeItem(transferRequestProductItem);
            }
          : null,
      cartItemSummary: transferRequestProductItem != null
          ? CartItemSummary(
              cartQuantity: transferRequestProductItem.quantity,
              cartValue: transferRequestProductItem.value,
              product: product,
            )
          : null,
      notClickableBottom: isSelected
          ? Form(
              key: formKey,
              child: UpdateItemWidget(
                isCartPage: false,
                requestTypeAllowChangePrice: requestTypeAllowChangePrice,
                update: update,
                draftKey: draftKey,
                price: product.Value ?? 0,
                quantityController: quantityController,
                priceController: priceController,
                quantityFocusNode: quantityFocusNode,
                priceFocusNode: priceFocusNode,
              ),
            )
          : null,
    );
  }
}
