import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../controllers/controllers.dart';

class BottomNavigationWidget extends ConsumerWidget {
  final void Function(int index) onTapItem;
  const BottomNavigationWidget({super.key, required this.onTapItem});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customer = ref.watch(customerStateControllerProvider).value;
    final selectedIndex = ref.watch(pageIndexStateControllerProvider);

    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;
    return BottomNavigationBar(
      unselectedFontSize: 11,
      selectedFontSize: 11,
      currentIndex: selectedIndex,
      onTap: onTapItem,
      items: [
        BottomNavigationBarItem(
          label: 'Dados'.hardcoded,
          icon: Icon(
            isIOS ? CupertinoIcons.person : Icons.person,
            color: selectedIndex == 0 ? theme.primaryColor : null,
          ),
        ),
        BottomNavigationBarItem(
          label: 'Endereço'.hardcoded,
          icon: ValidatedBadge(
            isValid:
                customer?.Addresses != null && customer!.Addresses!.isNotEmpty,
            materialIcon: Icons.location_on,
            cupertinoIcon: CupertinoIcons.location,
            isSelected: selectedIndex == 1,
          ),
        ),
        BottomNavigationBarItem(
          label: 'E-mail'.hardcoded,
          icon: ValidatedBadge(
            isValid: customer?.Emails != null && customer!.Emails!.isNotEmpty,
            materialIcon: Icons.email,
            cupertinoIcon: CupertinoIcons.mail,
            isSelected: selectedIndex == 2,
          ),
        ),
        BottomNavigationBarItem(
          label: 'Telefone'.hardcoded,
          icon: ValidatedBadge(
            isValid:
                customer?.Telephones != null &&
                customer!.Telephones!.isNotEmpty,
            materialIcon: Icons.phone,
            cupertinoIcon: CupertinoIcons.phone,
            isSelected: selectedIndex == 3,
          ),
        ),
        BottomNavigationBarItem(
          label: 'Convênios'.hardcoded,
          icon: ValidatedBadge(
            isValid:
                customer?.CustomerCovenants != null &&
                customer!.CustomerCovenants!.isNotEmpty,
            materialIcon: Icons.wallet,
            cupertinoIcon: CupertinoIcons.creditcard,
            isSelected: selectedIndex == 4,
          ),
        ),
        BottomNavigationBarItem(
          label: 'Salvar'.hardcoded,
          icon: Icon(
            isIOS ? CupertinoIcons.check_mark : Icons.save,
            color: selectedIndex == 5 ? theme.primaryColor : null,
          ),
        ),
      ],
    );
  }
}
