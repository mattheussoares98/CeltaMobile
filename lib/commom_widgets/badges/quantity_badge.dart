import 'package:flutter/material.dart';

class QuantityBadge extends StatelessWidget {
  final int? quantity;
  final IconData materialIcon;
  final IconData cupertinoIcon;
  final bool isSelected;
  const QuantityBadge({
    super.key,
    required this.quantity,
    required this.materialIcon,
    required this.cupertinoIcon,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;
    return Badge(
      offset: const Offset(8, -6),
      backgroundColor: Colors.transparent,
      label: CircleAvatar(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        radius: 10,
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Center(
            child: FittedBox(child: Text(quantity?.toString() ?? '0')),
          ),
        ),
      ),
      child: Icon(
        isIOS ? cupertinoIcon : materialIcon,
        color: isSelected ? theme.primaryColor : theme.disabledColor,
      ),
    );
  }
}
