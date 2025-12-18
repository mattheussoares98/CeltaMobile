import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../commom_widgets/commom_widgets.dart';
import '../../../../core/presentation/controllers/stock/stock.dart';
import '../controllers/controllers.dart';
import 'pages.dart';

class TransferBetweenStocksPage extends ConsumerWidget {
  final int enterpriseCode;

  const TransferBetweenStocksPage({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void updatePageIndex(int index) {
      ref
          .read(selectedUIStateControllerProvider(enterpriseCode).notifier)
          .updateValues(pageIndex: index);
    }

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
            .read(lotStateControllerProvider(enterpriseCode).notifier)
            .clearLot(enterpriseCode);
        updatePageIndex(0);
      });
    });

    final selectedPageIndex = ref.watch(
      selectedUIStateControllerProvider(
        enterpriseCode,
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
              ProductsPage(enterpriseCode: enterpriseCode),
              LotPage(enterpriseCode: enterpriseCode),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: ref.watch(
              selectedUIStateControllerProvider(
                enterpriseCode,
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
                      lotStateControllerProvider(enterpriseCode),
                    );

                    return QuantityBadge(
                      quantity: lotAsync.value
                          ?.where(
                            (e) => e.product.EnterpriseCode == enterpriseCode,
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
