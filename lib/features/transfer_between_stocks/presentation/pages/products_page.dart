import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../commom_widgets/commom_widgets.dart';
import '../../../../constants/constants.dart';
import '../../../../core/domain/entities/entities.dart';
import '../../../../core/presentation/controllers/products/products.dart';
import '../../domain/entities/entities.dart';
import '../controllers/controllers.dart';
import 'components/components.dart.dart';

class ProductsPage extends ConsumerStatefulWidget {
  final int enterpriseCode;
  final EnterpriseEntity? selectedEnterprise;
  final TransferJustificationEntity? selectedJustification;
  final StockTypeEntity? selectedOriginStock;
  final StockTypeEntity? selectedDestinyStock;
  final void Function(TransferJustificationEntity? value) changeJustification;
  final void Function(StockTypeEntity? value) changeOriginStock;
  final void Function(StockTypeEntity? value) changeDestinyStock;
  final AsyncValue<List<StockTypeEntity>> stocksAsync;
  final AsyncValue<List<TransferJustificationEntity>> justificationsAsync;
  const ProductsPage({
    super.key,
    required this.enterpriseCode,
    required this.selectedEnterprise,
    required this.selectedJustification,
    required this.selectedOriginStock,
    required this.selectedDestinyStock,
    required this.changeJustification,
    required this.changeOriginStock,
    required this.changeDestinyStock,
    required this.stocksAsync,
    required this.justificationsAsync,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductsPageState();
}

class _ProductsPageState extends ConsumerState<ProductsPage> {
  final searchValueController = TextEditingController();
  final quantityController = TextEditingController();
  final quantityFocusNode = FocusNode();
  int? selectedIndex;
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();

    searchValueController.dispose();
    quantityController.dispose();
    quantityFocusNode.dispose();
  }

  Future<void> _searchProducts() async {
    await ref
        .read(
          searchProductsStateControllerProvider(
            widget.enterpriseCode,
            BsRoutine.adjustStock,
          ).notifier,
        )
        .loadProducts(
          enterpriseCode: widget.enterpriseCode,
          searchValue: searchValueController.text,
          selectedEnterprise: widget.selectedEnterprise,
        );
  }

  void changeSelectedIndex(int index) async {
    if (selectedIndex != index) {
      setState(() {
        selectedIndex = index;
      });
      await Future.delayed(Duration(milliseconds: 100));
      quantityFocusNode.requestFocus();
    } else {
      setState(() {
        selectedIndex = null;
      });
    }
  }

  Future<void> addInLot(ProductEntity product) async {
    if (formKey.currentState?.validate() != true) {
      return;
    }

    ref
        .read(lotStateControllerProvider(widget.enterpriseCode).notifier)
        .addItem(
          ProductLotInfoEntity(
            product: product,
            selectedJustification: widget.selectedJustification!,
            selectedOriginStock: widget.selectedOriginStock!,
            selectedDestinyStock: widget.selectedDestinyStock!,
            quantity: quantityController.text.toDouble() ?? 0,
          ),
        );

    quantityController.clear();
    setState(() {
      selectedIndex = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      searchProductsStateControllerProvider(
        widget.enterpriseCode,
        BsRoutine.adjustStock,
      ),
      (previous, next) {
        next.doOnSuccess(previous, () {
          searchValueController.clear();
        });
      },
    );

    final productsState = ref.watch(
      searchProductsStateControllerProvider(
        widget.enterpriseCode,
        BsRoutine.adjustStock,
      ),
    );

    final lotAsync = ref.watch(
      lotStateControllerProvider(widget.enterpriseCode),
    );

    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(Sizes.p8),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            DefaultSearchProducts(
              searchValueController: searchValueController,
              isLoading: productsState.isLoading,
              searchProducts: _searchProducts,
            ),
            JustificationsDropdown(
              selectedJustification: widget.selectedJustification,
              asyncValue: widget.justificationsAsync,
              enterpriseCode: widget.enterpriseCode,
              onChanged: (value) {
                widget.changeJustification(value);

                if (value?.CodigoInterno_TipoEstoque != null &&
                    widget.stocksAsync.value != null) {
                  widget.changeOriginStock(
                    widget.stocksAsync.value!.firstWhere(
                      (e) =>
                          e.CodigoInterno_TipoEstoque ==
                          value?.CodigoInterno_TipoEstoque,
                    ),
                  );
                }
              },
            ),
            OriginStocksDropdown(
              asyncValue: widget.stocksAsync,
              enterpriseCode: widget.enterpriseCode,
              selectedJustification: widget.selectedJustification,
              selectedOriginStock: widget.selectedOriginStock,
              onChanged: widget.changeOriginStock,
            ),
            DestinyStocksDropdown(
              asyncValue: widget.stocksAsync,
              enterpriseCode: widget.enterpriseCode,
              selectedDestinyStock: widget.selectedDestinyStock,
              selectedOriginStock: widget.selectedOriginStock,
              onChanged: widget.changeDestinyStock,
            ),
            gapH8,
            Flexible(
              child: AsyncValueWidget(
                value: productsState,
                tryAgain: null,
                data: (products) {
                  return ResponsiveListFlow(
                    maxItemWidth: 380,
                    itemCount: products.length,
                    itemBuilder: (_, index) {
                      final product = products[index];

                      final productInLotIndex = lotAsync.value?.indexWhere(
                        (e) =>
                            e.product.ProductPackingCode ==
                            product.ProductPackingCode,
                      );
                      ProductLotInfoEntity? lotItem;
                      if (productInLotIndex != -1 &&
                          productInLotIndex != null) {
                        lotItem = lotAsync.value?[productInLotIndex];
                      }

                      return ProductItemWidget(
                        enterpriseCode: widget.enterpriseCode,
                        product: product,
                        routine: BsRoutine.adjustStock,
                        onTap: () {
                          changeSelectedIndex(index);
                        },
                        showDropIcon: true,
                        isSelected: selectedIndex == index,
                        clickableBottom: lotItem == null
                            ? null
                            : Text(
                                '${lotItem.quantity.toString().toBrazilianNumber()} qtds no lote',
                                textAlign: TextAlign.start,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  color: Colors.blue,
                                ),
                              ),
                        notClickableBottom: selectedIndex == index
                            ? Padding(
                                padding: const EdgeInsets.only(top: Sizes.p8),
                                child: AddInLot(
                                  addInLot: () => addInLot(product),
                                  quantityController: quantityController,
                                  quantityFocusNode: quantityFocusNode,
                                ),
                              )
                            : null,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
