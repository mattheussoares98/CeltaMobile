import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../commom_widgets.dart';
import 'components.dart';

class DeleteIcon extends StatelessWidget {
  final bool isLoading;
  final TextEditingController searchValueController;
  final FocusNode? focusNode;
  const DeleteIcon({
    super.key,
    required this.isLoading,
    required this.searchValueController,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DefaultIcon(
      onPress: isLoading
          ? null
          : () {
              ShallowProductsOverlay.hide();
              searchValueController.clear();
              Future.delayed(const Duration(milliseconds: 100), () {
                focusNode?.requestFocus();
              });
            },
      materialIcon: Icons.delete,
      cupertinoIcon: CupertinoIcons.delete,
      iconColor: isLoading ? theme.disabledColor : Colors.red,
    );
  }
}
