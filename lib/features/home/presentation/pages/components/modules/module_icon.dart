import 'package:flutter/material.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';

class ModuleIcon extends StatelessWidget {
  const ModuleIcon({super.key, required this.platformIcon});

  final PlatformIcon platformIcon;

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
      child: platformIcon,
    );
  }
}
