import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/products/products.dart';
import 'package:celta_inventario/core/presentation/controllers/stock/stock.dart';
import 'package:celta_inventario/features/adjust_stock/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/adjust_stock/presentation/pages/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdjustStocksPage extends ConsumerStatefulWidget {
  final int enterpriseCode;
  final ProductEntity? product;
  const AdjustStocksPage({
    super.key,
    required this.enterpriseCode,
    required this.product,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AdjustStocksPageState();
}

class _AdjustStocksPageState extends ConsumerState<AdjustStocksPage> {
  final quantityController = TextEditingController();
  final quantityFocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  @override
  initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.product != null) {
        final provider = searchProductsStateControllerProvider(
          SearchProductKey(
            widget.enterpriseCode,
            BsRoutine.adjustStock,
            Modules.adjustStock,
          ),
        );
        await ref.read(provider.future);
        //necessary await build first
        ref.read(provider.notifier).addProduct(widget.product!);
      }
    });
  }

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
    final isDesktop = MediaQuery.sizeOf(context).width > Breakpoint.desktop;

    return BaseScaffold(
      isScrollable: false,
      usePadding: true,
      resizeToAvoidBottomInset: true,
      appBar: BaseAppBar(
        title: 'Ajuste de estoque'.hardcoded,
        showSelectedEnterprise: true,
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            SearchProductField(enterpriseCode: widget.enterpriseCode),
            gapH8,
            if (isDesktop) ...[
              Row(
                children: [
                  Expanded(
                    child: JustificationsDropdown(
                      enterpriseCode: widget.enterpriseCode,
                    ),
                  ),
                  gapW8,
                  Expanded(
                    child: StocksDropdown(
                      enterpriseCode: widget.enterpriseCode,
                    ),
                  ),
                ],
              ),
            ] else ...[
              JustificationsDropdown(enterpriseCode: widget.enterpriseCode),
              gapH8,
              StocksDropdown(enterpriseCode: widget.enterpriseCode),
            ],
            gapH8,
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
    );
  }
}
