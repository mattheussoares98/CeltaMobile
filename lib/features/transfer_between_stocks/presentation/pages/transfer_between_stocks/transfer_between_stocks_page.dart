import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../core/presentation/controllers/stock/stock.dart';
import '../../controllers/controllers.dart';
import '../pages.dart';
import 'components/components.dart';

class TransferBetweenStocksPage extends ConsumerWidget {
  final int enterpriseCode;
  const TransferBetweenStocksPage({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void updatePageIndex(int index) {
      ref
          .read(
            selectedProductUIStateControllerProvider(enterpriseCode).notifier,
          )
          .updateValues(pageIndex: index);
    }

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

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: FittedBox(
              child: Text("Transferência entre estoques".hardcoded),
            ),
          ),
          body: Consumer(
            builder: (_, ref, _) {
              final selectedPageIndex = ref.watch(
                selectedProductUIStateControllerProvider(
                  enterpriseCode,
                ).select((s) => s.pageIndex),
              );

              return IndexedStack(
                index: selectedPageIndex,
                children: [
                  ProductsPage(enterpriseCode: enterpriseCode),
                  LotPage(enterpriseCode: enterpriseCode),
                ],
              );
            },
          ),
          bottomNavigationBar: BottomNavBar(enterpriseCode: enterpriseCode),
        ),
        LoadingPage(providers: [confirmAdjustStockControllerProvider]),
      ],
    );
  }
}
