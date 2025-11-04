import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../core/domain/entities/entities.dart';
import '../../../../../../../core/presentation/controllers/products/products.dart';
import '../../../../../domain/entities/entities.dart';
import '../../../../controllers/controllers.dart';
import 'components.dart';

class ProductsItems extends ConsumerStatefulWidget {
  final int enterpriseCode;
  final int? selectedIndex;
  final void Function(
    int? index,
    ProductEntity product,
    CartProductEntity? cartProduct,
  )
  onTapProduct;
  final TextEditingController quantityController;
  final TextEditingController priceController;
  final TextEditingController discountController;
  final FocusNode quantityFocusNode;
  final FocusNode priceFocusNode;
  final FocusNode discountFocusNode;
  final VoidCallback removeSelectedIndex;
  final RequestTypeEntity selectedRequest;
  const ProductsItems({
    super.key,
    required this.enterpriseCode,
    required this.selectedIndex,
    required this.onTapProduct,
    required this.quantityController,
    required this.priceController,
    required this.discountController,
    required this.quantityFocusNode,
    required this.priceFocusNode,
    required this.discountFocusNode,
    required this.removeSelectedIndex,
    required this.selectedRequest,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductsItemsState();
}

class _ProductsItemsState extends ConsumerState<ProductsItems> {
  final formKey = GlobalKey<FormState>();
  void insertProduct(
    ProductEntity product,
    CartProductEntity? cartProduct,
    PercentageOrValue? discountType,
  ) {
    if (formKey.currentState?.validate() != true) {
      return;
    }

    double quantity = widget.quantityController.text.toDouble() ?? 0;
    double? discount = widget.discountController.text.toDouble();
    if (cartProduct != null) {
      quantity += cartProduct.Quantity;
    }

    double value = widget.priceController.text.toDouble() ?? product.getPrice;

    ref
        .read(pendingSaleRequestStateControllerProvider.notifier)
        .addProduct(
          CartProductEntity.create(
            quantity: quantity,
            price: value,
            discountByItem: discount,
            discountType: discountType,
            product: product,
          ),
        );

    widget.quantityController.clear();
    widget.removeSelectedIndex();
    widget.discountController.clear();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      searchProductsStateControllerProvider(
        widget.enterpriseCode,
        BsRoutine.saleRequest,
        Modules.saleRequest,
      ),
      (p, n) {
        n.doOnSuccess(p, () {
          widget.removeSelectedIndex();
        });
      },
    );

    return Form(
      key: formKey,
      child: AsyncValueWidget(
        value: ref.watch(
          searchProductsStateControllerProvider(
            widget.enterpriseCode,
            BsRoutine.saleRequest,
            Modules.saleRequest,
          ),
        ),
        tryAgain: null,
        data: (products) {
          return ResponsiveListFlow(
            itemCount: products.length,
            itemBuilder: (_, index) {
              final product = products[index];

              return ProductItem(
                product: product,
                index: index,
                selectedIndex: widget.selectedIndex,
                onTapProduct: widget.onTapProduct,
                insertProduct: insertProduct,
                selectedRequest: widget.selectedRequest,
                productsItemsWidget: widget,
              );
            },
          );
        },
      ),
    );
  }
}
