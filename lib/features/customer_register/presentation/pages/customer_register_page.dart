import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../commom_widgets/commom_widgets.dart';
import '../controllers/controllers.dart';
import 'components/components.dart';
import 'pages.dart';

class CustomerRegisterPage extends ConsumerStatefulWidget {
  const CustomerRegisterPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CustomerRegisterPageState();
}

class _CustomerRegisterPageState extends ConsumerState<CustomerRegisterPage> {
  int selectedIndex = 0;
  final personalDataPageKey = GlobalKey<PersonalDataPageState>();

  Future<bool> updateCustomerInProvider({required bool validateField}) async {
    if (selectedIndex == 0) {
      final personalDataState = personalDataPageKey.currentState;
      if (validateField && personalDataState?.validate() != true) {
        return false;
      }

      await personalDataState?.updateCustomerInProvider();
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(insertUpdateCustomerControllerProvider, (p, n) {
      n.doOnSuccess(p, () async {
        showSnackBarMessage(
          context,
          'Cliente cadastrado/atualizado com sucesso'.hardcoded,
        );
        ref.read(customerStateControllerProvider.notifier).updateCustomer(null);
        personalDataPageKey.currentState?.updateFields();
        setState(() {
          selectedIndex = 0;
        });
      });
      n.showAlertDialogOnError(context);
    });

    final pages = [
      PersonalDataPage(key: personalDataPageKey),
      const AddressPage(),
      const EmailPage(),
      const PhonePage(),
      const CovenantsPage(),
      const SavePage(),
    ];

    return Stack(
      children: [
        PopScope(
          canPop: true,
          onPopInvokedWithResult: (didPop, result) async {
            await updateCustomerInProvider(validateField: false);
          },
          child: Scaffold(
            body: IndexedStack(index: selectedIndex, children: pages),
            bottomNavigationBar: BottomNavigationWidget(
              selectedIndex: selectedIndex,
              onTapItem: (index) async {
                final updated = await updateCustomerInProvider(
                  validateField: true,
                );
                if (!updated) {
                  return;
                }

                setState(() {
                  selectedIndex = index;
                });
              },
            ),
          ),
        ),
        Consumer(
          builder: (_, ref, _) {
            final isLoading =
                ref.watch(customerStateControllerProvider).isLoading ||
                ref.watch(insertUpdateCustomerControllerProvider).isLoading;

            if (isLoading) {
              return const LoadingPage();
            }

            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
