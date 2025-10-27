import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../core/presentation/controllers/request_type/request_type.dart';
import '../../../../enterprise_manager/domain/entities/entities.dart';
import '../../controllers/controllers.dart';
import 'components/components.dart';

class InsertProductsPage extends ConsumerStatefulWidget {
  final int enterpriseOriginCode;
  final int enterpriseDestinyCode;
  final int requestTypeCode;
  final TextEditingController searchValueController;
  final FocusNode searchValueFocusNode;
  final TextEditingController quantityController;
  final FocusNode quantityFocusNode;
  const InsertProductsPage({
    super.key,
    required this.enterpriseOriginCode,
    required this.enterpriseDestinyCode,
    required this.requestTypeCode,
    required this.searchValueController,
    required this.searchValueFocusNode,
    required this.quantityController,
    required this.quantityFocusNode,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _InsertProductsPageState();
}

class _InsertProductsPageState extends ConsumerState<InsertProductsPage> {
  int? selectedIndex;

  void onTap({
    required int index,
    required ProductEntity product,
    required List<RequestTypeEntity>? requests,
  }) {
    final selectedRequestType = requests?.indexWhere(
      (e) => e.Code == widget.requestTypeCode,
    );
    if (selectedRequestType == null || selectedRequestType == -1) {
      showSnackBarMessage(
        context,
        'Erro não esperado. Chame o suporte técnico'.hardcoded,
        backgroundColor: Colors.red,
      );
      setState(() {
        selectedIndex = null;
      });
      return;
    } else if (product.Value == 0 &&
        !requests![selectedRequestType].AllowAlterCostOrSalePrice) {
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
      Future.delayed(Duration(milliseconds: 100), () {
        widget.quantityFocusNode.requestFocus();
      });
    }
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

                    return ProductItemWidget(
                      product: product,
                      routine: BsRoutine.transferRequest,
                      isSelected: selectedIndex == index,
                      showDropIcon: true,
                      onTap: () => onTap(
                        index: index,
                        product: product,
                        requests: requests.value,
                      ),
                      notClickableBottom: selectedIndex == index
                          ? QuantityFieldAndInsertButton(
                              quantityController: widget.quantityController,
                              quantityFocusNode: widget.quantityFocusNode,
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
