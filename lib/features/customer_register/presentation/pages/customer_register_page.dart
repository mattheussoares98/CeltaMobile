import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/customer_register/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/customer_register/presentation/pages/pages.dart';
import 'package:celta_inventario/features/customer_register/presentation/pages/save/components/components.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
        showToastMessage(context.l10n.customerSavedSuccessfully);
        ref.invalidate(customerStateControllerProvider);
        personalDataPageKey.currentState?.updateFields(clearCpf: true);
        ref.read(pageIndexStateControllerProvider.notifier).updateIndex(0);
      });
      n.showAlertDialogOnError(context);
    });

    ref.observeLoading([
      customerStateControllerProvider,
      insertUpdateCustomerControllerProvider,
    ]);

    final pages = [
      PersonalDataPage(key: personalDataPageKey),
      const AddressPage(),
      const EmailPage(),
      const PhonePage(),
      const CovenantsPage(),
      const SavePage(),
    ];

    final appBarsTitles = [
      context.l10n.personalDetails,
      context.l10n.addresses,
      context.l10n.emails,
      context.l10n.phoneNumbers,
      context.l10n.agreements,
      context.l10n.save,
    ];

    final customer = ref.watch(customerStateControllerProvider).value;
    final pageIndex = ref.watch(pageIndexStateControllerProvider);

    return BaseScaffold(
      isScrollable: false,
      padding: const EdgeInsets.fromLTRB(Sizes.p8, 0, Sizes.p8, Sizes.p8),
      appBar: BaseAppBar(
        title: appBarsTitles[pageIndex],
        actions: [if (pageIndex == 5) const SaveButton()],
      ),
      body: AsyncValueWidget(
        value: ref.watch(globalParametersControllerProvider),
        tryAgain: () => ref.invalidate(globalParametersControllerProvider),
        data: (_) {
          return IndexedStack(index: pageIndex, children: pages);
        },
      ),
      bottomNavigationBar: BaseBottomNavigationBar(
        currentIndex: pageIndex,
        onTap: (index) async {
          final updated = await updateCustomerInProvider(validateField: true);
          if (!updated) {
            return;
          }

          ref
              .read(pageIndexStateControllerProvider.notifier)
              .updateIndex(index);
        },
        items: [
          BaseBottomNavigationBarItem(
            label: context.l10n.details2,
            platformIcon: const PlatformIcon(
              cupertinoIcon: CupertinoIcons.person,
              materialIcon: Icons.person,
            ),
          ),
          BaseBottomNavigationBarItem(
            label: context.l10n.address,
            isValid:
                customer?.Addresses != null && customer!.Addresses!.isNotEmpty,
            platformIcon: const PlatformIcon(
              materialIcon: Icons.location_on,
              cupertinoIcon: CupertinoIcons.location,
            ),
          ),
          BaseBottomNavigationBarItem(
            label: context.l10n.email,
            isValid: customer?.Emails != null && customer!.Emails!.isNotEmpty,
            platformIcon: const PlatformIcon(
              materialIcon: Icons.email,
              cupertinoIcon: CupertinoIcons.mail,
            ),
          ),
          BaseBottomNavigationBarItem(
            label: context.l10n.phone,
            isValid: customer?.Telephones?.isNotEmpty ?? false,
            platformIcon: const PlatformIcon(
              materialIcon: Icons.phone,
              cupertinoIcon: CupertinoIcons.phone,
            ),
          ),
          BaseBottomNavigationBarItem(
            label: context.l10n.agreements,
            isValid: customer?.CustomerCovenants?.isNotEmpty ?? false,
            platformIcon: const PlatformIcon(
              materialIcon: Icons.wallet,
              cupertinoIcon: CupertinoIcons.creditcard,
            ),
          ),
          BaseBottomNavigationBarItem(
            label: context.l10n.save,
            platformIcon: const PlatformIcon(
              cupertinoIcon: CupertinoIcons.check_mark,
              materialIcon: Icons.save,
            ),
          ),
        ],
      ),
    );
  }
}
