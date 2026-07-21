import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/products/products.dart';
import 'package:celta_inventario/features/transfer_between_stocks/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/transfer_between_stocks/presentation/pages/products/components/components.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

    FocusManager.instance.primaryFocus?.unfocus();

    final uiState = ref.read(
      selectedProductUIStateControllerProvider(widget.enterpriseCode),
    );

    if (uiState.selectedDestinyStock == null ||
        uiState.selectedJustification == null ||
        uiState.selectedOriginStock == null) {
      return;
    }

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
        .updateProductIndex(null);
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
              addInLot: () => addInLot(product),
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
  final VoidCallback addInLot;
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

    return ProductItemWidget(
      product: product,
      routine: BsRoutine.adjustStock,
      onDelete: quantityInLot == null
          ? null
          : () {
              ref
                  .read(lotStateControllerProvider(enterpriseCode).notifier)
                  .removeItem(product.ProductPackingCode!);
            },
      onTap: () {
        ref
            .read(
              selectedProductUIStateControllerProvider(enterpriseCode).notifier,
            )
            .updateProductIndex(index);

        quantityController.clear();
        quantityFocusNode.unfocus();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          quantityFocusNode.requestFocus();
        });
      },
      showEditIcon: true,
      isSelected: isSelected,
      clickableBottom: quantityInLot == null
          ? null
          : Text(
              '${quantityInLot.toString().toBrazilianNumber()} qtds no lote',
              textAlign: TextAlign.start,
              style: context.theme.textTheme.titleSmall?.copyWith(
                color: Colors.blue,
              ),
            ),
      notClickableBottom: isSelected
          ? AddInLot(
              productIsAlreadyInLot: quantityInLot != null,
              addInLot: addInLot,
              quantityController: quantityController,
              quantityFocusNode: quantityFocusNode,
            )
          : null,
    );
  }
}
