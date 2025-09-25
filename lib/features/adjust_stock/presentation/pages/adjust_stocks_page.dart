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
import '../../../../core/providers/stock/stock.dart';
import '../../../../core/providers/transfer_justification/transfer_justification.dart';

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

    final stocksState = ref.watch(
      stockTypeStateControllerProvider(widget.enterpriseCode),
    );
    final transferJustificationState = ref.watch(
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
              mainAxisAlignment:
                  stocksState.hasError || transferJustificationState.hasError
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              children: [
                if (stocksState.hasError || transferJustificationState.hasError)
                  Center(
                    child: PrimaryTextButton(
                      text: 'Carregar justificativas e estoques'.hardcoded,
                      onPressed: () {
                        if (stocksState.hasError) {
                          ref.invalidate(
                            soapTransferJustificationRepositoryProvider,
                          );
                        }
                        if (transferJustificationState.hasError) {
                          ref.invalidate(soapStockTypeRepositoryProvider);
                        }
                      },
                    ),
                  )
                else ...[
                  DefaultSearchProducts(
                    searchValueController: searchValueController,
                    isLoading:
                        productsState.isLoading ||
                        stocksState.isLoading ||
                        transferJustificationState.isLoading ||
                        stocksState.hasError ||
                        transferJustificationState.hasError,
                    searchProducts: _searchProducts,
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
              ],
            ),
          ),
        ),
        if (productsState.isLoading ||
            stocksState.isLoading ||
            transferJustificationState.isLoading)
          LoadingPage(),
      ],
    );
  }
}
