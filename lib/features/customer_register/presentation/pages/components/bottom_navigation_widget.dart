import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../core/domain/entities/entities.dart';
import 'components.dart';

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
    return BottomNavigationBar(
      unselectedFontSize: 11,
      selectedFontSize: 11,
      currentIndex: selectedIndex,
      onTap: onTapItem,
      items: [
        BottomNavigationBarItem(
          label: 'Dados'.hardcoded,
          icon: BadgeIcon(
            valid: null,
            cupertinoIcon: CupertinoIcons.person,
            materialIcon: Icons.person,
          ),
        ),
        BottomNavigationBarItem(
          label: 'Endereço'.hardcoded,
          icon: BadgeIcon(
            valid:
                customer?.Addresses != null && customer!.Addresses!.isNotEmpty,
            cupertinoIcon: CupertinoIcons.location,
            materialIcon: Icons.location_on,
          ),
        ),
        BottomNavigationBarItem(
          label: 'E-mail'.hardcoded,
          icon: BadgeIcon(
            valid: customer?.Emails != null && customer!.Emails!.isNotEmpty,
            cupertinoIcon: CupertinoIcons.mail,
            materialIcon: Icons.email,
          ),
        ),
        BottomNavigationBarItem(
          label: 'Telefone'.hardcoded,
          icon: BadgeIcon(
            valid:
                customer?.Telephones != null &&
                customer!.Telephones!.isNotEmpty,
            cupertinoIcon: CupertinoIcons.phone,
            materialIcon: Icons.phone,
          ),
        ),
        BottomNavigationBarItem(
          label: 'Convênios'.hardcoded,
          icon: BadgeIcon(
            valid:
                customer?.CustomerCovenants != null &&
                customer!.CustomerCovenants!.isNotEmpty,
            cupertinoIcon: CupertinoIcons.creditcard,
            materialIcon: Icons.wallet,
          ),
        ),
        BottomNavigationBarItem(
          label: 'Salvar'.hardcoded,
          icon: BadgeIcon(
            valid: null,
            cupertinoIcon: CupertinoIcons.check_mark,
            materialIcon: Icons.save,
          ),
        ),
      ],
    );
  }
}
