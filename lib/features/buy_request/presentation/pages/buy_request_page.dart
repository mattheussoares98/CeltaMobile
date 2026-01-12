import 'package:celta_intelligence/commom_widgets/commom_widgets.dart';
import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constants/constants.dart';
import '../controllers/controllers.dart';
import 'components/components.dart';
import 'pages.dart';

class BuyRequestPage extends ConsumerStatefulWidget {
  const BuyRequestPage({super.key});

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
      const IdentificationPage(),
      const EnterprisesPage(),
      const ProductsPage(),
      const ConfirmationPage(),
    ];

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: FittedBox(
              child: Text(
                appBarTitles[ref.watch(
                  uiStateControllerProvider.select(
                    (s) => s.value?.currentPageIndex ?? 0,
                  ),
                )],
              ),
            ),
            actionsPadding: const EdgeInsets.fromLTRB(
              0,
              Sizes.p8,
              Sizes.p12,
              Sizes.p8,
            ),
            actions: const [CartPriceIcon()],
          ),
          body: IndexedStack(
            index: ref.watch(
              uiStateControllerProvider.select(
                (s) => s.value?.currentPageIndex ?? 0,
              ),
            ),
            children: pages,
          ),
          bottomNavigationBar: const BottomNavBar(),
        ),
        LoadingPage(providers: [insertBuyRequestControllerProvider]),
      ],
    );
  }
}
