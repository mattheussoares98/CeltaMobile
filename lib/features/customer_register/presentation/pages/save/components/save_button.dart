import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/customer_register/presentation/controllers/controllers.dart';

class SaveButton extends ConsumerWidget {
  const SaveButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () async {
        final confirmed = await showAlertDialog(
          context: context,
          title: context.l10n.saveDetails,
          cancelActionText: context.l10n.cancel,
          defaultActionText: context.l10n.save,
        );

        if (confirmed != true || !context.mounted) return;
        ref
            .read(insertUpdateCustomerControllerProvider.notifier)
            .insertUpdate();
      },
      icon: const PlatformIcon(
        cupertinoIcon: CupertinoIcons.checkmark,
        materialIcon: Icons.save,
      ),
    );
  }
}
