import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../commom_widgets/responsive_sliver_list_flow.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../../core/presentation/controllers/request_type/request_type.dart';
import '../../../../../enterprise_manager/domain/entities/modules.dart';
import '../../../../domain/entities/entities.dart';
import '../../../controllers/controllers.dart';
import '../../pages.dart';
import 'components.dart';

class ProductsItems extends ConsumerWidget {
  final List<ProductEntity> products;
  final int? selectedIndex;
  final void Function({
    required int index,
    required ProductEntity product,
    required List<RequestTypeEntity>? requests,
    required TransferRequestProductItemEntity? transferRequestProductItem,
  })
  onTap;
  final void Function(TransferRequestProductItemEntity productItem) removeItem;
  final bool requestTypeAllowChangePrice;
  final InsertProductsPage insertProductsPage;
  const ProductsItems({
    super.key,
    required this.products,
    required this.selectedIndex,
    required this.onTap,
    required this.removeItem,
    required this.requestTypeAllowChangePrice,
    required this.insertProductsPage,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingAsync = ref.watch(
      cartProductsStateControllerProvider(
        DraftKey(
          requestTypeCode: insertProductsPage.requestTypeCode,
          enterpriseOrigin: insertProductsPage.enterpriseOriginCode,
          enterpriseDestinyCode: insertProductsPage.enterpriseDestinyCode,
        ),
      ),
    );

    final requests = ref.watch(
      requestTypeStateControllerProvider(Modules.transferRequest),
    );

    return ResponsiveListSliverFlow(
      itemCount: products.length,
      itemBuilder: (_, index) {
        final product = products[index];

        int? transferProductItemIndex = pendingAsync.value?.indexWhere(
          (element) =>
              element.product.ProductPackingCode == product.ProductPackingCode,
        );

        bool hasInCart =
            transferProductItemIndex != null && transferProductItemIndex != -1;

        return ProductItemWidget(
          product: product,
          routine: BsRoutine.transferRequest,
          isSelected: selectedIndex == index,
          showDropIcon: true,
          onTap: () => onTap(
            index: index,
            product: product,
            requests: requests.value,
            transferRequestProductItem:
                transferProductItemIndex == null || !hasInCart
                ? null
                : pendingAsync.value?[transferProductItemIndex],
          ),
          onDelete: hasInCart == true
              ? () {
                  removeItem(pendingAsync.value![transferProductItemIndex!]);
                }
              : null,
          cartItemSummary: hasInCart
              ? CartItemSummary(
                  cartQuantity:
                      pendingAsync.value![transferProductItemIndex].quantity,
                  cartValue:
                      pendingAsync.value![transferProductItemIndex].value,
                  product: product,
                )
              : null,
          notClickableBottom: selectedIndex == index
              ? FieldsAndInsertButton(
                  product: product,
                  insertProductsPage: insertProductsPage,
                )
              : null,
        );
      },
    );
  }
}
