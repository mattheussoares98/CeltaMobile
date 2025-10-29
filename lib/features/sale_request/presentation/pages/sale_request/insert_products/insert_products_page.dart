import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../../core/presentation/controllers/products/products.dart';
import '../../../../../../core/validators/validators.dart';
import '../../../../../enterprise_manager/domain/entities/entities.dart';
import '../../../../domain/entities/entities.dart';
import '../../../controllers/controllers.dart';

class InsertProductsPage extends ConsumerWidget {
  final int enterpriseCode;
  final TextEditingController searchProductsController;
  final TextEditingController quantityController;
  final FocusNode quantityFocusNode;
  final int? selectedProductIndex;
  final void Function(int? index) onTapProduct;
  const InsertProductsPage({
    super.key,
    required this.enterpriseCode,
    required this.searchProductsController,
    required this.quantityController,
    required this.quantityFocusNode,
    required this.selectedProductIndex,
    required this.onTapProduct,
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
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    void insertProduct(ProductEntity product, CartProductEntity? cartProduct) {
      if (_formKey.currentState?.validate() != true) {
        return;
      }

      double quantity = quantityController.text.toDouble() ?? 0;
      if (cartProduct != null) {
        quantity += cartProduct.Quantity;
      }

      ref
          .read(
            pendingSaleRequestStateControllerProvider(enterpriseCode).notifier,
          )
          .addProduct(
            CartProductEntity(
              ProductPackingCode: product.ProductPackingCode,
              Quantity: quantity,
              Value: product.Value,
              TotalLiquid: quantity * product.Value,
            ),
          );

      quantityController.clear();
      onTapProduct(null);
    }

    final pendingAsync = ref.watch(
      pendingSaleRequestStateControllerProvider(enterpriseCode),
    );

    return Padding(
      padding: const EdgeInsets.all(Sizes.p8),
      child: Column(
        children: [
          DefaultSearchProducts(
            isLoading: searchAsync.isLoading,
            searchValueController: searchProductsController,
            searchProducts: () {
              ref
                  .read(
                    searchProductsStateControllerProvider(
                      enterpriseCode,
                      BsRoutine.saleRequest,
                      Modules.saleRequest,
                    ).notifier,
                  )
                  .loadProducts(
                    searchValue: searchProductsController.text,
                    enterpriseCodes: [enterpriseCode],
                  );
            },
          ),
          gapH8,
          Expanded(
            child: Form(
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
                        onTap: () => onTapProduct(index),
                        clickableBottom: cartProduct == null
                            ? null
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TitleAndSubTitle(
                                    title: 'Qtd no carrinho'.hardcoded,
                                    subTitle: cartProduct.Quantity.toString()
                                        .toBrazilianNumber(),
                                    titleStyle: theme.textTheme.titleMedium
                                        ?.copyWith(
                                          color: theme.colorScheme.secondary,
                                        ),
                                    subTitleStyle: theme.textTheme.titleMedium
                                        ?.copyWith(
                                          color: theme.colorScheme.secondary,
                                        ),
                                  ),
                                  TitleAndSubTitle(
                                    title: 'Preço'.hardcoded,
                                    subTitle: cartProduct.Value.toString()
                                        .toBrazilianNumber(),
                                    subTitleIsPrice: true,
                                    titleStyle: theme.textTheme.titleMedium
                                        ?.copyWith(
                                          color: theme.colorScheme.secondary,
                                        ),
                                    subTitleStyle: theme.textTheme.titleMedium
                                        ?.copyWith(
                                          color: theme.colorScheme.secondary,
                                        ),
                                  ),
                                  TitleAndSubTitle(
                                    title: 'Total'.hardcoded,
                                    subTitle: cartProduct.TotalLiquid.toString()
                                        .toBrazilianNumber(),
                                    subTitleIsPrice: true,
                                    titleStyle: theme.textTheme.titleMedium
                                        ?.copyWith(
                                          color: theme.colorScheme.secondary,
                                        ),
                                    subTitleStyle: theme.textTheme.titleMedium
                                        ?.copyWith(
                                          color: theme.colorScheme.secondary,
                                        ),
                                  ),
                                ],
                              ),
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

                                        quantityController
                                            .selection = TextSelection(
                                          baseOffset: 0,
                                          extentOffset:
                                              quantityController.text.length,
                                        );
                                      },
                                    ),
                                  ),
                                  gapW8,
                                  PrimaryButton(
                                    text: 'Adicionar'.hardcoded,
                                    onPressed: () =>
                                        insertProduct(product, cartProduct),
                                    icon: Icon(
                                      isIOS ? CupertinoIcons.add : Icons.add,
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
            ),
          ),
        ],
      ),
    );
  }
}
