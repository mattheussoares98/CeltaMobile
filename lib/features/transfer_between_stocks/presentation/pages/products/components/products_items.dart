import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../../core/presentation/controllers/products/products.dart';
import '../../../../../../utils/utils.dart';
import '../../../controllers/controllers.dart';
import '../components/components.dart';

class ProductsItems extends ConsumerStatefulWidget {
  final SearchProductKey searchProductKey;
  final int enterpriseCode;
  final GlobalKey<FormState>
  formKey; //receive as param because validate the dropdowns too
  const ProductsItems({
    super.key,
    required this.searchProductKey,
    required this.enterpriseCode,
    required this.formKey,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductsItemsState();
}

class _ProductsItemsState extends ConsumerState<ProductsItems> {
  final quantityController = TextEditingController();
  final quantityFocusNode = FocusNode();

  @override
  void dispose() {
    quantityController.dispose();
    quantityFocusNode.dispose();
    super.dispose();
  }

  Future<void> addInLot(ProductEntity product) async {
    if (widget.formKey.currentState?.validate() != true) {
      return;
    }

    final uiState = ref.read(
      selectedProductUIStateControllerProvider(widget.enterpriseCode),
    );

    ref
        .read(lotStateControllerProvider(widget.enterpriseCode).notifier)
        .addItem(
          product: product,
          quantity: quantityController.text.toDouble() ?? 0,
          selectedDestinyStock: uiState.selectedDestinyStock!,
          selectedJustification: uiState.selectedJustification!,
          selectedOriginStock: uiState.selectedOriginStock!,
        );

    quantityController.clear();
    ref
        .read(
          selectedProductUIStateControllerProvider(
            widget.enterpriseCode,
          ).notifier,
        )
        .updateValues(productIndex: null);
  }

  @override
  Widget build(BuildContext context) {
    return AsyncValueWidget(
      value: ref.watch(
        searchProductsStateControllerProvider(widget.searchProductKey),
      ),
      tryAgain: null,
      data: (products) {
        return ResponsiveListFlow(
          itemCount: products.length,
          itemBuilder: (_, index) {
            final product = products[index];

            return _ProductItem(
              key: ValueKey('product_${product.ProductPackingCode}'),
              enterpriseCode: widget.enterpriseCode,
              product: product,
              index: index,
              quantityController: quantityController,
              quantityFocusNode: quantityFocusNode,
              addInLot: addInLot,
            );
          },
        );
      },
    );
  }
}

class _ProductItem extends ConsumerWidget {
  final int enterpriseCode;
  final ProductEntity product;
  final int index;
  final TextEditingController quantityController;
  final FocusNode quantityFocusNode;
  final Future<void> Function(ProductEntity product) addInLot;
  const _ProductItem({
    super.key,
    required this.enterpriseCode,
    required this.product,
    required this.index,
    required this.quantityController,
    required this.quantityFocusNode,
    required this.addInLot,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final lotItem = ref.watch(
      //TODO every item is rebuilding when lot changes. Need create another controller to receive the quantity in lot
      lotStateControllerProvider(enterpriseCode).select(
        (asyncLot) => asyncLot.value?.firstWhereOrNull(
          (e) => e.product.ProductPackingCode == product.ProductPackingCode,
        ),
      ),
    );

    final isSelected = ref.watch(
      selectedProductUIStateControllerProvider(
        enterpriseCode,
      ).select((s) => s.productIndex == index),
    );

    return ProductItemWidget(
      product: product,
      routine: BsRoutine.adjustStock,
      onTap: () {
        ref
            .read(
              selectedProductUIStateControllerProvider(enterpriseCode).notifier,
            )
            .updateValues(productIndex: index);
        Future.delayed(Duration.zero, () => quantityFocusNode.requestFocus());
        quantityController.clear();
      },
      showDropIcon: true,
      isSelected: isSelected,
      clickableBottom: lotItem == null
          ? null
          : Text(
              '${lotItem.quantity.toString().toBrazilianNumber()} qtds no lote',
              textAlign: TextAlign.start,
              style: theme.textTheme.titleSmall?.copyWith(color: Colors.blue),
            ),
      notClickableBottom: isSelected
          ? Padding(
              padding: const EdgeInsets.only(top: Sizes.p8),
              child: AddInLot(
                productIsAlreadyInLot: lotItem != null,
                addInLot: () => addInLot(product),
                quantityController: quantityController,
                quantityFocusNode: quantityFocusNode,
              ),
            )
          : null,
    );
  }
}
