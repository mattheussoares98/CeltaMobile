import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';

class DefaultDeleteIcon extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  const DefaultDeleteIcon(this.controller, this.focusNode, {super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      focusNode: FocusNode(skipTraversal: true),
      onPressed: () {
        controller.clear();
        if (!focusNode.hasFocus) {
          focusNode.requestFocus();
        }
      },
      icon: const PlatformIcon(
        cupertinoIcon: CupertinoIcons.delete,
        materialIcon: Icons.delete,
        color: Colors.red,
      ),
    );
  }
}
