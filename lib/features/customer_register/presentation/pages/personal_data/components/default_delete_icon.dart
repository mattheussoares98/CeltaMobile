import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DefaultDeleteIcon extends StatelessWidget {
  final TextEditingController controller;
  const DefaultDeleteIcon({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIos = theme.platform == TargetPlatform.iOS;

    return IconButton(
      onPressed: controller.clear,
      icon: Icon(
        isIos ? CupertinoIcons.delete : Icons.delete,
        color: Colors.red,
      ),
    );
  }
}
