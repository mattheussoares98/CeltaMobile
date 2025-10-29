import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/string_modifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../constants/constants.dart';
import '../../../../../../../core/domain/entities/entities.dart';
import '../../../../../../../core/presentation/controllers/products/products.dart';
import '../../../../../../../core/validators/validators.dart';
import '../../../../../../enterprise_manager/domain/entities/entities.dart';
import '../../../../../domain/entities/entities.dart';
import '../../../../controllers/controllers.dart';
import 'components.dart';

class ProductsItems extends ConsumerWidget {
  final int enterpriseCode;
  final int? selectedProductIndex;
  final void Function(int? index, ProductEntity product) onTapProduct;
  final TextEditingController quantityController;
  final FocusNode quantityFocusNode;
  final VoidCallback removeSelectedIndex;
  const ProductsItems({
    super.key,
    required this.enterpriseCode,
    required this.selectedProductIndex,
    required this.onTapProduct,
    required this.quantityController,
    required this.quantityFocusNode,
    required this.removeSelectedIndex,
  });

  static final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

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

      double value = product.Value > 0
          ? product.Value
          : product.RetailPracticedPrice;

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
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (_, index) {
              final product = products[index];

              final cartProduct =
                  pendingAsync.value?.cart[product.ProductPackingCode];

              return ProductItemWidget(
                product: product,
                routine: BsRoutine.saleRequest,
                showDropIcon: true,
                isSelected: index == selectedProductIndex,
                onTap: () => onTapProduct(index, product),
                clickableBottom: cartProduct == null
                    ? null
                    : CartItemSummary(cartProduct: cartProduct),
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
                notClickableBottom: index == selectedProductIndex
                    ? Row(
                        children: [
                          Expanded(
                            child: DefaultTextFormField(
                              labelText: 'Quantidade'.hardcoded,
                              hintText: 'Quantidade'.hardcoded,
                              maxLength: 13,
                              controller: quantityController,
                              focusNode: quantityFocusNode,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              onFieldSubmitted: (_) {
                                insertProduct(product, cartProduct);
                              },
                              validator: FormValidators.compose([
                                NonEmptyValidator(),
                                NumberValidator(allowDecimal: true),
                              ]),
                              onTap: () {
                                if (quantityFocusNode.hasFocus) {
                                  return;
                                }

                                quantityController.selection = TextSelection(
                                  baseOffset: 0,
                                  extentOffset: quantityController.text.length,
                                );
                              },
                            ),
                          ),
                          gapW8,
                          PrimaryButton(
                            text: 'Adicionar'.hardcoded,
                            onPressed: () =>
                                insertProduct(product, cartProduct),
                            icon: Icon(isIOS ? CupertinoIcons.add : Icons.add),
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
