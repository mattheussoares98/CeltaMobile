import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../commom_widgets/commom_widgets.dart';
import '../../../../constants/constants.dart';
import '../../../../core/domain/entities/entities.dart';
import '../../../../core/presentation/controllers/products/products.dart';
import '../../../../core/presentation/controllers/stock/stock.dart';
import '../../../../core/presentation/controllers/transfer_justification/transfer_justification.dart';
import '../controllers/controllers.dart';
import 'components/components.dart.dart';

class ProductsPage extends ConsumerStatefulWidget {
  final int enterpriseCode;
  final EnterpriseEntity? selectedEnterprise;
  const ProductsPage({
    super.key,
    required this.enterpriseCode,
    required this.selectedEnterprise,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductsPageState();
}

class _ProductsPageState extends ConsumerState<ProductsPage> {
  final searchValueController = TextEditingController();
  final quantityController = TextEditingController();
  final quantityFocusNode = FocusNode();
  TransferJustificationEntity? selectedJustification;
  StockTypeEntity? selectedOriginStock;
  StockTypeEntity? selectedDestinyStock;
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
          AdjustStockItemEntity(
            EnterpriseCode: product.EnterpriseCode,
            ProductCode: product.ProductCode,
            ProductPackingCode: product.ProductPackingCode,
            JustificationCode: selectedJustification!.CodigoInterno_JustMov,
            StockTypeCode: selectedOriginStock!.CodigoInterno_TipoEstoque!,
            StockTypeRecipientCode:
                selectedDestinyStock!.CodigoInterno_TipoEstoque,
            IsPendingAdjust: false,
            Quantity: quantityController.text.toDouble() ?? 0,
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

    final stocksAsync = ref.watch(
      stockTypeStateControllerProvider(widget.enterpriseCode),
    );

    final justificationsAsync = ref.watch(
      transferJustificationStateControllerProvider(
        widget.enterpriseCode,
        TransferJustificationType.transferBetweenStocks,
      ),
    );

    final confirmAdjustStockAsync = ref.watch(
      confirmAdjustStockControllerProvider,
    );

    final lotAsync = ref.watch(
      lotStateControllerProvider(widget.enterpriseCode),
    );

    return Stack(
      children: [
        Scaffold(
          body: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(Sizes.p4),
              child: Column(
                children: [
                  DefaultSearchProducts(
                    searchValueController: searchValueController,
                    isLoading: productsState.isLoading,
                    searchProducts: _searchProducts,
                  ),
                  JustificationsDropdown(
                    selectedJustification: selectedJustification,
                    asyncValue: justificationsAsync,
                    enterpriseCode: widget.enterpriseCode,
                    onChanged: (value) {
                      setState(() {
                        selectedJustification = value;
                      });

                      if (value?.CodigoInterno_TipoEstoque != null &&
                          stocksAsync.value != null) {
                        setState(() {
                          selectedOriginStock = stocksAsync.value!.firstWhere(
                            (e) =>
                                e.CodigoInterno_TipoEstoque ==
                                value?.CodigoInterno_TipoEstoque,
                          );
                        });
                      }
                    },
                  ),
                  OriginStocksDropdown(
                    asyncValue: stocksAsync,
                    enterpriseCode: widget.enterpriseCode,
                    selectedJustification: selectedJustification,
                    selectedOriginStock: selectedOriginStock,
                    onChanged: (value) {
                      setState(() {
                        selectedOriginStock = value;
                      });
                    },
                  ),
                  DestinyStocksDropdown(
                    asyncValue: stocksAsync,
                    enterpriseCode: widget.enterpriseCode,
                    selectedDestinyStock: selectedDestinyStock,
                    selectedOriginStock: selectedOriginStock,
                    onChanged: (value) {
                      setState(() {
                        selectedDestinyStock = value;
                      });
                    },
                  ),
                  gapH8,
                  Expanded(
                    child: AsyncValueWidget(
                      value: productsState,
                      tryAgain: null,
                      data: (products) {
                        return ResponsiveListFlow(
                          maxItemWidth: 380,
                          itemCount: products.length,
                          itemBuilder: (_, index) {
                            final product = products[index];

                            final productInLotIndex = lotAsync.value
                                ?.indexWhere(
                                  (e) =>
                                      e.ProductPackingCode ==
                                      product.ProductPackingCode,
                                );
                            AdjustStockItemEntity? lotItem;
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
                              bottom: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  if (lotItem != null)
                                    Text(
                                      '${lotItem.Quantity.toString().toBrazilianNumber(3)} qts no lote',
                                      textAlign: TextAlign.start,
                                    ),
                                  if (selectedIndex == index)
                                    AddInLot(
                                      addInLot: () => addInLot(product),
                                      quantityController: quantityController,
                                      isLoading:
                                          confirmAdjustStockAsync.isLoading,
                                      quantityFocusNode: quantityFocusNode,
                                    ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (confirmAdjustStockAsync.isLoading) LoadingPage(),
      ],
    );
  }
}
