import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DefaultDeleteIcon extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  const DefaultDeleteIcon(this.controller, this.focusNode, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;
    return IconButton(
      focusNode: FocusNode(skipTraversal: true),
      onPressed: () {
        controller.clear();
        if (!focusNode.hasFocus) {
          focusNode.requestFocus();
        }
      },
      icon: Icon(
        isIOS ? CupertinoIcons.delete : Icons.delete,
        color: Colors.red,
      ),
    );
  }
}
