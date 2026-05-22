import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';

class PlatformIcon extends StatelessWidget {
  final IconData cupertinoIcon;
  final IconData materialIcon;
  final Color? color;
  final double? size;

  const PlatformIcon({
    super.key,
    required this.cupertinoIcon,
    required this.materialIcon,
    this.color,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      PlatformUtil.isCupertino ? cupertinoIcon : materialIcon,
      color: color,
      size: size,
    );
  }
}
