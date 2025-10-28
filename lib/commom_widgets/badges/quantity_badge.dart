import 'package:flutter/material.dart';

class QuantityBadge extends StatelessWidget {
  final int? quantity;
  final IconData materialIcon;
  final IconData cupertinoIcon;
  final bool isSelected;
  final Widget? subtitle;
  final Offset? offset;
  const QuantityBadge({
    super.key,
    required this.quantity,
    required this.materialIcon,
    required this.cupertinoIcon,
    required this.isSelected,
    this.subtitle,
    this.offset,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    bool isSmall = (quantity?.toString() ?? '0').length <= 1;
    return Badge(
      offset: offset ?? const Offset(8, -6),
      backgroundColor: Colors.transparent,
      label: CircleAvatar(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        radius: isSmall ? 8 : 10,
        child: Padding(
          padding: EdgeInsets.all(isSmall ? 1 : 2),
          child: Center(
            child: FittedBox(child: Text(quantity?.toString() ?? '0')),
          ),
        ),
      ),
      child: Column(
        children: [
          Icon(
            isIOS ? cupertinoIcon : materialIcon,
            color: isSelected ? theme.primaryColor : theme.disabledColor,
          ),
          ?subtitle,
        ],
      ),
    );
  }
}
