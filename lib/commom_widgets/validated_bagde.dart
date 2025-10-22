import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ValidatedBadge extends StatelessWidget {
  final bool isValid;
  final IconData materialIcon;
  final IconData cupertinoIcon;
  final Color? iconColor;
  const ValidatedBadge({
    super.key,
    required this.isValid,
    required this.materialIcon,
    required this.cupertinoIcon,
    this.iconColor,
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
        color: iconColor ?? theme.disabledColor,
      ),
    );
  }
}
