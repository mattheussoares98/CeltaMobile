import 'package:celta_inventario/core/presentation/controllers/keyboard/keyboard/keyboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../controllers/controllers.dart';

class FloatingSaveButton extends ConsumerWidget {
  final TextEditingController observationsController;
  const FloatingSaveButton({super.key, required this.observationsController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartIsEmpty = ref.watch(
      pendingBuyRequestStateControllerProvider.select(
        (s) => s.value?.products?.isEmpty ?? true,
      ),
    );
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;
    return Padding(
      padding: EdgeInsets.only(
        bottom: ref.watch(keyboardVisibilityStateControllerProvider)
            ? Sizes.p48
            : 0,
      ),
      child: FloatingActionButton(
        onPressed: cartIsEmpty
            ? null
            : () {
                showAlertDialog(
                  context: context,
                  title: 'Salvar pedido?'.hardcoded,
                  cancelActionText: 'Cancelar'.hardcoded,
                  defaultActionText: 'Sim'.hardcoded,
                  onOkPressed: () async {
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
                  },
                );
              },
        backgroundColor: cartIsEmpty
            ? Colors.grey
            : theme.primaryColor.withAlpha(200),
        child: Icon(isIOS ? CupertinoIcons.checkmark : Icons.save),
      ),
    );
  }
}
