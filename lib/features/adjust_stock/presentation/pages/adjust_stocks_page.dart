import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../commom_widgets/commom_widgets.dart';
import '../../../../constants/constants.dart';
import '../../../../core/domain/entities/entities.dart';
import '../../../../core/presentation/controllers/products/products.dart';
import '../../../../core/presentation/controllers/stock/stock.dart';
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
      await Future.delayed(const Duration(milliseconds: 100));
      quantityFocusNode.requestFocus();
    } else {
      setState(() {
        selectedIndex = null;
      });
    }
  }

  Future<void> confirmAdjust(ProductEntity product) async {
    if (formKey.currentState?.validate() != true) {
      return;
    }

    await ref.read(confirmAdjustStockControllerProvider.notifier).confirm([
      AdjustStockItemEntity(
        EnterpriseCode: widget.enterpriseCode,
        ProductCode: product.ProductCode!,
        ProductPackingCode: product.ProductPackingCode!,
        JustificationCode: selectedJustification!.CodigoInterno_JustMov,
        StockTypeCode: selectedStockType!.CodigoInterno_TipoEstoque!,
        StockTypeRecipientCode: null,
        IsPendingAdjust: false,
        Quantity: quantityController.text.toDouble() ?? 0,
      ),
    ]);
  }

  void onChangeJustification(TransferJustificationEntity? value) async {
    setState(() {
      selectedJustification = value;
    });

    final stocks = await ref.read(
      stockTypeStateControllerProvider(widget.enterpriseCode).future,
    );

    if (value?.CodigoInterno_TipoEstoque != null) {
      setState(() {
        selectedStockType = stocks.firstWhere(
          (e) =>
              e.CodigoInterno_TipoEstoque == value?.CodigoInterno_TipoEstoque,
        );
      });
    }
  }

  void onChangeStock(StockTypeEntity? value) {
    setState(() {
      selectedStockType = value;
    });
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
                  HeaderFilters(
                    enterpriseCode: widget.enterpriseCode,
                    searchProducts: _searchProducts,
                    searchValueController: searchValueController,
                    selectedJustification: selectedJustification,
                    selectedStockType: selectedStockType,
                    onChangeJustification: onChangeJustification,
                    onChangeStockType: onChangeStock,
                  ),
                  Expanded(
                    child: Consumer(
                      builder: (_, ref, _) {
                        final productsState = ref.watch(
                          searchProductsStateControllerProvider(
                            widget.enterpriseCode,
                            BsRoutine.adjustStock,
                            Modules.adjustStock,
                          ),
                        );
                        return AsyncValueWidget(
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
                                          onConfirm: () =>
                                              confirmAdjust(product),
                                          quantityController:
                                              quantityController,
                                          quantityFocusNode: quantityFocusNode,
                                        )
                                      : null,
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
          ),
        ),
        LoadingPage(providers: [confirmAdjustStockControllerProvider]),
      ],
    );
  }
}
