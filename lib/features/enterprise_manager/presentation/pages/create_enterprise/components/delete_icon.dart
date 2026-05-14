import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';

class DeleteIcon extends StatelessWidget {
  final VoidCallback? onPress;
  const DeleteIcon({super.key, required this.onPress});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return IconButton(
      onPressed: onPress,
      icon: PlatformIcon(
        cupertinoIcon: CupertinoIcons.delete,
        materialIcon: Icons.delete,
        color: onPress == null ? theme.disabledColor : Colors.red,
      ),
    );
  }
}
