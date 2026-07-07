import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/commom_widgets/search_product/components/components.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      iconColor: isLoading ? context.theme.disabledColor : Colors.red,
    );
  }
}
