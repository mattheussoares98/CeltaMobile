import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../constants/constants.dart';

class BadgeIcon extends StatelessWidget {
  final bool? valid;
  final IconData cupertinoIcon;
  final IconData materialIcon;
  const BadgeIcon({
    super.key,
    required this.cupertinoIcon,
    required this.materialIcon,
    this.valid,
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
        if (valid != null)
          Positioned(
            right: 0,
            top: 0,
            child: Badge(valid: valid!, isIOS: isIOS),
          ),
      ],
    );
  }
}

class Badge extends StatelessWidget {
  final bool valid;
  final bool isIOS;
  const Badge({super.key, required this.valid, required this.isIOS});

  @override
  Widget build(BuildContext context) {
    final size = 17.0;
    if (valid) {
      return Icon(
        isIOS ? CupertinoIcons.checkmark : Icons.check,
        color: Colors.green,
        size: size,
      );
    } else {
      return Icon(
        isIOS ? CupertinoIcons.clear : Icons.close,
        color: Colors.red,
        size: size,
      );
    }
  }
}
