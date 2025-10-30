import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../commom_widgets/commom_widgets.dart';
import '../../../../constants/constants.dart';
import '../../../../core/domain/entities/entities.dart';
import '../../../../core/presentation/controllers/products/products.dart';
import '../../../../core/presentation/controllers/stock/stock.dart';
import '../../../../core/presentation/controllers/transfer_justification/transfer_justification.dart';
import 'components/components.dart';

class AdjustStocksPage extends ConsumerStatefulWidget {
  final int enterpriseCode;
  const AdjustStocksPage({super.key, required this.enterpriseCode});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AdjustStocksPageState();
}

class _AdjustStocksPageState extends ConsumerState<AdjustStocksPage> {
  final searchValueController = TextEditingController();
  final quantityController = TextEditingController();
  final quantityFocusNode = FocusNode();
  TransferJustificationEntity? selectedJustification;
  StockTypeEntity? selectedStockType;
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
            Modules.adjustStock,
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
      await Future.delayed(Duration(milliseconds: 100));
      quantityFocusNode.requestFocus();
    } else {
      setState(() {
        selectedIndex = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      searchProductsStateControllerProvider(
        widget.enterpriseCode,
        BsRoutine.adjustStock,
        Modules.adjustStock,
      ),
      (previous, next) {
        next.doOnSuccess(previous, () {
          searchValueController.clear();
        });
      },
    );
    ref.listen(confirmAdjustStockControllerProvider, (p, n) {
      n.showAlertDialogOnError(context);
      n.showSnackbarOnSuccess(
        context,
        previous: p,
        message: 'Ajuste efetuado com sucesso'.hardcoded,
      );
      n.doOnSuccess(p, () {
        quantityController.clear();
        setState(() {
          selectedIndex = null;
        });
      });
    });

    final productsState = ref.watch(
      searchProductsStateControllerProvider(
        widget.enterpriseCode,
        BsRoutine.adjustStock,
        Modules.adjustStock,
      ),
    );

    final stocksAsync = ref.watch(
      stockTypeStateControllerProvider(widget.enterpriseCode),
    );

    final justificationsAsync = ref.watch(
      transferJustificationStateControllerProvider(
        widget.enterpriseCode,
        TransferJustificationType.adjustStock,
      ),
    );

    final confirmAdjustStockAsync = ref.watch(
      confirmAdjustStockControllerProvider,
    );

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: FittedBox(child: Text("Ajuste de estoque".hardcoded)),
          ),
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
                  gapH8,
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
                          selectedStockType = stocksAsync.value!.firstWhere(
                            (e) =>
                                e.CodigoInterno_TipoEstoque ==
                                value?.CodigoInterno_TipoEstoque,
                          );
                        });
                      }
                    },
                  ),
                  gapH8,
                  StocksDropdown(
                    asyncValue: stocksAsync,
                    enterpriseCode: widget.enterpriseCode,
                    selectedJustification: selectedJustification,
                    selectedStockType: selectedStockType,
                    onChanged: (value) {
                      setState(() {
                        selectedStockType = value;
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
                          itemCount: products.length,
                          itemBuilder: (_, index) {
                            final product = products[index];
                            return ProductItemWidget(
                              product: product,
                              routine: BsRoutine.adjustStock,
                              onTap: () {
                                changeSelectedIndex(index);
                              },
                              showDropIcon: true,
                              isSelected: selectedIndex == index,
                              notClickableBottom: selectedIndex == index
                                  ? ConfirmAdjustStock(
                                      product: product,
                                      formKey: formKey,
                                      enterpriseCode: widget.enterpriseCode,
                                      selectedJustification:
                                          selectedJustification,
                                      selectedStockType: selectedStockType,
                                      quantityController: quantityController,
                                      isLoading:
                                          confirmAdjustStockAsync.isLoading,
                                      quantityFocusNode: quantityFocusNode,
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
          ),
        ),
        if (confirmAdjustStockAsync.isLoading) LoadingPage(),
      ],
    );
  }
}
