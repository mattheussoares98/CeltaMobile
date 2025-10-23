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
  final searchProductController = TextEditingController();
  final quantityController = TextEditingController();
  final costController = TextEditingController();
  final quantityFocusNode = FocusNode();
  final costFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    supplierController.dispose();
    searchProductController.dispose();
    quantityController.dispose();
    costController.dispose();
    quantityFocusNode.dispose();
    costFocusNode.dispose();
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
      ProductsPage(
        searchProductController: searchProductController,
        quantityController: quantityController,
        costController: costController,
        quantityFocusNode: quantityFocusNode,
        costFocusNode: costFocusNode,
      ),
      ConfirmationPage(),
    ];

    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) {
          if (currentIndex == 0 &&
              identificationFormKey.currentState?.validate() != true) {
            return;
          } else if (currentIndex == 0 &&
              pendingAsync.value?.selectedSupplier == null) {
            showSnackBarMessage(
              context,
              'Selecione um fornecedor'.hardcoded,
              backgroundColor: Colors.red,
            );
          } else if (currentIndex == 1 &&
              (pendingAsync.value?.selectedEnterprises == null ||
                  pendingAsync.value!.selectedEnterprises!.isEmpty)) {
            showSnackBarMessage(
              context,
              'Selecione pelo menos uma empresa'.hardcoded,
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
