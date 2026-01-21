import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../../core/presentation/controllers/products/products.dart';
import '../../../../../../utils/utils.dart';
import '../../../../domain/entities/entities.dart';
import '../../../controllers/controllers.dart';
import '../../components/components.dart';

class ProductsItems extends ConsumerStatefulWidget {
  const ProductsItems({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductsItemsState();
}

class _ProductsItemsState extends ConsumerState<ProductsItems> {
  final quantityFormKey = GlobalKey<FormState>();
  final fieldsFormKey = GlobalKey<FormState>();
  final searchProductController = TextEditingController();
  final quantityController = TextEditingController();
  final costController = TextEditingController();
  final quantityFocusNode = FocusNode();
  final costFocusNode = FocusNode();
  static const searchProductKey = SearchProductKey(
    0,
    BsRoutine.buyRequest,
    Modules.buyRequest,
  );

  @override
  void dispose() {
    super.dispose();
    searchProductController.dispose();
    quantityController.dispose();
    costController.dispose();
    quantityFocusNode.dispose();
    costFocusNode.dispose();
  }

  void onTapProduct(int index, ProductEntity product) async {
    quantityController.clear();
    costController.clear();

    ref
        .read(uiStateControllerProvider.notifier)
        .updateSelectedProductIndex(index);

    if ((product.PriceCost!.LiquidCost ?? 0) > 0) {
      costController.text = product.PriceCost!.LiquidCost
          .toString()
          .toBrazilianNumber(4)
          .replaceAll(RegExp(r'\.'), '');
    }

    quantityFocusNode.unfocus();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      quantityFocusNode.requestFocus();
    });
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
        .updatePending(products: products);
  }

  @override
  Widget build(BuildContext context) {
    final selectedEnterprisesCodes = ref.watch(
      pendingBuyRequestStateControllerProvider.select(
        (s) => s.value?.selectedEnterprises?.map((e) => e.Code).toSet() ?? {},
      ),
    );

    return AsyncValueSliverWidget(
      value: ref.watch(searchProductsStateControllerProvider(searchProductKey)),
      tryAgain: null,
      data: (products) {
        final filteredProducts =
            products
                .where(
                  (e) => selectedEnterprisesCodes.contains(e.EnterpriseCode),
                )
                .toList()
              ..sort(
                (a, b) => '${a.Name}${a.PLU}${a.EnterpriseCode}'.compareTo(
                  '${b.Name}${b.PLU}${b.EnterpriseCode}',
                ),
              );

        return ResponsiveListFlow(
          isSliver: true,
          itemCount: filteredProducts.length,
          itemBuilder: (_, index) {
            final product = filteredProducts[index];

            return _ProductItem(
              key: ValueKey(
                '${product.ProductPackingCode}-${product.EnterpriseCode}',
              ),
              product: product,
              index: index,
              onTap: () => onTapProduct(index, product),
              onDelete: () => onDelete(product),
              fieldsFormKey: fieldsFormKey,
              quantityFormKey: quantityFormKey,
              quantityController: quantityController,
              costController: costController,
              quantityFocusNode: quantityFocusNode,
              costFocusNode: costFocusNode,
            );
          },
        );
      },
    );
  }
}

class _ProductItem extends ConsumerWidget {
  final ProductEntity product;
  final int index;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final GlobalKey<FormState> fieldsFormKey;
  final GlobalKey<FormState> quantityFormKey;
  final TextEditingController quantityController;
  final TextEditingController costController;
  final FocusNode quantityFocusNode;
  final FocusNode costFocusNode;

  const _ProductItem({
    super.key,
    required this.product,
    required this.index,
    required this.onTap,
    required this.onDelete,
    required this.fieldsFormKey,
    required this.quantityFormKey,
    required this.quantityController,
    required this.costController,
    required this.quantityFocusNode,
    required this.costFocusNode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected = ref.watch(
      uiStateControllerProvider.select(
        (s) => s.value?.selectedProductIndex == index,
      ),
    );

    final insertedItem = ref.watch(
      pendingBuyRequestStateControllerProvider.select((s) {
        final key = ProductKey(
          enterpriseCode: product.EnterpriseCode!,
          productPackingCode: product.ProductPackingCode!,
        );
        return s.value?.products?[key];
      }),
    );

    return RepaintBoundary(
      child: ProductItemWidget(
        onTap: onTap,
        product: product,
        routine: BsRoutine.buyRequest,
        showDropIcon: true,
        isSelected: isSelected,
        onDelete: insertedItem == null ? null : onDelete,
        itemBeforeProductName: EnterpriseCodeAndProductName(product: product),
        cartItemSummary: insertedItem == null
            ? null
            : CartItemSummary(
                cartQuantity: insertedItem.quantity,
                cartValue: insertedItem.cost,
                product: insertedItem.product,
              ),
        notClickableBottom: isSelected
            ? FieldsAndConfirm(
                isConfirmationPage: false,
                fieldsFormKey: fieldsFormKey,
                quantityFormKey: quantityFormKey,
                quantityController: quantityController,
                costController: costController,
                quantityFocusNode: quantityFocusNode,
                costFocusNode: costFocusNode,
                product: product,
              )
            : null,
      ),
    );
  }
}
