import 'package:flutter/material.dart';

import '../../../../../constants/constants.dart';

class BadgeIcon extends StatelessWidget {
  final Widget? badge;
  final IconData cupertinoIcon;
  final IconData materialIcon;
  const BadgeIcon({
    super.key,
    required this.cupertinoIcon,
    required this.materialIcon,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: Sizes.p8, top: Sizes.p8),
          child: Icon(isIOS ? cupertinoIcon : materialIcon),
        ),
        if (badge != null) Positioned(right: 0, top: 0, child: badge!),
      ],
    );
  }
}
