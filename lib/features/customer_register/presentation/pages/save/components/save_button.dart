import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../controllers/controllers.dart';

class SaveButton extends ConsumerWidget {
  const SaveButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return IconButton(
      onPressed: () async {
        showAlertDialog(
          context: context,
          title: 'Salvar dados?'.hardcoded,
          onOkPressed: () {
            ref
                .read(insertUpdateCustomerControllerProvider.notifier)
                .insertUpdate();
          },
          cancelActionText: 'Cancelar'.hardcoded,
          defaultActionText: 'Salvar'.hardcoded,
        );
      },
      icon: const PlatformIcon(
        cupertinoIcon: CupertinoIcons.checkmark,
        materialIcon: Icons.save,
      ),
    );
  }
}
