import 'package:flutter/material.dart';

class PlatformIcon extends StatelessWidget {
  final IconData materialIcon;
  final IconData cupertinoIcon;
  final Color? color;
  final double? size;

  const PlatformIcon({
    super.key,
    required this.materialIcon,
    required this.cupertinoIcon,
    this.color,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    return Icon(
      isIOS ? cupertinoIcon : materialIcon,
      color: color,
      size: size,
    );
  }
}
