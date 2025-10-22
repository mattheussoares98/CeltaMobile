import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../core/domain/entities/entities.dart';

class BottomNavigationWidget extends StatelessWidget {
  final int selectedIndex;
  final void Function(int index) onTapItem;
  final CustomerEntity? customer;
  const BottomNavigationWidget({
    super.key,
    required this.selectedIndex,
    required this.onTapItem,
    required this.customer,
  });

  @override
  Widget build(BuildContext context) {
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
            iconColor: selectedIndex == 1 ? theme.primaryColor : null,
          ),
        ),
        BottomNavigationBarItem(
          label: 'E-mail'.hardcoded,
          icon: ValidatedBadge(
            isValid:
                customer?.Addresses != null && customer!.Addresses!.isNotEmpty,
            materialIcon: Icons.email,
            cupertinoIcon: CupertinoIcons.mail,
            iconColor: selectedIndex == 2 ? theme.primaryColor : null,
          ),
        ),
        BottomNavigationBarItem(
          label: 'Telefone'.hardcoded,
          icon: ValidatedBadge(
            isValid:
                customer?.Addresses != null && customer!.Addresses!.isNotEmpty,
            materialIcon: Icons.phone,
            cupertinoIcon: CupertinoIcons.phone,
            iconColor: selectedIndex == 3 ? theme.primaryColor : null,
          ),
        ),
        BottomNavigationBarItem(
          label: 'Convênios'.hardcoded,
          icon: ValidatedBadge(
            isValid:
                customer?.Addresses != null && customer!.Addresses!.isNotEmpty,
            materialIcon: Icons.wallet,
            cupertinoIcon: CupertinoIcons.creditcard,
            iconColor: selectedIndex == 4 ? theme.primaryColor : null,
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
