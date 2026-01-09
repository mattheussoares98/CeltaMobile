import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../domain/entities/entities.dart';
import '../../../controllers/controllers.dart';
import '../../pages.dart';
import 'components.dart';

class ProductsItems extends ConsumerWidget {
  final List<ProductEntity> products;
  final ProductsPage productsPage;

  const ProductsItems({
    super.key,
    required this.products,
    required this.productsPage,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingAsync = ref.watch(pendingBuyRequestStateControllerProvider);

    void onDelete(
      ProductEntity product,
      AsyncValue<PendingBuyRequestEntity> pendingAsync,
    ) {
      final products = pendingAsync.value?.products;
      products?.removeWhere((key, value) {
        return key ==
            ProductKey(
              enterpriseCode: product.EnterpriseCode!,
              productPackingCode: product.ProductPackingCode!,
            );
      });

      ref
          .read(pendingBuyRequestStateControllerProvider.notifier)
          .updatePending(pendingAsync.value!.copyWith(products: products));
    }

    products.sort(
      (a, b) => '${a.Name}${a.PLU}${a.EnterpriseCode}'.compareTo(
        '${b.Name}${b.PLU}${b.EnterpriseCode}',
      ),
    );

    final selectedProductIndex = ref.watch(
      uiStateControllerProvider.select((s) => s.value?.selectedProductIndex),
    );

    return ResponsiveListFlow(
      isSliver: true,
      itemCount: products.length,
      itemBuilder: (_, index) {
        final product = products[index];

        final productKey = ProductKey(
          enterpriseCode: product.EnterpriseCode!,
          productPackingCode: product.ProductPackingCode!,
        );

        BuyRequestProductItemEntity? insertedItem =
            pendingAsync.value?.products?[productKey];

        return ProductItemWidget(
          onTap: () => productsPage.onTapProduct(index, product),
          product: product,
          routine: BsRoutine.buyRequest,
          showDropIcon: true,
          isSelected: selectedProductIndex == index,
          onDelete: insertedItem == null
              ? null
              : () => onDelete(product, pendingAsync),
          itemBeforeProductName: EnterpriseCodeAndProductName(product: product),
          clickableBottom: insertedItem == null
              ? null
              : CostQuantityAndTotalWritten(insertedItem: insertedItem),
          notClickableBottom: selectedProductIndex == index
              ? Form(
                  key: productsPage.fieldsFormKey,
                  child: Padding(
                    padding: const EdgeInsets.only(top: Sizes.p8),
                    child: Row(
                      children: [
                        Expanded(
                          child: QuantityFormField(
                            quantityFormKey: productsPage.quantityFormKey,
                            quantityFocusNode: productsPage.quantityFocusNode,
                            quantityController: productsPage.quantityController,
                            costController: productsPage.costController,
                            costFocusNode: productsPage.costFocusNode,
                          ),
                        ),
                        gapW8,
                        Expanded(
                          child: CostFormField(
                            costFocusNode: productsPage.costFocusNode,
                            costController: productsPage.costController,
                            insertProduct: () => productsPage.insertProduct(
                              pendingAsync,
                              product,
                            ),
                          ),
                        ),
                        gapW8,
                        Expanded(
                          child: PrimaryButton(
                            text: 'Confirmar'.hardcoded,
                            onPressed: () => productsPage.insertProduct(
                              pendingAsync,
                              product,
                            ),
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
  }
}
