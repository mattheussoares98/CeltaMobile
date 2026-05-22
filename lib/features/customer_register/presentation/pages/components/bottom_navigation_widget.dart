import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/customer_register/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:celta_inventario/utils/utils.dart';

class BottomNavigationWidget extends ConsumerWidget {
  final void Function(int index) onTapItem;
  const BottomNavigationWidget({super.key, required this.onTapItem});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customer = ref.watch(customerStateControllerProvider).value;
    final selectedIndex = ref.watch(pageIndexStateControllerProvider);

    return BottomNavigationBar(
      unselectedFontSize: 11,
      selectedFontSize: 11,
      currentIndex: selectedIndex,
      onTap: onTapItem,
      items: [
        BottomNavigationBarItem(
          label: 'Dados'.hardcoded,
          icon: PlatformIcon(
            cupertinoIcon: CupertinoIcons.person,
            materialIcon: Icons.person,
            color: selectedIndex == 0 ? context.theme.primaryColor : null,
          ),
        ),
        BottomNavigationBarItem(
          label: 'Endereço'.hardcoded,
          icon: ValidatedBadge(
            isValid:
                customer?.Addresses != null && customer!.Addresses!.isNotEmpty,
            platformIcon: const PlatformIcon(
              materialIcon: Icons.location_on,
              cupertinoIcon: CupertinoIcons.location,
            ),
            isSelected: selectedIndex == 1,
          ),
        ),
        BottomNavigationBarItem(
          label: 'E-mail'.hardcoded,
          icon: ValidatedBadge(
            isValid: customer?.Emails != null && customer!.Emails!.isNotEmpty,
            platformIcon: const PlatformIcon(
              materialIcon: Icons.email,
              cupertinoIcon: CupertinoIcons.mail,
            ),
            isSelected: selectedIndex == 2,
          ),
        ),
        BottomNavigationBarItem(
          label: 'Telefone'.hardcoded,
          icon: ValidatedBadge(
            isValid:
                customer?.Telephones != null &&
                customer!.Telephones!.isNotEmpty,
            platformIcon: const PlatformIcon(
              materialIcon: Icons.phone,
              cupertinoIcon: CupertinoIcons.phone,
            ),
            isSelected: selectedIndex == 3,
          ),
        ),
        BottomNavigationBarItem(
          label: 'Convênios'.hardcoded,
          icon: ValidatedBadge(
            isValid:
                customer?.CustomerCovenants != null &&
                customer!.CustomerCovenants!.isNotEmpty,
            platformIcon: const PlatformIcon(
              materialIcon: Icons.wallet,
              cupertinoIcon: CupertinoIcons.creditcard,
            ),
            isSelected: selectedIndex == 4,
          ),
        ),
        BottomNavigationBarItem(
          label: 'Salvar'.hardcoded,
          icon: PlatformIcon(
            cupertinoIcon: CupertinoIcons.check_mark,
            materialIcon: Icons.save,
            color: selectedIndex == 5 ? context.theme.primaryColor : null,
          ),
        ),
      ],
    );
  }
}
