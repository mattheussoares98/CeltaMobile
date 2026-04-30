import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../localization/string_hardcoded.dart';
import '../commom_widgets.dart';

class DeleteItemButton extends StatelessWidget {
  final VoidCallback? onDelete;
  const DeleteItemButton({super.key, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onDelete == null
          ? null
          : () {
              FocusManager.instance.primaryFocus?.unfocus();
              showAlertDialog(
                context: context,
                title: 'Remover item?'.hardcoded,
                onOkPressed: onDelete,
                cancelActionText: 'Cancelar'.hardcoded,
                defaultActionText: 'Remover'.hardcoded,
              );
            },
      icon: const PlatformIcon(
        cupertinoIcon: CupertinoIcons.delete,
        materialIcon: Icons.delete,
        color: Colors.red,
      ),
    );
  }
}
