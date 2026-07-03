import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/presentation/controllers/keyboard/keyboard/keyboard.dart';
import 'package:celta_inventario/features/buy_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/buy_request/presentation/pages/components/components.dart';
import 'package:celta_inventario/features/buy_request/presentation/pages/pages.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'confirmation/components/components.dart';

class BuyRequestPage extends ConsumerStatefulWidget {
  final int enterpriseCode;
  const BuyRequestPage({super.key, required this.enterpriseCode});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BuyRequestPageState();
}

class _BuyRequestPageState extends ConsumerState<BuyRequestPage> {
  final supplierController = TextEditingController();
  final observationsController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    supplierController.dispose();
    observationsController.dispose();
  }

  final appBarTitles = [
    'Identificação'.hardcoded,
    'Empresas'.hardcoded,
    'Produtos'.hardcoded,
    'Confirmação'.hardcoded,
  ];

  @override
  Widget build(BuildContext context) {
    final pages = [
      IdentificationPage(enterpriseCode: widget.enterpriseCode),
      EnterprisesPage(enterpriseCode: widget.enterpriseCode),
      ProductsPage(enterpriseCode: widget.enterpriseCode),
      ConfirmationPage(enterpriseCode: widget.enterpriseCode),
    ];

    ref.observeLoading([
      insertBuyRequestControllerProvider(widget.enterpriseCode),
    ]);

    final currentPageIndex = ref.watch(
      uiStateControllerProvider(
        widget.enterpriseCode,
      ).select((s) => s.value?.currentPageIndex ?? 0),
    );

    return BaseScaffold(
      isScrollable: false,
      resizeToAvoidBottomInset: true,
      appBar: BaseAppBar(
        title: appBarTitles[currentPageIndex],
        showSelectedEnterprise: true,
        actionsPadding: const EdgeInsets.fromLTRB(0, Sizes.p8, Sizes.p12, 0),
        subtitle: LastSavedRequestsNumbers(
          enterpriseCode: widget.enterpriseCode,
        ),
        actions: [
          if (MediaQuery.sizeOf(context).width > 200) ...[
            ClearRequestButton(
              observationsController: observationsController,
              enterpriseCode: widget.enterpriseCode,
            ),
          ],
          CartPriceIcon(enterpriseCode: widget.enterpriseCode),
        ],
      ),
      floatingActionButton: currentPageIndex == 3
          ? Consumer(
              builder: (_, ref, _) {
                final keyboardIsOpen = ref.watch(
                  keyboardVisibilityStateControllerProvider,
                );
                if (keyboardIsOpen) return const SizedBox.shrink();
                return FloatingSaveButton(
                  observationsController: observationsController,
                  enterpriseCode: widget.enterpriseCode,
                );
              },
            )
          : null,
      body: IndexedStack(index: currentPageIndex, children: pages),
      bottomNavigationBar: BottomNavBar(enterpriseCode: widget.enterpriseCode),
    );
  }
}
