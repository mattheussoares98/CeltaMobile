import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../core/presentation/controllers/products/products.dart';
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
      focusNode: focusNode,
      stepCode: widget.stepCode,
      expeditionControlCode: widget.expeditionControlCode,
      enterpriseCode: widget.enterpriseCode,
    );

    final pendingProductsAsync = ref.watch(
      expeditionConferenceControllerProvider(widget.expeditionControlCode),
    );

    ref.listen(
      expeditionConferenceControllerProvider(widget.expeditionControlCode),
      (p, n) {
        n.showAlertDialogOnError(context);
      },
    );

    final searchProductsAsync = ref.watch(
      searchProductsStateControllerProvider(
        widget.enterpriseCode,
        BsRoutine.generic,
        Modules.expeditionConference,
      ),
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

    final confirmAsync = ref.watch(confirmConferenceControllerProvider);

    final pages = [
      PendingProductsPage(
        focusNode: focusNode,
        searchValueController: searchValueController,
        enterpriseCode: widget.enterpriseCode,
        pendingProductsAsync: pendingProductsAsync,
        searchProductsAsync: searchProductsAsync,
        expeditionControlCode: widget.expeditionControlCode,
      ),
      ConferedProductsPage(
        scannedProducts: pendingProductsAsync.value?.scannedProducts,
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
                )
              : pages[currentIndex],
          bottomNavigationBar: BottomNavBar(
            pendingProductsAsync: pendingProductsAsync,
            onTap: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            currentIndex: currentIndex,
          ),
        ),
        if (confirmAsync.isLoading) const LoadingPage(),
      ],
    );
  }
}
