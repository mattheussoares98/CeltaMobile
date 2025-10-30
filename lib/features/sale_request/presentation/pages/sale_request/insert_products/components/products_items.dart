import 'package:celta_intelligence/utils/string_modifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../constants/constants.dart';
import '../../../../../../../core/domain/entities/entities.dart';
import '../../../../../../../core/presentation/controllers/products/products.dart';
import '../../../../../../enterprise_manager/domain/entities/entities.dart';
import '../../../../../domain/entities/entities.dart';
import '../../../../controllers/controllers.dart';
import 'components.dart';

class ProductsItems extends ConsumerWidget {
  final int enterpriseCode;
  final int? selectedIndex;
  final void Function(int? index, ProductEntity product) onTapProduct;
  final TextEditingController quantityController;
  final FocusNode quantityFocusNode;
  final TextEditingController priceController;
  final FocusNode priceFocusNode;
  final VoidCallback removeSelectedIndex;
  final bool requestTypeAllowChangePrice;
  const ProductsItems({
    super.key,
    required this.enterpriseCode,
    required this.selectedIndex,
    required this.onTapProduct,
    required this.quantityController,
    required this.quantityFocusNode,
    required this.removeSelectedIndex,
    required this.requestTypeAllowChangePrice,
    required this.priceController,
    required this.priceFocusNode,
  });

  static final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchAsync = ref.watch(
      searchProductsStateControllerProvider(
        enterpriseCode,
        BsRoutine.saleRequest,
        Modules.saleRequest,
      ),
    );

    final pendingAsync = ref.watch(
      pendingSaleRequestStateControllerProvider(enterpriseCode),
    );

    void insertProduct(ProductEntity product, CartProductEntity? cartProduct) {
      if (_formKey.currentState?.validate() != true) {
        return;
      }

      double quantity = quantityController.text.toDouble() ?? 0;
      if (cartProduct != null) {
        quantity += cartProduct.Quantity;
      }

      double value = priceController.text.toDouble() ?? product.getPrice;

      ref
          .read(
            pendingSaleRequestStateControllerProvider(enterpriseCode).notifier,
          )
          .addProduct(
            CartProductEntity(
              ProductPackingCode: product.ProductPackingCode,
              Quantity: quantity,
              Value: value,
              TotalLiquid: quantity * value,
            ),
          );

      quantityController.clear();
      removeSelectedIndex();
    }

    return Form(
      key: _formKey,
      child: AsyncValueWidget(
        value: searchAsync,
        tryAgain: () {
          ref.invalidate(
            searchProductsStateControllerProvider(
              enterpriseCode,
              BsRoutine.saleRequest,
              Modules.saleRequest,
            ),
          );
        },
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
                isSelected: index == selectedIndex,
                onTap: () => onTapProduct(index, product),
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
                              pendingSaleRequestStateControllerProvider(
                                enterpriseCode,
                              ).notifier,
                            )
                            .removeProduct(cartProduct);
                      },
                notClickableBottom: index == selectedIndex
                    ? Row(
                        children: [
                          Expanded(
                            flex: 65,
                            child: Column(
                              children: [
                                QuantityField(
                                  requestTypeAllowChangePrice:
                                      requestTypeAllowChangePrice,
                                  quantityFocusNode: quantityFocusNode,
                                  quantityController: quantityController,
                                  priceFocusNode: priceFocusNode,
                                  insertProduct: () =>
                                      insertProduct(product, cartProduct),
                                ),
                                if (requestTypeAllowChangePrice) ...[
                                  gapH4,
                                  PriceField(
                                    priceController: priceController,
                                    priceFocusNode: priceFocusNode,
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
                              priceController: priceController,
                              quantityController: quantityController,
                              requestTypeAllowChangePrice:
                                  requestTypeAllowChangePrice,
                              product: product,
                            ),
                          ),
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
