import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../../core/presentation/controllers/products/products.dart';
import '../../../../../../utils/utils.dart';
import '../../../../domain/entities/entities.dart';
import '../../../controllers/controllers.dart';
import '../../components/components.dart';
import 'components.dart';

class ProductsItems extends ConsumerStatefulWidget {
  const ProductsItems({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductsItemsState();
}

class _ProductsItemsState extends ConsumerState<ProductsItems> {
  final quantityFormKey = GlobalKey<FormState>();
  final fieldsFormKey = GlobalKey<FormState>();
  final searchProductController = TextEditingController();
  final quantityController = TextEditingController();
  final costController = TextEditingController();
  final quantityFocusNode = FocusNode();
  final costFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    searchProductController.dispose();
    quantityController.dispose();
    costController.dispose();
    quantityFocusNode.dispose();
    costFocusNode.dispose();
  }

  void insertProduct(ProductEntity product) async {
    if (quantityFormKey.currentState?.validate() != true) {
      quantityFocusNode.requestFocus();
      return;
    } else if (fieldsFormKey.currentState?.validate() != true) {
      costFocusNode.requestFocus();
      return;
    }

    final pending = await ref.read(
      pendingBuyRequestStateControllerProvider.future,
    );
    final products = pending.products ?? {};
    products.addAll({
      ProductKey(
        enterpriseCode: product.EnterpriseCode!,
        productPackingCode: product.ProductPackingCode!,
      ): BuyRequestProductItemEntity(
        product: product,
        quantity: quantityController.text.toDouble()!,
        cost: costController.text.toDouble()!,
      ),
    });
    ref
        .read(pendingBuyRequestStateControllerProvider.notifier)
        .updatePending(pending.copyWith(products: products));
    quantityController.clear();
    costController.clear();
    ref
        .read(uiStateControllerProvider.notifier)
        .updateSelectedProductIndex(null);
  }

  void onTapProduct(int index, ProductEntity product) async {
    quantityController.clear();
    costController.clear();

    ref
        .read(uiStateControllerProvider.notifier)
        .updateSelectedProductIndex(index);

    if ((product.PriceCost!.LiquidCost ?? 0) > 0) {
      costController.text = product.PriceCost!.LiquidCost
          .toString()
          .toBrazilianNumber(4);
    }

    Future.delayed(const Duration(milliseconds: 100), () {
      quantityFocusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final pending = ref.watch(pendingBuyRequestStateControllerProvider);
    const searchProductKey = SearchProductKey(
      0,
      BsRoutine.buyRequest,
      Modules.buyRequest,
    );

    void onDelete(
      ProductEntity product,
      AsyncValue<PendingBuyRequestEntity> pending,
    ) {
      final products = pending.value?.products;
      products?.removeWhere((key, value) {
        return key ==
            ProductKey(
              enterpriseCode: product.EnterpriseCode!,
              productPackingCode: product.ProductPackingCode!,
            );
      });

      ref
          .read(pendingBuyRequestStateControllerProvider.notifier)
          .updatePending(pending.value!.copyWith(products: products));
    }

    final selectedProductIndex = ref.watch(
      uiStateControllerProvider.select((s) => s.value?.selectedProductIndex),
    );

    final productsState = ref.watch(
      searchProductsStateControllerProvider(searchProductKey),
    );
    return AsyncValueSliverWidget(
      value: productsState,
      tryAgain: null,
      data: (products) {
        products.sort(
          (a, b) => '${a.Name}${a.PLU}${a.EnterpriseCode}'.compareTo(
            '${b.Name}${b.PLU}${b.EnterpriseCode}',
          ),
        );

        final filteredProducts =
            products
                .where(
                  (e) =>
                      ref
                          .watch(pendingBuyRequestStateControllerProvider)
                          .value
                          ?.selectedEnterprises
                          ?.map((e) => e.Code)
                          .contains(e.EnterpriseCode) ==
                      true,
                )
                .toList()
              ..sort((a, b) => a.Name!.compareTo(b.Name!));

        return ResponsiveListFlow(
          isSliver: true,
          itemCount: filteredProducts.length,
          itemBuilder: (_, index) {
            final product = filteredProducts[index];

            final productKey = ProductKey(
              enterpriseCode: product.EnterpriseCode!,
              productPackingCode: product.ProductPackingCode!,
            );

            BuyRequestProductItemEntity? insertedItem =
                pending.value?.products?[productKey];

            return ProductItemWidget(
              onTap: () => onTapProduct(index, product),
              product: product,
              routine: BsRoutine.buyRequest,
              showDropIcon: true,
              isSelected: selectedProductIndex == index,
              onDelete: insertedItem == null
                  ? null
                  : () => onDelete(product, pending),
              itemBeforeProductName: EnterpriseCodeAndProductName(
                product: product,
              ),
              cartItemSummary: insertedItem == null
                  ? null
                  : CartItemSummary(
                      cartQuantity: insertedItem.quantity,
                      cartValue: insertedItem.cost,
                      product: insertedItem.product,
                    ),
              notClickableBottom: selectedProductIndex == index
                  ? Form(
                      key: fieldsFormKey,
                      child: Padding(
                        padding: const EdgeInsets.only(top: Sizes.p8),
                        child: Row(
                          children: [
                            Expanded(
                              child: QuantityFormField(
                                quantityFormKey: quantityFormKey,
                                quantityFocusNode: quantityFocusNode,
                                quantityController: quantityController,
                                costController: costController,
                                costFocusNode: costFocusNode,
                              ),
                            ),
                            gapW8,
                            Expanded(
                              child: CostFormField(
                                costFocusNode: costFocusNode,
                                costController: costController,
                                insertProduct: () => insertProduct(product),
                              ),
                            ),
                            gapW8,
                            Expanded(
                              child: PrimaryButton(
                                text: 'Confirmar'.hardcoded,
                                onPressed: () => insertProduct(product),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : null,
            );
          },
        );
      },
    );
  }
}
