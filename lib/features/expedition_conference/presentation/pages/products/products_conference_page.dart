import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../core/presentation/controllers/products/products.dart';
import '../../controllers/controllers.dart';
import 'components/components.dart';
import 'products.dart';

class ProductsConferencePage extends ConsumerStatefulWidget {
  final int expeditionControlCode;
  final int stepCode;
  final EnterpriseEntity? selectedEnterprise;
  final String documentNumber;
  final int enterpriseCode;
  const ProductsConferencePage({
    super.key,
    required this.expeditionControlCode,
    required this.stepCode,
    required this.selectedEnterprise,
    required this.documentNumber,
    required this.enterpriseCode,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProductsConferencePageState();
}

class _ProductsConferencePageState
    extends ConsumerState<ProductsConferencePage> {
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
    final pendingProductsAsync = ref.watch(
      expeditionConferenceControllerProvider(
        widget.expeditionControlCode,
        widget.selectedEnterprise?.name ?? '',
      ),
    );

    final searchProductsAsync = ref.watch(
      searchProductsStateControllerProvider(
        widget.enterpriseCode,
        BsRoutine.generic,
        widget.selectedEnterprise?.name ?? '',
      ),
    );

    ref.listen(
      confirmConferenceControllerProvider(
        widget.selectedEnterprise?.name ?? '',
      ),
      (p, n) {
        n.doOnSuccess(p, () {
          ref.invalidate(
            expeditionDocumentsStateControllerProvider(
              widget.enterpriseCode,
              widget.selectedEnterprise?.name ?? '',
            ),
          );
          context.pop();
          //TODO test if is working. If not, find another way to close the page and reload documents
        });
        n.showAlertDialogOnError(context);
      },
    );

    final confirmAsync = ref.watch(
      confirmConferenceControllerProvider(
        widget.selectedEnterprise?.name ?? '',
      ),
    );

    ref.listen(
      searchProductsStateControllerProvider(
        widget.enterpriseCode,
        BsRoutine.generic,
        widget.selectedEnterprise?.name ?? '',
      ),
      (p, n) {
        n.showSnackbarOnError(
          context,
          previous: p,
          message: 'Houve um problema para pesquisar o produto. Tente novamente'
              .hardcoded,
        );

        n.doOnSuccess(p, () {
          if (n.hasValue != true) {
            return;
          } else if (n.value != null && n.value!.length == 1) {
            ref
                .read(
                  expeditionConferenceControllerProvider(
                    widget.expeditionControlCode,
                    widget.selectedEnterprise?.name ?? '',
                  ).notifier,
                )
                .scanProduct(
                  n.value!.first.ProductPackingCode,
                  widget.stepCode,
                );

            Future.delayed(Duration(milliseconds: 100), () {
              focusNode.requestFocus();
            });
          } else if (n.value != null && n.value!.length > 1) {
            //TODO show modal page to select the correct product to count
            debugPrint(
              'show modal page to select the correct product to count',
            );
          }
          searchValueController.clear();
        });
      },
    );

    void onRefresh() {
      ref.invalidate(
        expeditionConferenceControllerProvider(
          widget.expeditionControlCode,
          widget.selectedEnterprise?.name ?? '',
        ),
      );
    }

    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    final pages = [
      PendingProductsPage(
        focusNode: focusNode,
        searchValueController: searchValueController,
        selectedEnterprise: widget.selectedEnterprise,
        enterpriseCode: widget.enterpriseCode,
        pendingProductsAsync: pendingProductsAsync,
        onRefresh: onRefresh,
        searchProductsAsync: searchProductsAsync,
      ),
      ConferedProductsPage(
        onRefresh: onRefresh,
        pendingProductsAsync: pendingProductsAsync,
      ),
    ];
    return Stack(
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
          body: confirmAsync.hasError
              ? TryConfirmAgain(
                  confirmAsync: confirmAsync,
                  expeditionControlCode: widget.expeditionControlCode,
                  stepCode: widget.stepCode,
                  selectedEnterprise: widget.selectedEnterprise,
                )
              : pages[currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                label: 'Pendentes'.hardcoded,
                icon: Badge(
                  label: Text(
                    pendingProductsAsync.value?.pendingProducts.length
                            .toString() ??
                        '0',
                  ),
                  offset: Offset(8, -6),
                  child: Icon(
                    isIOS
                        ? CupertinoIcons.exclamationmark_triangle
                        : Icons.error,
                  ),
                ),
              ),
              BottomNavigationBarItem(
                label: 'Conferidos'.hardcoded,
                icon: Badge(
                  label: Text(
                    pendingProductsAsync.value?.scannedProducts.length
                            .toString() ??
                        '0',
                  ),
                  offset: Offset(8, -6),
                  child: Icon(
                    isIOS
                        ? CupertinoIcons.checkmark_seal
                        : Icons.verified_rounded,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (confirmAsync.isLoading) LoadingPage(),
      ],
    );
  }
}
