import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
          icon: Icon(isIOS ? CupertinoIcons.person : Icons.person),
        ),
        BottomNavigationBarItem(
          label: 'Endereço'.hardcoded,
          icon: _ValidatedBadge(
            isValid:
                customer?.Addresses != null && customer!.Addresses!.isNotEmpty,
            materialIcon: Icons.location_on,
            cupertinoIcon: CupertinoIcons.location,
          ),
        ),
        BottomNavigationBarItem(
          label: 'E-mail'.hardcoded,
          icon: _ValidatedBadge(
            isValid:
                customer?.Addresses != null && customer!.Addresses!.isNotEmpty,
            materialIcon: Icons.email,
            cupertinoIcon: CupertinoIcons.mail,
          ),
        ),
        BottomNavigationBarItem(
          label: 'Telefone'.hardcoded,
          icon: _ValidatedBadge(
            isValid:
                customer?.Addresses != null && customer!.Addresses!.isNotEmpty,
            materialIcon: Icons.phone,
            cupertinoIcon: CupertinoIcons.phone,
          ),
        ),
        BottomNavigationBarItem(
          label: 'Convênios'.hardcoded,
          icon: _ValidatedBadge(
            isValid:
                customer?.Addresses != null && customer!.Addresses!.isNotEmpty,
            materialIcon: Icons.wallet,
            cupertinoIcon: CupertinoIcons.creditcard,
          ),
        ),
        BottomNavigationBarItem(
          label: 'Salvar'.hardcoded,
          icon: Icon(isIOS ? CupertinoIcons.check_mark : Icons.save),
        ),
      ],
    );
  }
}

class _ValidatedBadge extends StatelessWidget {
  final bool isValid;
  final IconData materialIcon;
  final IconData cupertinoIcon;
  const _ValidatedBadge({
    required this.isValid,
    required this.materialIcon,
    required this.cupertinoIcon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    return Badge(
      offset: const Offset(8, -6),
      backgroundColor: Colors.transparent,
      label: Icon(
        isValid
            ? (isIOS ? CupertinoIcons.checkmark : Icons.check)
            : (isIOS ? CupertinoIcons.clear : Icons.close),
        color: isValid ? Colors.green : Colors.red,
        size: 17,
      ),
      child: Icon(
        isIOS ? cupertinoIcon : materialIcon,
        color: theme.disabledColor,
      ),
    );
  }
}
