import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
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
  final personalDataPageKey = GlobalKey<PersonalDataPageState>();

  Future<bool> updateCustomerInProvider({required bool validateField}) async {
    final selectedIndex = ref.read(pageIndexStateControllerProvider);
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
        ref.invalidate(customerStateControllerProvider);
        personalDataPageKey.currentState?.updateFields();
        ref.read(pageIndexStateControllerProvider.notifier).updateIndex(0);
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
            body: IndexedStack(
              index: ref.watch(pageIndexStateControllerProvider),
              children: pages,
            ),
            bottomNavigationBar: BottomNavigationWidget(
              onTapItem: (index) async {
                final updated = await updateCustomerInProvider(
                  validateField: true,
                );
                if (!updated) {
                  return;
                }

                ref
                    .read(pageIndexStateControllerProvider.notifier)
                    .updateIndex(index);
              },
            ),
          ),
        ),
        LoadingPage(
          providers: [
            customerStateControllerProvider,
            insertUpdateCustomerControllerProvider,
          ],
        ),
      ],
    );
  }
}
