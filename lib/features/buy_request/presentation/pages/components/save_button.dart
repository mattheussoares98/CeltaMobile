import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../localization/string_hardcoded.dart';
import '../../controllers/controllers.dart';

class SaveButton extends ConsumerWidget {
  final TextEditingController observationsController;
  const SaveButton({super.key, required this.observationsController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartIsEmpty = ref.watch(
      pendingBuyRequestStateControllerProvider.select(
        (s) => s.value?.products?.isEmpty ?? true,
      ),
    );

    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    return PrimaryTextButton(
      text: cartIsEmpty ? 'Insira produtos' : 'Salvar'.hardcoded,
      icon: Icon(isIOS ? CupertinoIcons.checkmark : Icons.save),
      onPressed: cartIsEmpty
          ? null
          : () async {
              bool? pressed = await showAlertDialog(
                context: context,
                title: 'Salvar pedido?'.hardcoded,
                cancelActionText: 'Cancelar'.hardcoded,
                defaultActionText: 'Sim'.hardcoded,
                onOkPressed: () async {},
              );

              if (pressed == true) {
                FocusManager.instance.primaryFocus?.unfocus();
                final succeeds = await ref
                    .read(insertBuyRequestControllerProvider.notifier)
                    .insert(observationsController.text);

                if (succeeds) {
                  showSnackBarMessage(
                    context,
                    'Pedido salvo com sucesso'.hardcoded,
                  );
                  observationsController.clear();
                }
              }
            },
    );
  }
}
