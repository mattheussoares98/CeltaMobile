import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:celta_inventario/utils/utils.dart';

class ModuleIcon extends StatelessWidget {
  const ModuleIcon({super.key, required this.platformIcon});

  final PlatformIcon platformIcon;

  @override
  Widget build(BuildContext context) {
    final color = context.theme.primaryColor;
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
