import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/string_modifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../constants/constants.dart';
import '../../../../../../../core/domain/entities/entities.dart';
import '../../../../../../../core/presentation/controllers/products/products.dart';
import '../../../../../../../core/validators/validators.dart';
import '../../../../../domain/entities/entities.dart';
import '../../../../controllers/controllers.dart';
import 'components.dart';

class ProductsItems extends ConsumerStatefulWidget {
  final int enterpriseCode;
  final int? selectedIndex;
  final void Function(
    int? index,
    ProductEntity product,
    CartProductEntity? cartProduct,
  )
  onTapProduct;
  final TextEditingController quantityController;
  final TextEditingController priceController;
  final TextEditingController discountController;
  final FocusNode quantityFocusNode;
  final FocusNode priceFocusNode;
  final FocusNode discountFocusNode;
  final VoidCallback removeSelectedIndex;
  final RequestTypeEntity selectedRequest;
  const ProductsItems({
    super.key,
    required this.enterpriseCode,
    required this.selectedIndex,
    required this.onTapProduct,
    required this.quantityController,
    required this.priceController,
    required this.discountController,
    required this.quantityFocusNode,
    required this.priceFocusNode,
    required this.discountFocusNode,
    required this.removeSelectedIndex,
    required this.selectedRequest,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductsItemsState();
}

class _ProductsItemsState extends ConsumerState<ProductsItems> {
  final formKey = GlobalKey<FormState>();
  PercentageOrValue discountType = PercentageOrValue.value;

  @override
  Widget build(BuildContext context) {
    final searchAsync = ref.watch(
      searchProductsStateControllerProvider(
        widget.enterpriseCode,
        BsRoutine.saleRequest,
        Modules.saleRequest,
      ),
    );

    final pendingAsync = ref.watch(pendingSaleRequestStateControllerProvider);

    void insertProduct(ProductEntity product, CartProductEntity? cartProduct) {
      if (formKey.currentState?.validate() != true) {
        return;
      }

      double quantity = widget.quantityController.text.toDouble() ?? 0;
      if (cartProduct != null) {
        quantity += cartProduct.Quantity;
      }

      double value = widget.priceController.text.toDouble() ?? product.getPrice;

      ref
          .read(pendingSaleRequestStateControllerProvider.notifier)
          .addProduct(
            CartProductEntity(
              ProductPackingCode: product.ProductPackingCode,
              Quantity: quantity,
              Value: value,
              TotalLiquid: quantity * value,
            ),
          );

      widget.quantityController.clear();
      widget.removeSelectedIndex();
      widget.discountController.clear();
    }

    return Form(
      key: formKey,
      child: AsyncValueWidget(
        value: searchAsync,
        tryAgain: null,
        data: (products) {
          return ResponsiveListFlow(
            itemCount: products.length,
            itemBuilder: (_, index) {
              final product = products[index];

              final cartProduct =
                  pendingAsync.value?.cart[product.ProductPackingCode];

              return ProductItemWidget(
                product: product,
                routine: BsRoutine.saleRequest,
                showDropIcon: true,
                isSelected: index == widget.selectedIndex,
                onTap: () => widget.onTapProduct(index, product, cartProduct),
                cartItemSummary: cartProduct == null
                    ? null
                    : CartItemSummary(
                        cartQuantity: cartProduct.Quantity,
                        cartValue: cartProduct.Value,
                        product: product,
                      ),
                onDelete: cartProduct == null
                    ? null
                    : () {
                        ref
                            .read(
                              pendingSaleRequestStateControllerProvider
                                  .notifier,
                            )
                            .removeProduct(cartProduct);
                      },
                notClickableBottom: index == widget.selectedIndex
                    ? Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 65,
                                child: Column(
                                  children: [
                                    QuantityField(
                                      productsItems: widget,
                                      insertProduct: () =>
                                          insertProduct(product, cartProduct),
                                    ),
                                    if (widget
                                            .selectedRequest
                                            .AllowAlterCostOrSalePrice ==
                                        true) ...[
                                      gapH4,
                                      PriceField(
                                        productsItems: widget,
                                        insertProduct: () =>
                                            insertProduct(product, cartProduct),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              gapW4,
                              Expanded(
                                flex: 35,
                                child: TotalPriceAndInsertButton(
                                  insertProduct: () =>
                                      insertProduct(product, cartProduct),
                                  productsItems: widget,
                                  product: product,
                                ),
                              ),
                            ],
                          ),
                          if (widget.selectedRequest.AllowDiscount == true) ...[
                            gapH4,
                            //TODO create new components
                            Row(
                              children: [
                                Expanded(
                                  flex: 65,
                                  child: DefaultTextFormField(
                                    hintText: 'Desconto'.hardcoded,
                                    labelText: 'Desconto'.hardcoded,
                                    controller: widget.discountController,
                                    focusNode: widget.discountFocusNode,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    maxLength: 13,
                                    onFieldSubmitted: (_) {
                                      insertProduct(product, cartProduct);
                                    },
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                          decimal: true, //TODO test in IOS
                                        ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return null;
                                      }

                                      final numberValidator = NumberValidator(
                                        allowDecimal: true,
                                      );

                                      final isValid = numberValidator.isValid(
                                        value,
                                      );

                                      if (isValid) {
                                        return null;
                                      } else {
                                        return numberValidator.errorMessage;
                                      }
                                    },
                                  ),
                                ),
                                gapW8,
                                Flexible(
                                  flex: 35,
                                  child:
                                      DefaultSimpleDropDown<PercentageOrValue>(
                                        onChanged: (value) {
                                          setState(() {
                                            discountType = value!;
                                          });
                                        },
                                        value: discountType,
                                        hint: 'Tipo',
                                        items: [
                                          DropdownMenuItem(
                                            value: PercentageOrValue.percentage,
                                            child: Text(
                                              PercentageOrValue
                                                  .percentage
                                                  .symbol,
                                            ),
                                          ),
                                          DropdownMenuItem(
                                            value: PercentageOrValue.value,
                                            child: Text(
                                              PercentageOrValue.value.symbol,
                                            ),
                                          ),
                                        ],
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      )
                    : null,
              );
            },
          );
        },
      ),
    );
  }
}
