import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../commom_widgets/commom_widgets.dart';
import '../../../../constants/constants.dart';
import '../../../../core/domain/entities/entities.dart';
import '../../../../core/presentation/controllers/stock/stock.dart';
import '../../../../core/presentation/controllers/transfer_justification/transfer_justification.dart';
import '../controllers/controllers.dart';
import 'pages.dart';

class TransferBetweenStocksPage extends ConsumerStatefulWidget {
  final int enterpriseCode;

  const TransferBetweenStocksPage({super.key, required this.enterpriseCode});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TransferBetweenStocksPageState();
}

class _TransferBetweenStocksPageState
    extends ConsumerState<TransferBetweenStocksPage> {
  int currentIndex = 0;
  final pageController = PageController();

  TransferJustificationEntity? selectedJustification;
  StockTypeEntity? selectedOriginStock;
  StockTypeEntity? selectedDestinyStock;

  @override
  void dispose() {
    pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIos = theme.platform == TargetPlatform.iOS;

    final stocksAsync = ref.watch(
      stockTypeStateControllerProvider(widget.enterpriseCode),
    );

    final justificationsAsync = ref.watch(
      transferJustificationStateControllerProvider(
        widget.enterpriseCode,
        TransferJustificationType.transferBetweenStocks,
      ),
    );

    final pages = [
      ProductsPage(
        enterpriseCode: widget.enterpriseCode,
        selectedJustification: selectedJustification,
        selectedOriginStock: selectedOriginStock,
        selectedDestinyStock: selectedDestinyStock,
        stocksAsync: stocksAsync,
        justificationsAsync: justificationsAsync,
        changeJustification: (value) {
          setState(() {
            selectedJustification = value;
          });
        },
        changeOriginStock: (value) {
          setState(() {
            selectedOriginStock = value;
          });
        },
        changeDestinyStock: (value) {
          setState(() {
            selectedDestinyStock = value;
          });
        },
      ),
      LotPage(enterpriseCode: widget.enterpriseCode),
    ];

    final lotAsync = ref.watch(
      lotStateControllerProvider(widget.enterpriseCode),
    );

    final confirmAdjustStockAsync = ref.watch(
      confirmAdjustStockControllerProvider,
    );
    ref.listen(confirmAdjustStockControllerProvider, (p, n) {
      n.showAlertDialogOnError(context);
      n.showSnackbarOnSuccess(
        context,
        previous: p,
        message: 'Lote enviado com sucesso'.hardcoded,
      );
      n.doOnSuccess(p, () {
        ref
            .read(lotStateControllerProvider(widget.enterpriseCode).notifier)
            .clearLot(widget.enterpriseCode);
        pageController.animateToPage(
          0,
          duration: Duration(milliseconds: 200),
          curve: Curves.linear,
        );
      });
    });

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: FittedBox(
              child: Text("Transferência entre estoques".hardcoded),
            ),
          ),
          body: PageView(
            controller: pageController,
            children: pages,
            onPageChanged: (value) {
              setState(() {
                currentIndex = value;
              });
            },
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) {
              pageController.animateToPage(
                index,
                duration: Duration(milliseconds: 200),
                curve: Curves.linear,
              );
              setState(() {
                currentIndex = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(isIos ? CupertinoIcons.list_bullet : Icons.list),
                label: 'Produtos'.hardcoded,
              ),
              BottomNavigationBarItem(
                icon: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        right: Sizes.p8,
                        top: Sizes.p8,
                      ),
                      child: Icon(
                        isIos
                            ? CupertinoIcons.shopping_cart
                            : Icons.shopping_cart,
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: CircleAvatar(
                        backgroundColor: Colors.red,
                        radius: 8,
                        child: Padding(
                          padding: const EdgeInsets.all(1),
                          child: Center(
                            child: FittedBox(
                              child: Text(
                                lotAsync.value
                                        ?.where(
                                          (e) =>
                                              e.product.EnterpriseCode ==
                                              widget.enterpriseCode,
                                        )
                                        .toList()
                                        .length
                                        .toString() ??
                                    '0',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                label: 'Lote'.hardcoded,
              ),
            ],
          ),
        ),
        if (confirmAdjustStockAsync.isLoading) LoadingPage(),
      ],
    );
  }
}
