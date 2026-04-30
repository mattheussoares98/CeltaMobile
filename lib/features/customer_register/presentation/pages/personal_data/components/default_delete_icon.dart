import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';

class DefaultDeleteIcon extends StatelessWidget {
  final TextEditingController controller;
  const DefaultDeleteIcon({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: controller.clear,
      icon: const PlatformIcon(
        cupertinoIcon: CupertinoIcons.delete,
        materialIcon: Icons.delete,
        color: Colors.red,
      ),
    );
  }
}
