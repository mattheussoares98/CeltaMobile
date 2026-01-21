import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
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
  final searchProductController = TextEditingController();
  final searchProductFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();

    searchProductController.dispose();
    searchProductFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    listenSearchProducts(
      ref: ref,
      context: context,
      searchProductController: searchProductController,
      stepCode: widget.stepCode,
      expeditionControlCode: widget.expeditionControlCode,
      enterpriseCode: widget.enterpriseCode,
      searchProductFocusNode: searchProductFocusNode,
    );

    ref.listen(scanProductControllerProvider, (p, n) {
      n.showSnackbarOnError(context, p);
    });

    ref.listen(confirmConferenceControllerProvider, (p, n) {
      n.doOnSuccess(p, () {
        ref.invalidate(
          expeditionDocumentsStateControllerProvider(widget.enterpriseCode),
        );
        context.pop();
        Future.delayed(const Duration(milliseconds: 100), () {
          showAlertDialog(
            context: context,
            title: 'Conferência concluída!'.hardcoded,
            content:
                'A conferência do documento ${widget.documentNumber} foi concluída com sucesso'
                    .hardcoded,
          );
        });
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
              title: Consumer(
                builder: (_, ref, _) {
                  return FittedBox(
                    child: Text(
                      '${ref.watch(pageIndexStateControllerProvider) == 0 ? 'Pendentes' : 'Conferidos'} (${widget.documentNumber})'
                          .hardcoded,
                    ),
                  );
                },
              ),
            ),
            body: AsyncValueWidget(
              value: ref.watch(
                expeditionConferenceControllerProvider(
                  widget.expeditionControlCode,
                ),
              ),
              tryAgain: () => ref.invalidate(
                expeditionConferenceControllerProvider(
                  widget.expeditionControlCode,
                ),
              ),
              data: (_) {
                return ref.watch(
                      confirmConferenceControllerProvider.select(
                        (state) => state.hasError,
                      ),
                    )
                    ? TryConfirmAgain(
                        expeditionControlCode: widget.expeditionControlCode,
                        stepCode: widget.stepCode,
                      )
                    : Consumer(
                        builder: (_, ref, _) {
                          return IndexedStack(
                            index: ref.watch(pageIndexStateControllerProvider),
                            children: [
                              PendingProductsPage(
                                focusNode: searchProductFocusNode,
                                searchProductController:
                                    searchProductController,
                                enterpriseCode: widget.enterpriseCode,
                                expeditionControlCode:
                                    widget.expeditionControlCode,
                              ),
                              ConferedProductsPage(
                                expeditionControlCode:
                                    widget.expeditionControlCode,
                              ),
                            ],
                          );
                        },
                      );
              },
            ),

            bottomNavigationBar: BottomNavBar(
              expeditionControlCode: widget.expeditionControlCode,
            ),
          ),
          LoadingPage(providers: [confirmConferenceControllerProvider]),
        ],
      ),
    );
  }
}
