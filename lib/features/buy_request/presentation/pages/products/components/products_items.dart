import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../domain/entities/entities.dart';
import '../../../controllers/controllers.dart';
import 'components.dart';

class ProductsItems extends ConsumerWidget {
  final int? selectedIndex;
  final List<ProductEntity> products;
  final void Function(int index, ProductEntity product) onTap;
  final GlobalKey<FormState> fieldsFormKey;
  final GlobalKey<FormState> quantityFormKey;
  final FocusNode quantityFocusNode;
  final TextEditingController quantityController;
  final FocusNode costFocusNode;
  final TextEditingController costController;
  final void Function(
    AsyncValue<PendingBuyRequestEntity> pendingAsync,
    ProductEntity product,
  )
  insertProduct;

  const ProductsItems({
    super.key,
    required this.selectedIndex,
    required this.products,
    required this.onTap,
    required this.fieldsFormKey,
    required this.quantityFormKey,
    required this.quantityFocusNode,
    required this.quantityController,
    required this.costFocusNode,
    required this.costController,
    required this.insertProduct,
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
              enterpriseCode: product.EnterpriseCode,
              productPackingCode: product.ProductPackingCode,
            );
      });

      ref
          .read(pendingBuyRequestStateControllerProvider.notifier)
          .updatePending(pendingAsync.value!.copyWith(products: products));
    }

    return SliverList.builder(
      itemCount: products.length,
      itemBuilder: (_, index) {
        final product = products[index];

        final productKey = ProductKey(
          enterpriseCode: product.EnterpriseCode,
          productPackingCode: product.ProductPackingCode,
        );

        BuyRequestProductItemEntity? insertedItem =
            pendingAsync.value?.products?[productKey];

        return ProductItemWidget(
          onTap: () => onTap(index, product),
          product: product,
          routine: BsRoutine.buyRequest,
          showDropIcon: true,
          isSelected: selectedIndex == index,
          onDelete: insertedItem == null
              ? null
              : () => onDelete(product, pendingAsync),
          itemBeforeProductName: EnterpriseCodeAndProductName(product: product),
          clickableBottom: insertedItem == null
              ? null
              : CostQuantityAndTotalWritten(insertedItem: insertedItem),
          notClickableBottom: selectedIndex == index
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
                            costFocusNode: costFocusNode,
                          ),
                        ),
                        gapW8,
                        Expanded(
                          child: CostFormField(
                            costFocusNode: costFocusNode,
                            costController: costController,
                            insertProduct: () =>
                                insertProduct(pendingAsync, product),
                          ),
                        ),
                        gapW8,
                        Expanded(
                          child: PrimaryButton(
                            text: 'Confirmar'.hardcoded,
                            onPressed: () =>
                                insertProduct(pendingAsync, product),
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
