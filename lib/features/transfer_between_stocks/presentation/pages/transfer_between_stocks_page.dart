import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../commom_widgets/commom_widgets.dart';
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
  final lotQuantityController = TextEditingController();
  final lotQuantityFocusNode = FocusNode();
  final productSearchValueController = TextEditingController();
  final productQuantityController = TextEditingController();
  final productQuantityFocusNode = FocusNode();

  @override
  void dispose() {
    lotQuantityController.dispose();
    lotQuantityFocusNode.dispose();
    productSearchValueController.dispose();
    productQuantityController.dispose();
    productQuantityFocusNode.dispose();
    super.dispose();
  }

  void updatePageIndex(int index) {
    ref
        .read(
          selectedProductUIStateControllerProvider(
            widget.enterpriseCode,
          ).notifier,
        )
        .updateValues(pageIndex: index);
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
        updatePageIndex(0);
      });
    });

    final selectedPageIndex = ref.watch(
      selectedProductUIStateControllerProvider(
        widget.enterpriseCode,
      ).select((s) => s.pageIndex),
    );

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: FittedBox(
              child: Text("Transferência entre estoques".hardcoded),
            ),
          ),
          body: IndexedStack(
            index: selectedPageIndex,
            children: [
              ProductsPage(
                enterpriseCode: widget.enterpriseCode,
                searchValueController: productSearchValueController,
                quantityController: productQuantityController,
                quantityFocusNode: productQuantityFocusNode,
              ),
              LotPage(
                enterpriseCode: widget.enterpriseCode,
                lotQuantityController: lotQuantityController,
                lotQuantityFocusNode: lotQuantityFocusNode,
              ),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: ref.watch(
              selectedProductUIStateControllerProvider(
                widget.enterpriseCode,
              ).select((s) => s.pageIndex),
            ),
            onTap: updatePageIndex,
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
                      isSelected: selectedPageIndex == 1,
                    );
                  },
                ),
                label: 'Lote'.hardcoded,
              ),
            ],
          ),
        ),
        LoadingPage(providers: [confirmAdjustStockControllerProvider]),
      ],
    );
  }
}
