import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../commom_widgets.dart';

class ValidatedBadge extends StatelessWidget {
  final bool isValid;
  final PlatformIcon platformIcon;
  final bool isSelected;
  const ValidatedBadge({
    super.key,
    required this.isValid,
    required this.platformIcon,
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
        cupertinoIcon: platformIcon.cupertinoIcon,
        materialIcon: platformIcon.materialIcon,
        color: isSelected ? theme.primaryColor : theme.disabledColor,
      ),
    );
  }
}
