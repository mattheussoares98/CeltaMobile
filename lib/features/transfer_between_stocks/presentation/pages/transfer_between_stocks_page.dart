import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../commom_widgets/commom_widgets.dart';
import '../../../../core/domain/entities/entities.dart';
import '../../../../core/presentation/controllers/stock/stock.dart';
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
          duration: const Duration(milliseconds: 200),
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
            children: [
              ProductsPage(
                enterpriseCode: widget.enterpriseCode,
                selectedJustification: selectedJustification,
                selectedOriginStock: selectedOriginStock,
                selectedDestinyStock: selectedDestinyStock,
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
            ],
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
                duration: const Duration(milliseconds: 200),
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
                icon: Consumer(
                  builder: (_, ref, _) {
                    final lotAsync = ref.watch(
                      lotStateControllerProvider(widget.enterpriseCode),
                    );

                    return QuantityBadge(
                      quantity: lotAsync.value
                          ?.where(
                            (e) =>
                                e.product.EnterpriseCode ==
                                widget.enterpriseCode,
                          )
                          .toList()
                          .length,
                      materialIcon: Icons.shopping_cart,
                      cupertinoIcon: CupertinoIcons.shopping_cart,
                      isSelected: currentIndex == 1,
                    );
                  },
                ),
                label: 'Lote'.hardcoded,
              ),
            ],
          ),
        ),
        Consumer(
          builder: (_, ref, _) {
            final isLoading = ref.watch(
              confirmAdjustStockControllerProvider.select(
                (value) => value.isLoading,
              ),
            );

            if (isLoading) {
              return const LoadingPage();
            }

            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
