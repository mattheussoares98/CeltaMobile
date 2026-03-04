import 'package:flutter/material.dart';

import '../../../../../../constants/constants.dart';

class ModuleIcon extends StatelessWidget {
  const ModuleIcon({super.key, required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.primaryColor;
    return Container(
      padding: const EdgeInsets.all(Sizes.p8),
      decoration: BoxDecoration(
        color: color.withAlpha(50),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color),
    );
  }
}
