import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DeleteIcon extends StatelessWidget {
  final VoidCallback? onPress;
  const DeleteIcon({super.key, required this.onPress});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return IconButton(
      onPressed: onPress,
      icon: Icon(
        theme.platform == TargetPlatform.iOS
            ? CupertinoIcons.delete
            : Icons.delete,
        color: onPress == null ? theme.disabledColor : Colors.red,
      ),
    );
  }
}
