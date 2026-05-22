import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:celta_inventario/utils/utils.dart';

class DeleteIcon extends StatelessWidget {
  final VoidCallback? onPress;
  const DeleteIcon({super.key, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPress,
      icon: PlatformIcon(
        cupertinoIcon: CupertinoIcons.delete,
        materialIcon: Icons.delete,
        color: onPress == null ? context.theme.disabledColor : Colors.red,
      ),
    );
  }
}
