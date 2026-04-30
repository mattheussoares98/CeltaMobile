import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../commom_widgets.dart';

class ValidatedBadge extends StatelessWidget {
  final bool isValid;
  final IconData materialIcon;
  final IconData cupertinoIcon;
  final bool isSelected;
  const ValidatedBadge({
    super.key,
    required this.isValid,
    required this.materialIcon,
    required this.cupertinoIcon,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Badge(
      offset: const Offset(8, -6),
      backgroundColor: Colors.transparent,
      label: PlatformIcon(
        cupertinoIcon: isValid
            ? CupertinoIcons.checkmark
            : CupertinoIcons.clear,
        materialIcon: isValid ? Icons.check : Icons.close,
        color: isValid ? Colors.green : Colors.red,
        size: 17,
      ),
      child: PlatformIcon(
        cupertinoIcon: cupertinoIcon,
        materialIcon: materialIcon,
        color: isSelected ? theme.primaryColor : theme.disabledColor,
      ),
    );
  }
}
