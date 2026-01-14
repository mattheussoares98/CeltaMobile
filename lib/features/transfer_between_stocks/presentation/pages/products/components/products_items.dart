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
              formKey: widget.formKey,
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
  final GlobalKey<FormState> formKey;
  const _ProductItem({
    super.key,
    required this.enterpriseCode,
    required this.product,
    required this.index,
    required this.quantityController,
    required this.quantityFocusNode,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    Future<void> addInLot(ProductEntity product) async {
      if (formKey.currentState?.validate() != true) {
        return;
      }

      final uiState = ref.read(
        selectedProductUIStateControllerProvider(enterpriseCode),
      );

      ref
          .read(lotStateControllerProvider(enterpriseCode).notifier)
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
            selectedProductUIStateControllerProvider(enterpriseCode).notifier,
          )
          .updateProductIndex(null);
    }

    final isSelected = ref.watch(
      selectedProductUIStateControllerProvider(
        enterpriseCode,
      ).select((s) => s.productIndex == index),
    );

    final quantityInLot = ref.watch(
      quantityInLotStateControllerProvider(
        enterpriseCode,
        product.ProductPackingCode!,
      ),
    );

    return RepaintBoundary(
      child: ProductItemWidget(
        product: product,
        routine: BsRoutine.adjustStock,
        onTap: () {
          ref
              .read(
                selectedProductUIStateControllerProvider(
                  enterpriseCode,
                ).notifier,
              )
              .updateProductIndex(index);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (quantityFocusNode.canRequestFocus) {
              quantityFocusNode.requestFocus();
            }
          });
          quantityController.clear();
        },
        showDropIcon: true,
        isSelected: isSelected,
        clickableBottom: quantityInLot == null
            ? null
            : Text(
                '${quantityInLot.toString().toBrazilianNumber()} qtds no lote',
                textAlign: TextAlign.start,
                style: theme.textTheme.titleSmall?.copyWith(color: Colors.blue),
              ),
        notClickableBottom: isSelected
            ? Padding(
                padding: const EdgeInsets.only(top: Sizes.p8),
                child: AddInLot(
                  productIsAlreadyInLot: quantityInLot != null,
                  addInLot: () => addInLot(product),
                  quantityController: quantityController,
                  quantityFocusNode: quantityFocusNode,
                ),
              )
            : null,
      ),
    );
  }
}
