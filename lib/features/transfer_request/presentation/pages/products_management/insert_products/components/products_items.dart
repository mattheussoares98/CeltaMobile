import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../core/domain/entities/entities.dart';
import '../../../../../../../core/presentation/controllers/products/products.dart';
import '../../../../../../../localization/string_hardcoded.dart';
import '../../../../../../../utils/utils.dart';
import '../../../../../domain/entities/entities.dart';
import '../../../../controllers/controllers.dart';
import '../../../components/components.dart';

class ProductsItems extends ConsumerStatefulWidget {
  final DraftKey draftKey;
  final SearchProductKey searchProductKey;
  const ProductsItems({
    super.key,
    required this.draftKey,
    required this.searchProductKey,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductsItemsState();
}

class _ProductsItemsState extends ConsumerState<ProductsItems> {
  final quantityController = TextEditingController();
  final priceController = TextEditingController();
  final quantityFocusNode = FocusNode();
  final priceFocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    quantityController.dispose();
    priceController.dispose();
    quantityFocusNode.dispose();
    priceFocusNode.dispose();
  }

  void onTapProductItem({
    required int index,
    required ProductEntity product,
    required TransferRequestProductItemEntity? transferRequestProductItem,
    required bool requestTypeAllowChangePrice,
  }) {
    priceController.clear();

    if (product.Value == 0 && !requestTypeAllowChangePrice) {
      showSnackBarMessage(
        context,
        'O produto está com o preço zerado e o modelo de pedido selecionado não permite alterar o preço'
            .hardcoded,
        backgroundColor: Colors.red,
      );
      ref
          .read(
            uiStateControllerProvider(widget.draftKey.requestTypeCode).notifier,
          )
          .updateSelectedInsertProductIndex(null);
      return;
    }

    ref
        .read(
          uiStateControllerProvider(widget.draftKey.requestTypeCode).notifier,
        )
        .updateSelectedInsertProductIndex(index);

    quantityController.text = '1';
    if (product.Value! > 0 || transferRequestProductItem?.value != null) {
      final price = transferRequestProductItem?.value ?? product.Value;
      priceController.text = price.toString().toBrazilianNumber().replaceAll(
        RegExp(r'\.'),
        '',
      );
    }
    Future.delayed(const Duration(milliseconds: 100), () {
      quantityFocusNode.requestFocus();
      quantityController.selection = TextSelection(
        baseOffset: 0,
        extentOffset: quantityController.text.length,
      );
    });
  }

  void removeProductItem(TransferRequestProductItemEntity productItem) {
    ref
        .read(cartProductsStateControllerProvider(widget.draftKey).notifier)
        .removeItem(productItem);
  }

  void update({
    required ProductEntity product,
    required double? quantityInCart,
  }) {
    if (formKey.currentState?.validate() != true) {
      return;
    }

    final newQuantity = quantityController.text.toDouble() ?? 0;
    final value = priceController.text.toDouble() ?? product.Value;

    ref
        .read(cartProductsStateControllerProvider(widget.draftKey).notifier)
        .addItem(
          TransferRequestProductItemEntity(
            product: product,
            quantity: newQuantity,
            value: value!,
          ),
        );

    ref
        .read(
          uiStateControllerProvider(widget.draftKey.requestTypeCode).notifier,
        )
        .updateSelectedInsertProductIndex(null);
  }

  @override
  Widget build(BuildContext context) {
    final pendingAsync = ref.watch(
      cartProductsStateControllerProvider(widget.draftKey),
    );

    final requestTypeAllowChangePrice = ref.watch(
      uiStateControllerProvider(
        widget.draftKey.requestTypeCode,
      ).select((s) => s.value?.requestTypeAllowChangePrice ?? false),
    );

    final selectedIndex = ref.watch(
      uiStateControllerProvider(
        widget.draftKey.requestTypeCode,
      ).select((s) => s.value?.selectedInsertProductIndex),
    );

    return CustomScrollView(
      physics: const ClampingScrollPhysics(),
      slivers: [
        AsyncValueSliverWidget(
          value: ref.watch(
            searchProductsStateControllerProvider(widget.searchProductKey),
          ),
          tryAgain: null,
          data: (products) {
            return ResponsiveListFlow(
              isSliver: true,
              itemCount: products.length,
              itemBuilder: (_, index) {
                final product = products[index];

                int? transferProductItemIndex = pendingAsync.value?.indexWhere(
                  (element) =>
                      element.product.ProductPackingCode ==
                      product.ProductPackingCode,
                );

                bool hasInCart =
                    transferProductItemIndex != null &&
                    transferProductItemIndex != -1;

                final transferRequestProductItem = hasInCart
                    ? pendingAsync.value![transferProductItemIndex]
                    : null;

                return ProductItemWidget(
                  key: ValueKey(
                    '${product.ProductPackingCode}${product.EnterpriseCode}',
                  ),
                  product: product,
                  routine: BsRoutine.transferRequest,
                  isSelected: selectedIndex == index,
                  showDropIcon: true,
                  onTap: () {
                    onTapProductItem(
                      index: index,
                      product: product,
                      transferRequestProductItem: transferRequestProductItem,
                      requestTypeAllowChangePrice: requestTypeAllowChangePrice,
                    );
                  },
                  onDelete: hasInCart == true
                      ? () {
                          removeProductItem(
                            pendingAsync.value![transferProductItemIndex!],
                          );
                        }
                      : null,
                  cartItemSummary: hasInCart
                      ? CartItemSummary(
                          cartQuantity: pendingAsync
                              .value![transferProductItemIndex]
                              .quantity,
                          cartValue: pendingAsync
                              .value![transferProductItemIndex]
                              .value,
                          product: product,
                        )
                      : null,
                  notClickableBottom: selectedIndex == index
                      ? Form(
                          key: formKey,
                          child: UpdateItemWidget(
                            isAlreadyInCart: hasInCart,
                            update: () {
                              update(
                                product: product,
                                quantityInCart:
                                    transferRequestProductItem?.quantity,
                              );
                            },
                            draftKey: widget.draftKey,
                            price: product.Value ?? 0,
                            quantityController: quantityController,
                            priceController: priceController,
                            quantityFocusNode: quantityFocusNode,
                            priceFocusNode: priceFocusNode,
                          ),
                        )
                      : null,
                );
              },
            );
          },
        ),
      ],
    );
  }
}
