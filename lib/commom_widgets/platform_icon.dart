import 'package:flutter/material.dart';

class PlatformIcon extends StatelessWidget {
  final IconData materialIcon;
  final IconData cupertinoIcon;
  const PlatformIcon({
    super.key,
    required this.materialIcon,
    required this.cupertinoIcon,
  });
  @override
  Widget build(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    return Icon(isIOS ? cupertinoIcon : materialIcon);
  }
}
