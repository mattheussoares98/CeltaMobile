import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../../utils/utils.dart';
import '../../../../domain/entities/entities.dart';
import '../../../controllers/controllers.dart';
import '../../components/components.dart';

class InformedProducts extends ConsumerStatefulWidget {
  const InformedProducts({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _InformedProductsState();
}

class _InformedProductsState extends ConsumerState<InformedProducts> {
  final fieldsFormKey = GlobalKey<FormState>();
  final quantityFormKey = GlobalKey<FormState>();
  final quantityController = TextEditingController();
  final costController = TextEditingController();
  final quantityFocusNode = FocusNode();
  final costFocusNode = FocusNode();

  @override
  void dispose() {
    quantityController.dispose();
    costController.dispose();
    quantityFocusNode.dispose();
    costFocusNode.dispose();
    super.dispose();
  }

  void onDelete(ProductEntity product) {
    final products = ref.read(
      pendingBuyRequestStateControllerProvider.select((s) => s.value?.products),
    );

    final updatedProducts = {...?products};
    updatedProducts.removeWhere((key, value) {
      return key ==
          ProductKey(
            enterpriseCode: product.EnterpriseCode!,
            productPackingCode: product.ProductPackingCode!,
          );
    });

    ref
        .read(pendingBuyRequestStateControllerProvider.notifier)
        .updatePending(products: updatedProducts);
  }

  void onTap(int index, BuyRequestProductItemEntity product) {
    costController.text = product.cost
        .toString()
        .toBrazilianNumber(4)
        .replaceAll(RegExp(r'\.'), '');
    quantityController.text = product.quantity
        .toString()
        .toBrazilianNumber(3, true)
        .replaceAll(RegExp(r'\.'), '');
    quantityController.selection = TextSelection(
      baseOffset: 0,
      extentOffset: quantityController.text.length,
    );
    ref
        .read(uiStateControllerProvider.notifier)
        .updateSelectedCartProductIndex(index);

    FocusManager.instance.primaryFocus?.unfocus();
    quantityFocusNode.unfocus();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      quantityFocusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(
      pendingBuyRequestStateControllerProvider.select(
        (s) => s.value?.products?.values,
      ),
    );

    final count = products?.length ?? 0;
    return ResponsiveListFlow(
      isSliver: true,
      itemCount: count,
      itemBuilder: (_, index) {
        final product = products!.elementAt(index);

        return _ProductItem(
          key: ValueKey(
            '${product.product.ProductPackingCode}${product.product.EnterpriseCode}',
          ),
          isLastItem: index == count - 1,
          product: product,
          index: index,
          onDelete: () => onDelete(product.product),
          onTap: () => onTap(index, product),
          fieldsFormKey: fieldsFormKey,
          quantityFormKey: quantityFormKey,
          quantityController: quantityController,
          costController: costController,
          quantityFocusNode: quantityFocusNode,
          costFocusNode: costFocusNode,
        );
      },
    );
  }
}

class _ProductItem extends ConsumerWidget {
  final BuyRequestProductItemEntity product;
  final int index;
  final VoidCallback onDelete;
  final VoidCallback onTap;
  final GlobalKey<FormState> fieldsFormKey;
  final GlobalKey<FormState> quantityFormKey;
  final TextEditingController quantityController;
  final TextEditingController costController;
  final FocusNode quantityFocusNode;
  final FocusNode costFocusNode;
  final bool isLastItem;
  const _ProductItem({
    super.key,
    required this.product,
    required this.index,
    required this.onDelete,
    required this.onTap,
    required this.fieldsFormKey,
    required this.quantityFormKey,
    required this.quantityController,
    required this.costController,
    required this.quantityFocusNode,
    required this.costFocusNode,
    required this.isLastItem,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected = ref.watch(
      uiStateControllerProvider.select(
        (s) => s.value?.selectedCartProductIndex == index,
      ),
    );
    return RepaintBoundary(
      child: Padding(
        padding: EdgeInsets.only(bottom: isLastItem ? Sizes.p80 : 0),
        child: ProductItemWidget(
          product: product.product,
          routine: BsRoutine.buyRequest,
          hideCost: true,
          hideCurrentAndSaleStocks: true,
          hideWholeInformations: true,
          showDropIcon: true,
          showInfoButton: false,
          isSelected: isSelected,
          onTap: onTap,
          cartItemSummary: CartItemSummary(
            cartQuantity: product.quantity,
            cartValue: product.cost,
            product: product.product,
            priceDecimalHouses: 4,
          ),
          onDelete: onDelete,
          itemBeforeProductName: EnterpriseCodeAndProductName(
            product: product.product,
          ),
          notClickableBottom: isSelected
              ? FieldsAndConfirm(
                  isConfirmationPage: true,
                  fieldsFormKey: fieldsFormKey,
                  quantityFormKey: quantityFormKey,
                  quantityController: quantityController,
                  costController: costController,
                  quantityFocusNode: quantityFocusNode,
                  costFocusNode: costFocusNode,
                  product: product.product,
                )
              : null,
        ),
      ),
    );
  }
}
