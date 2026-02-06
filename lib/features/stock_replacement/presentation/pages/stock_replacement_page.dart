import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../commom_widgets/commom_widgets.dart';
import '../../../../constants/constants.dart';
import '../../../../core/presentation/controllers/stock/stock.dart';
import '../../../../core/presentation/helpers/helpers.dart';
import '../controllers/controllers.dart';
import 'components/components.dart';

class StockReplacementPage extends ConsumerStatefulWidget {
  final int enterpriseCode;
  const StockReplacementPage({super.key, required this.enterpriseCode});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AdjustStocksPageState();
}

class _AdjustStocksPageState extends ConsumerState<StockReplacementPage> {
  final quantityController = TextEditingController();
  final quantityFocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  final now = DateTime.now();

  @override
  void dispose() {
    super.dispose();

    quantityController.dispose();
    quantityFocusNode.dispose();
  }

  void changeSelectedIndex(int? index) async {
    ref
        .read(selectedUIStateControllerProvider(widget.enterpriseCode).notifier)
        .updateValues(selectedIndex: index);
    await Future.delayed(const Duration(milliseconds: 100));
    quantityFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(confirmAdjustStockControllerProvider, (p, n) {
      n.showAlertDialogOnError(context);
      n.showSnackbarOnSuccess(
        context,
        previous: p,
        message: 'Ajuste efetuado com sucesso'.hardcoded,
      );
      n.doOnSuccess(p, () {
        quantityController.clear();
        final currentIndex = ref.read(
          selectedUIStateControllerProvider(
            widget.enterpriseCode,
          ).select((s) => s.selectedIndex),
        );
        changeSelectedIndex(currentIndex);
      });
    });

    ref.observeLoading([confirmAdjustStockControllerProvider]);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: DefaultAppBarTitle(
                enterpriseCode: widget.enterpriseCode,
                title: 'Substituição de estoque'.hardcoded,
              ),
            ),
            if (ModuleIsFreeUntil.stockReplacementIsFree)
              Column(
                children: [
                  Text(
                    'Grátis até'.hardcoded,
                    style: const TextStyle(fontSize: 11, color: Colors.green),
                  ),
                  Text(
                    DateFormat(
                      'dd/MM',
                    ).format(ModuleIsFreeUntil.stockReplacementDate),
                    style: const TextStyle(fontSize: 11, color: Colors.green),
                  ),
                ],
              ),
          ],
        ),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizes.p4),
          child: Column(
            children: [
              SizedBox(
                width: Breakpoint.desktop,
                child: Column(
                  children: [
                    SearchProductField(enterpriseCode: widget.enterpriseCode),
                    gapH8,
                    StocksDropdown(enterpriseCode: widget.enterpriseCode),
                    gapH8,
                  ],
                ),
              ),
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    ProductsItems(
                      quantityFocusNode: quantityFocusNode,
                      formKey: formKey,
                      enterpriseCode: widget.enterpriseCode,
                      quantityController: quantityController,
                    ),
                    gapSliverH48,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
