import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DeleteItemButton extends StatelessWidget {
  final VoidCallback? onDelete;
  const DeleteItemButton({super.key, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: IconButton(
        onPressed: onDelete == null
            ? null
            : () async {
                FocusManager.instance.primaryFocus?.unfocus();
                final result = await showAlertDialog(
                  context: context,
                  title: 'Remover item?'.hardcoded,
                  cancelActionText: 'Cancelar'.hardcoded,
                  defaultActionText: 'Remover'.hardcoded,
                );
                if (result == true && context.mounted) {
                  onDelete?.call();
                }
              },
        icon: const PlatformIcon(
          cupertinoIcon: CupertinoIcons.delete,
          materialIcon: Icons.delete,
          color: Colors.red,
        ),
      ),
    );
  }
}
