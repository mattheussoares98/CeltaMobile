import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../localization/string_hardcoded.dart';
import '../commom_widgets.dart';

class DeleteItemButton extends StatelessWidget {
  final VoidCallback? onDelete;
  const DeleteItemButton({super.key, this.onDelete});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;
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
      icon: Icon(
        isIOS ? CupertinoIcons.delete : Icons.delete,
        color: Colors.red,
      ),
    );
  }
}
