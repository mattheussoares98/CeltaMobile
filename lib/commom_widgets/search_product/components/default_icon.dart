import 'package:flutter/material.dart';

import '../../../constants/constants.dart';
import '../../commom_widgets.dart';

class DefaultIcon extends StatelessWidget {
  final VoidCallback? onPress;
  final IconData materialIcon;
  final IconData cupertinoIcon;
  final Color? iconColor;
  final bool isLoading;
  final bool showWhenIsSmallPage;

  const DefaultIcon({
    super.key,
    required this.onPress,
    required this.materialIcon,
    required this.cupertinoIcon,
    required this.iconColor,
    this.isLoading = false,
    this.showWhenIsSmallPage = false,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width < 220 && !showWhenIsSmallPage) return const SizedBox.shrink();
    return IconButton(
      visualDensity: VisualDensity.compact,
      onPressed: onPress,
      icon: isLoading
          ? const LoadingWidget(padding: 0, size: Sizes.p16)
          : PlatformIcon(
              cupertinoIcon: cupertinoIcon,
              materialIcon: materialIcon,
              color: iconColor,
              size: 20,
            ),
    );
  }
}
