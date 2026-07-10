import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/presentation/controllers/stock/stock.dart';
import 'package:celta_inventario/features/transfer_between_stocks/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/transfer_between_stocks/presentation/pages/lot/components/components.dart';
import 'package:celta_inventario/features/transfer_between_stocks/presentation/pages/pages.dart';
import 'package:celta_inventario/features/transfer_between_stocks/presentation/pages/transfer_between_stocks/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

    ref.observeLoading([confirmAdjustStockControllerProvider]);

    return BaseScaffold(
      isScrollable: false,
      usePadding: false,
      resizeToAvoidBottomInset: true,
      appBar: BaseAppBar(
        title: "Transferência entre estoques".hardcoded,
        selectedEnterpriseCode: enterpriseCode,
        actions: [ClearLotButton(enterpriseCode: enterpriseCode)],
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
    );
  }
}
