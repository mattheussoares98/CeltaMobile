import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../../core/presentation/controllers/products/products.dart';
import '../../../../../../core/validators/validators.dart';
import '../../../../../enterprise_manager/domain/entities/entities.dart';

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
          AsyncValueWidget(
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
              return Expanded(
                child: ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (_, index) {
                    final product = products[index];
                    return ProductItemWidget(
                      product: product,
                      routine: BsRoutine.saleRequest,
                      showDropIcon: true,
                      isSelected: index == selectedProductIndex,
                      onTap: () => onTapProduct(index),
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
                                    onFieldSubmitted: (_) {
                                      //TODO add in cart
                                    },
                                    validator: FormValidators.compose([
                                      NonEmptyValidator(),
                                      NumberValidator(allowDecimal: true),
                                    ]),
                                    onTap: () {
                                      if (quantityFocusNode.hasFocus) {
                                        return;
                                      }

                                      quantityController.selection =
                                          TextSelection(
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
                                  icon: Icon(
                                    isIOS ? CupertinoIcons.add : Icons.add,
                                  ),
                                ),
                              ],
                            )
                          : null,
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
