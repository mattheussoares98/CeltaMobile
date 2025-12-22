import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../controllers/controllers.dart';
import '../mixins/mixins.dart';
import 'components/components.dart';
import 'products.dart';

class ProductsConferencePage extends ConsumerStatefulWidget {
  final int expeditionControlCode;
  final int stepCode;
  final String documentNumber;
  final int enterpriseCode;
  const ProductsConferencePage({
    super.key,
    required this.expeditionControlCode,
    required this.stepCode,
    required this.documentNumber,
    required this.enterpriseCode,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProductsConferencePageState();
}

class _ProductsConferencePageState extends ConsumerState<ProductsConferencePage>
    with SearchProductsListenerMixin {
  final searchValueController = TextEditingController();
  final focusNode = FocusNode();
  int currentIndex = 0;

  @override
  void dispose() {
    super.dispose();

    searchValueController.dispose();
    focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    listenSearchProducts(
      ref: ref,
      context: context,
      searchValueController: searchValueController,
      stepCode: widget.stepCode,
      expeditionControlCode: widget.expeditionControlCode,
      enterpriseCode: widget.enterpriseCode,
    );

    ref.listen(confirmConferenceControllerProvider, (p, n) {
      n.doOnSuccess(p, () {
        ref.invalidate(
          expeditionDocumentsStateControllerProvider(widget.enterpriseCode),
        );
        context.pop();
      });
      n.showAlertDialogOnError(context);
    });

    final scannedProducts = ref.watch(
      expeditionConferenceControllerProvider(
        widget.expeditionControlCode,
      ).select((s) => s.value?.scannedProducts ?? []),
    );

    return PopScope(
      canPop: scannedProducts.isEmpty,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;

        if (scannedProducts.any((x) => x.Quantity > 0)) {
          bool? pressed = await showAlertDialog(
            context: context,
            title: 'Atenção!'.hardcoded,
            content:
                'Ao sair, as quantidades contadas serão perdidas. Deseja sair mesmo assim?'
                    .hardcoded,
            cancelActionText: 'Cancelar'.hardcoded,
            defaultActionText: 'Sim'.hardcoded,
          );

          if (pressed == true) {
            context.pop();
          }
        }
      },
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: FittedBox(
                child: Text(
                  '${currentIndex == 0 ? 'Pendentes' : 'Conferidos'} (${widget.documentNumber})'
                      .hardcoded,
                ),
              ),
            ),
            body:
                ref.watch(
                  confirmConferenceControllerProvider.select(
                    (state) => state.hasError,
                  ),
                )
                ? TryConfirmAgain(
                    //TODO remove this widget and use AsyncValueWidget
                    expeditionControlCode: widget.expeditionControlCode,
                    stepCode: widget.stepCode,
                  )
                : IndexedStack(
                    index: currentIndex,
                    children: [
                      PendingProductsPage(
                        focusNode: focusNode,
                        searchValueController: searchValueController,
                        enterpriseCode: widget.enterpriseCode,
                        expeditionControlCode: widget.expeditionControlCode,
                      ),
                      ConferedProductsPage(
                        expeditionControlCode: widget.expeditionControlCode,
                      ),
                    ],
                  ),
            bottomNavigationBar: BottomNavBar(
              expeditionControlCode: widget.expeditionControlCode,
              onTap: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              currentIndex: currentIndex,
            ),
          ),
          LoadingPage(providers: [confirmConferenceControllerProvider]),
        ],
      ),
    );
  }
}
