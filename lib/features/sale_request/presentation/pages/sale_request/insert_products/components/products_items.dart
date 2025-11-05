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
  final void Function(ProductEntity product, CartProductEntity? cartProduct)
  onTapProduct;
  final TextEditingController quantityController;
  final TextEditingController priceController;
  final TextEditingController discountController;
  final FocusNode quantityFocusNode;
  final FocusNode priceFocusNode;
  final FocusNode discountFocusNode;
  final RequestTypeEntity selectedRequest;
  const ProductsItems({
    super.key,
    required this.enterpriseCode,
    required this.onTapProduct,
    required this.quantityController,
    required this.priceController,
    required this.discountController,
    required this.quantityFocusNode,
    required this.priceFocusNode,
    required this.discountFocusNode,
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
  ) async {
    if (formKey.currentState?.validate() != true) {
      return;
    }

    double quantity = widget.quantityController.text.toDouble() ?? 0;
    double? discount = widget.discountController.text.toDouble();
    if (cartProduct != null) {
      quantity += cartProduct.Quantity;
    }

    double value = widget.priceController.text.toDouble() ?? product.getPrice;
    final discountType = ref.read(selectedDiscountTypeControllerProvider).value;

    final updated = await ref
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

    if (!updated) return;

    widget.quantityController.clear();
    widget.discountController.clear();
    ref
        .read(selectedProductPackingCodeControllerProvider(false).notifier)
        .updateSelectedCode(
          null,
        ); //TODO change this to the controller that add the product and create test
  }

  @override
  Widget build(BuildContext context) {
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
