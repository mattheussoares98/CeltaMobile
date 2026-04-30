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
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    return Icon(isIOS ? cupertinoIcon : materialIcon, color: color, size: size);
  }
}
