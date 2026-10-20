import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/presentation/controllers/stock/stock.dart';
import 'package:celta_inventario/features/stock_replacement/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/stock_replacement/presentation/pages/components/components.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      n.showToastOnSuccess(
        context,
        previous: p,
        message: context.l10n.adjustmentCompleted,
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

    return BaseScaffold(
      isScrollable: false,
      usePadding: false,
      resizeToAvoidBottomInset: true,
      appBar: BaseAppBar(
        title: context.l10n.coreModulesStockReplacement,
        selectedEnterpriseCode: widget.enterpriseCode,
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
