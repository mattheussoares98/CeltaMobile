import 'package:celta_intelligence/commom_widgets/commom_widgets.dart';
import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  int currentIndex = 0;
  final identificationFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    supplierController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pendingAsync = ref.watch(pendingBuyRequestStateControllerProvider);

    final pages = [
      IdentificationPage(
        supplierController: supplierController,
        identificationFormKey: identificationFormKey,
      ),
      EnterprisesPage(),
      ProductsPage(),
      ConfirmationPage(),
    ];

    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavBar(
        onTap: (index) {
          bool needsValidate = index > currentIndex;

          if (needsValidate &&
              identificationFormKey.currentState?.validate() != true) {
            return;
          } else if (needsValidate &&
              pendingAsync.value?.selectedSupplier == null) {
            showSnackBarMessage(
              context,
              'Selecione um fornecedor'.hardcoded,
              backgroundColor: Colors.red,
            );
          } else {
            setState(() => currentIndex = index);
          }
        },
      ),
    );
  }
}
