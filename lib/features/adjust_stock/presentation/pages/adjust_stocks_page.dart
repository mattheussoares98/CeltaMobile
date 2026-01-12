import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../commom_widgets/commom_widgets.dart';
import '../../../../constants/constants.dart';
import '../../../../core/presentation/controllers/stock/stock.dart';
import '../controllers/controllers.dart';
import 'components/components.dart';

class AdjustStocksPage extends ConsumerStatefulWidget {
  final int enterpriseCode;
  const AdjustStocksPage({super.key, required this.enterpriseCode});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AdjustStocksPageState();
}

class _AdjustStocksPageState extends ConsumerState<AdjustStocksPage> {
  final searchValueController = TextEditingController();
  final quantityController = TextEditingController();
  final quantityFocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();

    searchValueController.dispose();
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
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: FittedBox(child: Text("Ajuste de estoque".hardcoded)),
          ),
          body: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Sizes.p4),
              child: Column(
                children: [
                  HeaderFilters(
                    enterpriseCode: widget.enterpriseCode,
                    searchValueController: searchValueController,
                  ),
                  Expanded(
                    child: ProductsItems(
                      quantityFocusNode: quantityFocusNode,
                      formKey: formKey,
                      enterpriseCode: widget.enterpriseCode,
                      quantityController: quantityController,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        LoadingPage(providers: [confirmAdjustStockControllerProvider]),
      ],
    );
  }
}
