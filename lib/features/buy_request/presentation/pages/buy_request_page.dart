import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constants/constants.dart';
import '../controllers/controllers.dart';
import 'components/components.dart';
import 'pages.dart';

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

    return Scaffold(
      appBar: AppBar(
        leadingWidth: Sizes.p32,
        title: FittedBox(
          child: Consumer(
            builder: (_, ref, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appBarTitles[ref.watch(
                      uiStateControllerProvider(
                        widget.enterpriseCode,
                      ).select((s) => s.value?.currentPageIndex ?? 0),
                    )],
                  ),
                  LastSavedRequestsNumbers(
                    enterpriseCode: widget.enterpriseCode,
                  ),
                ],
              );
            },
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(0, Sizes.p8, Sizes.p12, 0),
        actions: [
          if (MediaQuery.sizeOf(context).width > Breakpoint.desktop) ...[],
          ClearRequestButton(
            observationsController: observationsController,
            enterpriseCode: widget.enterpriseCode,
          ),
          gapW12,
          CartPriceIcon(enterpriseCode: widget.enterpriseCode),
        ],
      ),
      body: Consumer(
        builder: (_, ref, _) {
          return IndexedStack(
            index: ref.watch(
              uiStateControllerProvider(
                widget.enterpriseCode,
              ).select((s) => s.value?.currentPageIndex ?? 0),
            ),
            children: pages,
          );
        },
      ),
      bottomNavigationBar: BottomNavBar(enterpriseCode: widget.enterpriseCode),
    );
  }
}
