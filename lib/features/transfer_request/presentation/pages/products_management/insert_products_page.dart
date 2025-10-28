import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../core/presentation/controllers/request_type/request_type.dart';
import '../../../../enterprise_manager/domain/entities/entities.dart';
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
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _InsertProductsPageState();
}

class _InsertProductsPageState extends ConsumerState<InsertProductsPage> {
  int? selectedIndex;
  bool requestTypeAllowChangePrice = false;

  @override
  void initState() {
    super.initState();

    ref
        .read(
          requestTypeStateControllerProvider(Modules.transferRequest).future,
        )
        .then((value) {
          setState(() {
            final requestIndex = value?.indexWhere(
              (e) => e.Code == widget.requestTypeCode,
            );
            if (requestIndex == null || requestIndex == -1) {
              return;
            }

            requestTypeAllowChangePrice =
                value![requestIndex].AllowAlterCostOrSalePrice;
          });
        });
  }

  void onTap({
    required int index,
    required ProductEntity product,
    required List<RequestTypeEntity>? requests,
    required TransferRequestProductItemEntity? transferRequestProductItem,
  }) {
    if (product.Value == 0 && !requestTypeAllowChangePrice) {
      showSnackBarMessage(
        context,
        'O produto está com o preço zerado e o modelo de pedido selecionado não permite alterar o preço'
            .hardcoded,
        backgroundColor: Colors.red,
      );
      setState(() {
        selectedIndex = null;
      });
      return;
    }

    if (selectedIndex == index) {
      setState(() {
        selectedIndex = null;
      });
    } else {
      setState(() => selectedIndex = index);
      widget.quantityController.text = '1';
      widget.priceController.text =
          transferRequestProductItem?.value.toString() ??
          product.Value.toString();
      Future.delayed(Duration(milliseconds: 100), () {
        widget.quantityController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: widget.quantityController.text.length,
        );
        widget.quantityFocusNode.requestFocus();
      });
    }
  }

  void removeItem(TransferRequestProductItemEntity productItem) {
    ref
        .read(
          pendingTransferRequestStateControllerProvider(
            DraftKey(
              requestTypeCode: widget.requestTypeCode,
              enterpriseOrigin: widget.enterpriseOriginCode,
              enterpriseDestinyCode: widget.enterpriseDestinyCode,
            ),
          ).notifier,
        )
        .removeItem(productItem);
  }

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
    final requests = ref.watch(
      requestTypeStateControllerProvider(Modules.transferRequest),
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

    return ResponsiveScrollableWidget(
      isSliverPage: true,
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
                child: ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (_, index) {
                    final product = products[index];

                    int? transferProductItemIndex = pendingTransfer.value
                        ?.indexWhere(
                          (element) =>
                              element.product.ProductPackingCode ==
                              product.ProductPackingCode,
                        );

                    bool hasInCart =
                        transferProductItemIndex != null &&
                        transferProductItemIndex != -1;

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
                              removeItem(
                                pendingTransfer
                                    .value![transferProductItemIndex!],
                              );
                            }
                          : null,
                      clickableBottom: hasInCart
                          ? CartQuantityAndTotal(
                              item: pendingTransfer
                                  .value![transferProductItemIndex],
                              requestTypeAllowChangePrice:
                                  requestTypeAllowChangePrice,
                            )
                          : null,
                      notClickableBottom: selectedIndex == index
                          ? FieldsAndInsertButton(
                              requestTypeAllowChangePrice:
                                  requestTypeAllowChangePrice,
                              priceController: widget.priceController,
                              priceFocusNode: widget.priceFocusNode,
                              quantityController: widget.quantityController,
                              quantityFocusNode: widget.quantityFocusNode,
                              product: product,
                              enterpriseDestinyCode:
                                  widget.enterpriseDestinyCode,
                              enterpriseOriginCode: widget.enterpriseOriginCode,
                              requestTypeCode: widget.requestTypeCode,
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
