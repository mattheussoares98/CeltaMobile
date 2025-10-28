import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../domain/entities/entities.dart';
import '../../controllers/controllers.dart';
import 'components/components.dart';

class InsertProductsPage extends ConsumerStatefulWidget {
  final int enterpriseOriginCode;
  final int enterpriseDestinyCode;
  final int requestTypeCode;
  final TextEditingController searchValueController;
  final FocusNode searchValueFocusNode;
  final TextEditingController quantityController;
  final TextEditingController priceController;
  final FocusNode quantityFocusNode;
  final FocusNode priceFocusNode;
  final void Function({
    required int index,
    required ProductEntity product,
    required List<RequestTypeEntity>? requests,
    required TransferRequestProductItemEntity? transferRequestProductItem,
  })
  onTapProductItem;
  final int? selectedProductIndex;
  final bool requestTypeAllowChangePrice;
  final void Function(TransferRequestProductItemEntity productItem)
  removeProductItem;
  const InsertProductsPage({
    super.key,
    required this.enterpriseOriginCode,
    required this.enterpriseDestinyCode,
    required this.requestTypeCode,
    required this.searchValueController,
    required this.searchValueFocusNode,
    required this.quantityController,
    required this.priceController,
    required this.quantityFocusNode,
    required this.priceFocusNode,
    required this.onTapProductItem,
    required this.selectedProductIndex,
    required this.requestTypeAllowChangePrice,
    required this.removeProductItem,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _InsertProductsPageState();
}

class _InsertProductsPageState extends ConsumerState<InsertProductsPage> {
  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(
      productsStateControllerProvider(
        enterpriseOriginCode: widget.enterpriseOriginCode,
        enterpriseDestinyCode: widget.enterpriseDestinyCode,
        requestTypeCode: widget.requestTypeCode,
      ),
    );
    ref.listen(
      productsStateControllerProvider(
        enterpriseOriginCode: widget.enterpriseOriginCode,
        enterpriseDestinyCode: widget.enterpriseDestinyCode,
        requestTypeCode: widget.requestTypeCode,
      ),
      (p, n) {
        n.doOnSuccess(p, () {
          widget.searchValueController.clear();
        });
      },
    );

    final pendingTransfer = ref.watch(
      pendingTransferRequestStateControllerProvider(
        DraftKey(
          requestTypeCode: widget.requestTypeCode,
          enterpriseOrigin: widget.enterpriseOriginCode,
          enterpriseDestinyCode: widget.enterpriseDestinyCode,
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.all(Sizes.p8),
      child: Column(
        children: [
          DefaultSearchProducts(
            isLoading: productsAsync.isLoading,
            focusNode: widget.searchValueFocusNode,
            searchProducts: () {
              ref
                  .read(
                    productsStateControllerProvider(
                      enterpriseOriginCode: widget.enterpriseOriginCode,
                      enterpriseDestinyCode: widget.enterpriseDestinyCode,
                      requestTypeCode: widget.requestTypeCode,
                    ).notifier,
                  )
                  .loadProducts(searchValue: widget.searchValueController.text);
            },
            searchValueController: widget.searchValueController,
          ),
          gapH8,
          AsyncValueWidget(
            value: productsAsync,
            tryAgain: null,
            data: (products) {
              return Expanded(
                child: ProductsItems(
                  products: products,
                  pendingTransfer: pendingTransfer,
                  selectedIndex: widget.selectedProductIndex,
                  onTap: widget.onTapProductItem,
                  removeItem: widget.removeProductItem,
                  requestTypeAllowChangePrice:
                      widget.requestTypeAllowChangePrice,
                  insertProductsPage: widget,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
