import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../../core/presentation/controllers/request_type/request_type.dart';
import '../../../../../enterprise_manager/domain/entities/modules.dart';
import '../../../../domain/entities/entities.dart';
import '../../pages.dart';
import 'components.dart';

class ProductsItems extends ConsumerWidget {
  final List<ProductEntity> products;
  final AsyncValue<List<TransferRequestProductItemEntity>> pendingTransfer;
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
    required this.pendingTransfer,
    required this.selectedIndex,
    required this.onTap,
    required this.removeItem,
    required this.requestTypeAllowChangePrice,
    required this.insertProductsPage,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requests = ref.watch(
      requestTypeStateControllerProvider(Modules.transferRequest),
    );

    return ResponsiveListFlow(
      itemCount: products.length,
      itemBuilder: (_, index) {
        final product = products[index];

        int? transferProductItemIndex = pendingTransfer.value?.indexWhere(
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
                : pendingTransfer.value?[transferProductItemIndex],
          ),
          onDelete: hasInCart == true
              ? () {
                  removeItem(pendingTransfer.value![transferProductItemIndex!]);
                }
              : null,
          clickableBottom: hasInCart
              ? CartQuantityAndTotal(
                  item: pendingTransfer.value![transferProductItemIndex],
                  requestTypeAllowChangePrice: requestTypeAllowChangePrice,
                )
              : null,
          notClickableBottom: selectedIndex == index
              ? FieldsAndInsertButton(
                  requestTypeAllowChangePrice: requestTypeAllowChangePrice,
                  priceController: insertProductsPage.priceController,
                  priceFocusNode: insertProductsPage.priceFocusNode,
                  quantityController: insertProductsPage.quantityController,
                  quantityFocusNode: insertProductsPage.quantityFocusNode,
                  product: product,
                  enterpriseDestinyCode:
                      insertProductsPage.enterpriseDestinyCode,
                  enterpriseOriginCode: insertProductsPage.enterpriseOriginCode,
                  requestTypeCode: insertProductsPage.requestTypeCode,
                )
              : null,
        );
      },
    );
  }
}
