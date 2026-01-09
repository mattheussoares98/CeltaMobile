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
  final identificationFormKey = GlobalKey<FormState>();
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
    final pendingAsync = ref.watch(pendingBuyRequestStateControllerProvider);

    final pages = [
      IdentificationPage(
        supplierController: supplierController,
        identificationFormKey: identificationFormKey,
      ),
      const EnterprisesPage(),
      const ProductsPage(),
      ConfirmationPage(observationsController: observationsController),
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
            actions: [
              CartPriceIcon(
                onTap: () {
                  ref
                      .read(uiStateControllerProvider.notifier)
                      .updatePageIndex(3);
                },
                pendingAsync: pendingAsync,
              ),
            ],
          ),
          body: IndexedStack(
            index: ref.watch(
              uiStateControllerProvider.select(
                (s) => s.value?.currentPageIndex ?? 0,
              ),
            ),
            children: pages,
          ),
          bottomNavigationBar: BottomNavBar(
            currentIndex: ref.watch(
              uiStateControllerProvider.select(
                (s) => s.value?.currentPageIndex ?? 0,
              ),
            ),
            onTap: (index) {
              bool enterprisesAreValid =
                  pendingAsync.value?.selectedEnterprises != null &&
                  pendingAsync.value!.selectedEnterprises!.isNotEmpty;
              bool buyerIsSelected = pendingAsync.value?.selectedBuyer != null;
              bool requestTypeIsSelected =
                  pendingAsync.value?.selectedRequestType != null;
              bool supplierIsSelected =
                  pendingAsync.value?.selectedSupplier != null;

              final currentIndex = ref.watch(
                uiStateControllerProvider.select(
                  (s) => s.value?.currentPageIndex ?? 0,
                ),
              );

              if (currentIndex == 0 && (index == 1 || index == 2)) {
                bool isValid =
                    identificationFormKey.currentState?.validate() == true;
                //TODO check to remove this formKey
                if (!isValid) {
                  return;
                } else if (pendingAsync.value?.selectedSupplier == null) {
                  showSnackBarMessage(
                    context,
                    'Selecione um fornecedor'.hardcoded,
                    backgroundColor: Colors.red,
                  );
                  return;
                }
              }

              if ((index == 1 || index == 2)) {
                if (!buyerIsSelected ||
                    !requestTypeIsSelected ||
                    !supplierIsSelected) {
                  showSnackBarMessage(
                    context,
                    'Preencha os campos de identificação'.hardcoded,
                    backgroundColor: Colors.red,
                  );
                  return;
                }
              }

              if (index == 2 && !enterprisesAreValid) {
                showSnackBarMessage(
                  context,
                  'Selecione pelo menos uma empresa'.hardcoded,
                  backgroundColor: Colors.red,
                );
                return;
              }

              ref
                  .read(uiStateControllerProvider.notifier)
                  .updatePageIndex(index);
            },
          ),
        ),
        LoadingPage(providers: [insertBuyRequestControllerProvider]),
      ],
    );
  }
}
