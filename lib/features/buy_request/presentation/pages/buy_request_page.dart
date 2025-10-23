import 'package:celta_intelligence/commom_widgets/commom_widgets.dart';
import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/entities/entities.dart';
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

  List<SupplierEntity> suppliers = [];
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        suppliers = await ref
            .read(
              supplierStateControllerProvider(
                SearchSupplierType.buyRequest,
              ).future,
            )
            .then((value) {
              return [...?value];
            });

        final pendingAsync = await ref.read(
          pendingBuyRequestStateControllerProvider.future,
        );

        if (pendingAsync.selectedSupplier != null &&
            suppliers.any(
                  (e) => e.Code == pendingAsync.selectedSupplier?.Code,
                ) !=
                true) {
          setState(() {
            suppliers.add(pendingAsync.selectedSupplier!);
          });
        }
      }
    });
  }

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
        suppliers: suppliers,
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
              index > 1 &&
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
