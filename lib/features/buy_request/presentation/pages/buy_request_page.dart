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
          bool needValidate = index > currentIndex;
          if (!needValidate) {
            setState(() => currentIndex = index);
            return;
          }

          bool enterprisesAreValid =
              pendingAsync.value?.selectedEnterprises != null &&
              pendingAsync.value!.selectedEnterprises!.isNotEmpty;
          bool productsAreValid =
              pendingAsync.value?.products != null &&
              pendingAsync.value!.products!.isNotEmpty;

          //! cant exit the first page in these cases
          if (currentIndex == 0) {
            //1- form fields not valid
            if (identificationFormKey.currentState?.validate() != true) {
              return;
            } else if (pendingAsync.value?.selectedSupplier == null) {
              //2- supplier not selected
              showSnackBarMessage(
                context,
                'Selecione um fornecedor'.hardcoded,
                backgroundColor: Colors.red,
              );
              return;
            }
          }

          if (index > 1 && !enterprisesAreValid) {
            showSnackBarMessage(
              context,
              'Selecione pelo menos uma empresa'.hardcoded,
              backgroundColor: Colors.red,
            );
            return;
          } else if (index > 2) {
            if (!productsAreValid) {
              showSnackBarMessage(
                context,
                'Insira pelo menos um produto'.hardcoded,
                backgroundColor: Colors.red,
              );
              return;
            }
          }

          setState(() => currentIndex = index);
        },
      ),
    );
  }
}
