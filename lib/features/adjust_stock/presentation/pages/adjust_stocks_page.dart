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
  final EnterpriseEntity? selectedEnterprise;
  const AdjustStocksPage({
    super.key,
    required this.enterpriseCode,
    required this.selectedEnterprise,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AdjustStocksPageState();
}

class _AdjustStocksPageState extends ConsumerState<AdjustStocksPage> {
  final searchValueController = TextEditingController();
  TransferJustificationEntity? selectedJustification;
  StockTypeEntity? selectedStockType;

  @override
  void dispose() {
    super.dispose();

    searchValueController.dispose();
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
        TransferJustificationType.adjustStock,
      ),
    );

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: FittedBox(child: Text("Ajuste de estoque".hardcoded)),
          ),
          body: Padding(
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
                            enterpriseCode: widget.enterpriseCode,
                            product: product,
                            routine: BsRoutine.adjustStock,
                            bottom: Text(
                              'open option to adjust stock'.hardcoded,
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
        //TODO only when is confirming
        if (1 == 2) LoadingPage(),
      ],
    );
  }
}
