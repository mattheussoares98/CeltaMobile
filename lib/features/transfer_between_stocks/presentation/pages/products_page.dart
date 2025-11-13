import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../commom_widgets/commom_widgets.dart';
import '../../../../constants/constants.dart';
import '../../../../core/domain/entities/entities.dart';
import '../../../../core/presentation/controllers/products/products.dart';
import '../../../../core/presentation/controllers/stock/stock.dart';
import '../../../../core/presentation/controllers/transfer_justification/transfer_justification.dart';
import '../../domain/entities/entities.dart';
import '../controllers/controllers.dart';
import 'components/components.dart.dart';

class ProductsPage extends ConsumerStatefulWidget {
  final int enterpriseCode;
  final TransferJustificationEntity? selectedJustification;
  final StockTypeEntity? selectedOriginStock;
  final StockTypeEntity? selectedDestinyStock;
  final void Function(TransferJustificationEntity? value) changeJustification;
  final void Function(StockTypeEntity? value) changeOriginStock;
  final void Function(StockTypeEntity? value) changeDestinyStock;
  const ProductsPage({
    super.key,
    required this.enterpriseCode,
    required this.selectedJustification,
    required this.selectedOriginStock,
    required this.selectedDestinyStock,
    required this.changeJustification,
    required this.changeOriginStock,
    required this.changeDestinyStock,
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
            Modules.transferBetweenStocks,
          ).notifier,
        )
        .loadProducts(
          enterpriseCodes: [widget.enterpriseCode],
          searchValue: searchValueController.text,
        );
  }

  void changeSelectedIndex(int index) async {
    if (selectedIndex != index) {
      setState(() {
        selectedIndex = index;
      });
      await Future.delayed(const Duration(milliseconds: 100));
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
        Modules.transferBetweenStocks,
      ),
      (previous, next) {
        next.doOnSuccess(previous, () {
          searchValueController.clear();
        });
      },
    );

    final stocksAsync = ref.watch(
      stockTypeStateControllerProvider(widget.enterpriseCode),
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
              isLoading: ref.watch(
                searchProductsStateControllerProvider(
                  widget.enterpriseCode,
                  BsRoutine.adjustStock,
                  Modules.transferBetweenStocks,
                ).select((state) => state.isLoading),
              ),
              searchProducts: _searchProducts,
            ),
            gapH8,
            JustificationsDropdown(
              selectedJustification: widget.selectedJustification,
              asyncValue: ref.watch(
                transferJustificationStateControllerProvider(
                  widget.enterpriseCode,
                  TransferJustificationType.transferBetweenStocks,
                ),
              ),
              enterpriseCode: widget.enterpriseCode,
              onChanged: (value) {
                widget.changeJustification(value);

                if (value?.CodigoInterno_TipoEstoque != null &&
                    stocksAsync.value != null) {
                  widget.changeOriginStock(
                    stocksAsync.value!.firstWhere(
                      (e) =>
                          e.CodigoInterno_TipoEstoque ==
                          value?.CodigoInterno_TipoEstoque,
                    ),
                  );
                }
              },
            ),
            gapH8,
            OriginStocksDropdown(
              asyncValue: stocksAsync,
              enterpriseCode: widget.enterpriseCode,
              selectedJustification: widget.selectedJustification,
              selectedOriginStock: widget.selectedOriginStock,
              onChanged: widget.changeOriginStock,
            ),
            gapH8,
            DestinyStocksDropdown(
              asyncValue: stocksAsync,
              enterpriseCode: widget.enterpriseCode,
              selectedDestinyStock: widget.selectedDestinyStock,
              selectedOriginStock: widget.selectedOriginStock,
              onChanged: widget.changeDestinyStock,
            ),
            gapH8,
            Flexible(
              child: Consumer(
                builder: (_, ref, _) {
                  final productsState = ref.watch(
                    searchProductsStateControllerProvider(
                      widget.enterpriseCode,
                      BsRoutine.adjustStock,
                      Modules.transferBetweenStocks,
                    ),
                  );
                  return AsyncValueWidget(
                    value: productsState,
                    tryAgain: null,
                    data: (products) {
                      return Consumer(
                        builder: (_, ref, _) {
                          final lotAsync = ref.watch(
                            lotStateControllerProvider(widget.enterpriseCode),
                          );
                          return ResponsiveListFlow(
                            maxItemWidth: 380,
                            itemCount: products.length,
                            itemBuilder: (_, index) {
                              final product = products[index];

                              final productInLotIndex = lotAsync.value
                                  ?.indexWhere(
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
                                        style: theme.textTheme.titleSmall
                                            ?.copyWith(color: Colors.blue),
                                      ),
                                notClickableBottom: selectedIndex == index
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                          top: Sizes.p8,
                                        ),
                                        child: AddInLot(
                                          productIsAlreadyInLot:
                                              lotItem != null,
                                          addInLot: () => addInLot(product),
                                          quantityController:
                                              quantityController,
                                          quantityFocusNode: quantityFocusNode,
                                        ),
                                      )
                                    : null,
                              );
                            },
                          );
                        },
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
