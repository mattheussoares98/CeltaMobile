import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/presentation/controllers/keyboard/keyboard/keyboard.dart';
import '../../../../../localization/string_hardcoded.dart';
import '../../../domain/entities/entities.dart';
import '../../controllers/controllers.dart';

class SaveFloatingButton extends ConsumerWidget {
  final DraftKey draftKey;
  const SaveFloatingButton({super.key, required this.draftKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    final cartIsEmpty = ref.watch(
      cartProductsStateControllerProvider(
        draftKey,
      ).select((s) => s.value?.isEmpty ?? true),
    );

    return Padding(
      padding: EdgeInsets.only(
        bottom: ref.watch(keyboardVisibilityStateControllerProvider)
            ? Sizes.p48
            : 0,
      ),
      child: FloatingActionButton(
        backgroundColor: cartIsEmpty
            ? Colors.grey
            : theme.primaryColor.withAlpha(170),
        onPressed: cartIsEmpty
            ? null
            : () {
                showAlertDialog(
                  context: context,
                  title: 'Salvar pedido?'.hardcoded,
                  cancelActionText: 'Cancelar'.hardcoded,
                  defaultActionText: 'Sim'.hardcoded,
                  onOkPressed: ref
                      .read(
                        insertTransferRequestControllerProvider(
                          draftKey,
                        ).notifier,
                      )
                      .insert,
                );
              },
        child: Icon(
          isIOS ? CupertinoIcons.check_mark : Icons.save_rounded,
          color: Colors.white,
        ),
      ),
    );
  }
}
