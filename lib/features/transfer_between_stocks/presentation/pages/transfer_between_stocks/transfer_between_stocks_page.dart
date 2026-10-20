import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/presentation/controllers/stock/stock.dart';
import 'package:celta_inventario/features/transfer_between_stocks/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/transfer_between_stocks/presentation/pages/lot/components/components.dart';
import 'package:celta_inventario/features/transfer_between_stocks/presentation/pages/pages.dart';
import 'package:celta_inventario/features/transfer_between_stocks/presentation/pages/transfer_between_stocks/components/components.dart';
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
      n.showToastOnSuccess(
        context,
        previous: p,
        message: context.l10n.batchSentSuccessfully,
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
      resizeToAvoidBottomInset: true,
      padding: const EdgeInsets.fromLTRB(Sizes.p8, 0, Sizes.p8, 0),
      appBar: BaseAppBar(
        title: context.l10n.coreTransferJustificationTypeTransferBetweenStocks,
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
